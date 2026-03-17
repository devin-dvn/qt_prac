#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QAbstractNativeEventFilter>
#include <windows.h>
#include <dwmapi.h>
#include <QQmlContext>  // 1. 이 헤더가 있어야 합니다.
#include "fileio.h"     // 2. 작성하신 클래스 헤더

// 윈도우 메시지를 가로채서 타이틀바를 지우는 클래스
class WinEventFilter : public QAbstractNativeEventFilter {
public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *) override {
        if (eventType == "windows_generic_MSG") {
            MSG *msg = static_cast<MSG *>(message);
            if (msg->message == WM_NCCALCSIZE && msg->wParam == TRUE) {
                // 타이틀바 영역을 없애고 클라이언트 영역을 창 전체로 확장
                return true;
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

            // 기존 스타일 유지 + 스냅을 위한 프레임 유지
            LONG_PTR style = GetWindowLongPtr(hwnd, GWL_STYLE);
            style |= WS_THICKFRAME | WS_CAPTION | WS_MAXIMIZEBOX | WS_MINIMIZEBOX;
            SetWindowLongPtr(hwnd, GWL_STYLE, style);

            // 그림자 및 에어로 기능을 위한 DWM 확장
            MARGINS margins = {1, 1, 1, 1};
            DwmExtendFrameIntoClientArea(hwnd, &margins);

            SetWindowPos(hwnd, nullptr, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER);
        }
    }
    return app.exec();
}
