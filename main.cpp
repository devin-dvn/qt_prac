#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>  // 1. 이 헤더가 있어야 합니다.
#include "fileio.h"     // 2. 작성하신 클래스 헤더

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 3. C++ 객체 생성 (실제 메모리에 올림)
    FileIO fileIO;

    QQmlApplicationEngine engine;

    // 4. QML 세상에 "fileIO"라는 이름으로 이 객체를 전달 (가장 핵심!)
    // 이 줄이 engine.load() 보다 위에 있어야 QML이 로딩될 때 이름을 인식합니다.
    engine.rootContext()->setContextProperty("fileIO", &fileIO);

    // 5. QML 로드
    engine.loadFromModule("Prac01", "Main");

    return app.exec();
}
