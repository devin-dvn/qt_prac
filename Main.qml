import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 900
    height: 600
    visible: true
    color: "#1e1e1e" // 전체 배경색 (VS Code 느낌)

    // 1. 기본 타이틀바 제거
    flags: Qt.Window | Qt.FramelessWindowHint

    property string currentFilePath: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // --- 커스텀 타이틀 바 시작 ---
        Rectangle {
            id: titleBar
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "#2c2c2c" // 타이틀바 배경색

            // 창 드래그 기능 (타이틀 바를 잡고 움직일 수 있게 함)
            DragHandler {
                onActiveChanged: if (active) root.startSystemMove()
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 15

                // A. 왼쪽: 윈도우 조작 버튼 (macOS 스타일)
                Row {
                    spacing: 8
                    Rectangle { width: 12; height: 12; radius: 6; color: "#ff5f56"; TapHandler { onTapped: Qt.quit() } }
                    Rectangle { width: 12; height: 12; radius: 6; color: "#ffbd2e"; TapHandler { onTapped: root.showMinimized() } }
                    Rectangle { width: 12; height: 12; radius: 6; color: "#27c93f"; TapHandler { onTapped: root.visibility === Window.Maximized ? root.showNormal() : root.showMaximized() } }
                }

                // B. 중앙: 검색 바 (핵심!)
                Rectangle {
                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignCenter
                    color: "#3d3d3d"
                    radius: 6
                    border.color: "#555555"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        Text { text: "🔍"; color: "#aaaaaa"; font.pixelSize: 12 }

                        TextField {
                            id: topSearchInput
                            Layout.fillWidth: true
                            placeholderText: "Search Project..."
                            color: "white"
                            font.pixelSize: 13
                            background: null // 배경 제거
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }

                // C. 오른쪽: 파일 이름 표시 (여백용)
                Text {
                    Layout.fillWidth: true
                    text: currentFilePath === "" ? "Untitled" : currentFilePath
                    color: "#888888"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideMiddle
                }
            }
        }
        // --- 커스텀 타이틀 바 끝 ---

        // 기존 메모장 내용 영역
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextArea {
                id: memoArea
                color: "#d4d4d4"
                font.pixelSize: 16
                placeholderText: "내용을 입력하세요..."
                background: Rectangle { color: "#1e1e1e" }
            }
        }
    }
}
