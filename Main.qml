import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs // 파일 탐색기를 위해 필요

Window {
    width: 600
    height: 400
    visible: true

    // 1. 현재 파일 경로를 기억할 변수 (초기값은 비어있음)
    property string currentFilePath: ""

    // 2. 제목(title)을 변수와 연동 (파일이 없으면 '제목 없음', 있으면 경로 표시)
    title: currentFilePath === "" ? "나의 메모장 - 제목 없음" : "나의 메모장 - " + currentFilePath


    // 파일 열기 대화상자 수정
    FileDialog {
        id: openDialog
        onAccepted: {
            // 파일을 열 때 경로를 저장하고 제목을 바꿉니다.
            currentFilePath = selectedFile.toString()
            memoArea.text = fileIO.readFile(currentFilePath)
            root.title = "메모장 - " + currentFilePath
        }
    }

    // 파일 저장 대화상자 수정
    FileDialog {
        id: saveDialog
        fileMode: FileDialog.SaveFile
        onAccepted: {
            // 새 이름으로 저장했을 때도 경로를 기억합니다.
            currentFilePath = selectedFile.toString()
            fileIO.saveFile(currentFilePath, memoArea.text)
            root.title = "메모장 - " + currentFilePath
        }
    }

    // 2. 단축키 로직 변경 (핵심!)
    Shortcut {
        sequence: "Ctrl+S"
        context: Qt.ApplicationShortcut
        onActivated: {
            if (currentFilePath === "") {
                // 저장된 경로가 없으면(새 문서) 대화상자를 띄움
                saveDialog.open()
            } else {
                // 이미 열린 파일이 있으면 대화상자 없이 바로 C++ 호출!
                let success = fileIO.saveFile(currentFilePath, memoArea.text)
                if (success) {
                    console.log("즉시 저장 완료: " + currentFilePath)
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 상단 버튼 바
        RowLayout {
            Layout.fillWidth: true
            Button { text: "열기"; onClicked: openDialog.open() }
            Button { text: "저장"; onClicked: saveDialog.open() }
            Button { text: "지우기"; onClicked: memoArea.clear() }
        }

        // 텍스트 입력 영역
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextArea {
                id: memoArea
                placeholderText: "여기에 내용을 입력하세요..."
                font.pixelSize: 16
                selectByMouse: true
            }
        }
    }

}
