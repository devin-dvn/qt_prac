#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QAbstractNativeEventFilter>
#include <windows.h>
#include <dwmapi.h>
#include <QQmlContext>  // 1. 이 헤더가 있어야 합니다.
#include "fileio.h"     // 2. 작성하신 클래스 헤더

class WinEventFilter : public QAbstractNativeEventFilter {
public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result) override {
        if (eventType == "windows_generic_MSG") {
            MSG *msg = static_cast<MSG *>(message);

            // [추가] 배경 지우기 메시지 차단 (깜빡임 및 검은 배경 방지)
            if (msg->message == WM_ERASEBKGND) {
                *result = 1;
                return true;
            }

            if (msg->message == WM_NCCALCSIZE && msg->wParam == TRUE) {
                return true;
            }

            if (msg->message == WM_NCHITTEST) {
                const int borderWidth = 8;
                POINTS pts = MAKEPOINTS(msg->lParam);
                POINT pt = { pts.x, pts.y };
                RECT rect;
                GetWindowRect(msg->hwnd, &rect);

                bool left = pt.x < rect.left + borderWidth;
                bool right = pt.x >= rect.right - borderWidth;
                bool top = pt.y < rect.top + borderWidth;
                bool bottom = pt.y >= rect.bottom - borderWidth;

                LRESULT hit = HTCLIENT;

                if (top && left) hit = HTTOPLEFT;
                else if (top && right) hit = HTTOPRIGHT;
                else if (bottom && left) hit = HTBOTTOMLEFT;
                else if (bottom && right) hit = HTBOTTOMRIGHT;
                else if (top) hit = HTTOP;
                else if (bottom) hit = HTBOTTOM;
                else if (left) hit = HTLEFT;
                else if (right) hit = HTRIGHT;
                else if (pt.y < rect.top + 35) hit = HTCAPTION;

                if (hit != HTCLIENT) {
                    *result = hit;
                    return true;
                }
            }
        }
        return false;
    }
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 이벤트 필터 등록
    WinEventFilter filter;
    app.installNativeEventFilter(&filter);

    // 3. C++ 객체 생성 (실제 메모리에 올림)
    FileIO fileIO;

    QQmlApplicationEngine engine;

    // 4. QML 세상에 "fileIO"라는 이름으로 이 객체를 전달 (가장 핵심!)
    // 이 줄이 engine.load() 보다 위에 있어야 QML이 로딩될 때 이름을 인식합니다.
    engine.rootContext()->setContextProperty("fileIO", &fileIO);

    // 5. QML 로드
    engine.loadFromModule("Prac01", "Main");



    // QML 로드 후 윈도우 핸들을 가져와서 스타일 수정
    if (!engine.rootObjects().isEmpty()) {
        QWindow *window = qobject_cast<QWindow *>(engine.rootObjects().first());
        if (window) {
            HWND hwnd = (HWND)window->winId();

            // 1. 기존 스타일 설정
            LONG_PTR style = GetWindowLongPtr(hwnd, GWL_STYLE);
            style |= WS_THICKFRAME | WS_CAPTION | WS_MAXIMIZEBOX | WS_MINIMIZEBOX;
            SetWindowLongPtr(hwnd, GWL_STYLE, style);

            // 2. [추가] 배경 브러시 제거 (검은색 잔상 방지 핵심)
            SetClassLongPtr(hwnd, GCLP_HBRBACKGROUND, (LONG_PTR)NULL);

            // 3. DWM 확장 및 업데이트
            MARGINS margins = {1, 1, 1, 1};
            DwmExtendFrameIntoClientArea(hwnd, &margins);
            SetWindowPos(hwnd, nullptr, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER);
        }
    }
    return app.exec();
}
