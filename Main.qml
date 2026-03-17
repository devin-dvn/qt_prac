import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 900
    height: 600
    visible: true
    color: "#1e1e1e"
    flags: Qt.Window | Qt.FramelessWindowHint // 타이틀바 제거

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // --- 수정된 커스텀 타이틀 바 ---
        Rectangle {
            id: titleBar
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "#2c2c2c"

            // 1. 밀림 방지를 위한 MouseArea 방식 창 이동
            MouseArea {
                anchors.fill: parent
                property point clickPos: "0,0"

                onPressed: (mouse) => {
                    clickPos = Qt.point(mouse.x, mouse.y)
                }

                onPositionChanged: (mouse) => {
                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    root.x += delta.x
                    root.y += delta.y
                }

                // 더블 클릭 시 최대화/이전 크기 복원 (선택 사항)
                onDoubleClicked: {
                    if (root.visibility === Window.Maximized) root.showNormal()
                    else root.showMaximized()
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 15
                // 이벤트가 MouseArea에 막히지 않도록 Z축 설정 가능
                z: 1

                // A. 왼쪽 버튼 (버튼 위에서는 마우스 이벤트가 버튼으로 가야 함)
                Row {
                    spacing: 8
                    Rectangle { width: 12; height: 12; radius: 6; color: "#ff5f56"; TapHandler { onTapped: Qt.quit() } }
                    Rectangle { width: 12; height: 12; radius: 6; color: "#ffbd2e"; TapHandler { onTapped: root.showMinimized() } }
                    Rectangle { width: 12; height: 12; radius: 6; color: "#27c93f"; TapHandler { onTapped: root.visibility === Window.Maximized ? root.showNormal() : root.showMaximized() } }
                }

                // B. 중앙 검색바 (이미지와 동일하게 스타일링)
                Rectangle {
                    Layout.preferredWidth: 450
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignCenter
                    color: "#3d3d3d"
                    radius: 4
                    border.color: "#4d4d4d"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        Text { text: "🔍"; color: "#858585"; font.pixelSize: 11 }
                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "Project Name (Search)"
                            color: "white"
                            font.pixelSize: 12
                            background: null
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }

                // 우측 여백 확보용 Item
                Item { Layout.fillWidth: true }
            }
        }

        // 컨텐츠 영역
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1e1e1e"
            Text {
                anchors.centerIn: parent
                text: "hello world!"
                color: "white"
                font.pixelSize: 20
            }
        }
    }
}
