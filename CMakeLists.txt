cmake_minimum_required(VERSION 3.16)

project(Prac01 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appPrac01
    main.cpp
)

qt_add_qml_module(appPrac01
    URI Prac01
    QML_FILES
        Main.qml
        SOURCES gamemanager.h
        SOURCES fileio.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPrac01 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPrac01
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPrac01
    PRIVATE Qt6::Quick
    dwmapi  # <-- 이 부분 추가
)

install(TARGETS appPrac01
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
