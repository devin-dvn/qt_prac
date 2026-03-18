import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 1000
    height: 700
    visible: true
    color: "#1e1e1e"

    // [중요] Win + 방향키 단축키를 살리기 위해 FramelessWindowHint를 쓰지 않습니다.
    // 대신 시스템 타이틀바를 커스텀할 수 있도록 아래 플래그들을 사용합니다.
    // flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // --- 네이티브 이동(에어로 스냅) 지원 타이틀 바 ---
        Rectangle {
            id: titleBar
            Layout.fillWidth: true
            Layout.preferredHeight: 35
            color: "#2c2c2c"

            // 1. 네이티브 윈도우 이동 명령 호출 (에러 수정 부분)
            MouseArea {
                anchors.fill: parent
                // 클릭하는 순간 OS에게 "창 옮겨줘!"라고 권한을 넘깁니다.
                // 이래야 윈도우가 '스냅' 기능을 인식합니다.
                onPressed: root.startSystemMove()

                // 더블 클릭 시 최대화/복구
                onDoubleClicked: {
                    if (root.visibility === Window.Maximized) root.showNormal()
                    else root.showMaximized()
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 12

                // A. 왼쪽 버튼 (MouseArea 위에 있어야 하므로 z값 설정)
                Row {
                    spacing: 8
                    z: 10
                    Rectangle {
                        width: 12; height: 12; radius: 6; color: "#ff5f56"
                        MouseArea { anchors.fill: parent; onClicked: Qt.quit() }
                    }
                    Rectangle {
                        width: 12; height: 12; radius: 6; color: "#ffbd2e"
                        MouseArea { anchors.fill: parent; onClicked: root.showMinimized() }
                    }
                    Rectangle {
                        width: 12; height: 12; radius: 6; color: "#27c93f"
                        MouseArea { anchors.fill: parent; onClicked: root.visibility === Window.Maximized ? root.showNormal() : root.showMaximized() }
                    }
                }

                // B. 중앙 검색바 (VS Code 스타일)
                Rectangle {
                    Layout.preferredWidth: 450
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignCenter
                    color: "#3d3d3d"
                    radius: 4
                    border.color: "#4d4d4d"
                    z: 10 // 검색바 클릭 시 창이 드래그되지 않도록 위로 올림

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        Text { text: "🔍"; color: "#858585"; font.pixelSize: 11 }
                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "Search Project (VS Code Style)"
                            color: "white"
                            font.pixelSize: 12
                            background: null
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }

                // 우측 여백 (정렬용)
                Item { Layout.fillWidth: true }
            }
        }

        // 메인 컨텐츠
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1e1e1e"
            Text {
                anchors.centerIn: parent
                text: "Win + 방향키를 눌러보거나,\n상단바를 화면 끝으로 드래그해보세요."
                color: "#aaaaaa"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
            }
        }
    }
}
