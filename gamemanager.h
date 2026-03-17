#ifndef GAMEMANAGER_H
#define GAMEMANAGER_H

#include <QObject>
#include <QStringList>

class GameManager : public QObject
{
    Q_OBJECT
public:
    explicit GameManager(QObject *parent = nullptr) : QObject(parent) {}

    // Q_INVOKABLE: QML에서 이 함수를 호출할 수 있게 해줍니다.
    Q_INVOKABLE QString checkWinner(const QStringList &board) {
        const int lines[8][3] = {
            {0, 1, 2}, {3, 4, 5}, {6, 7, 8}, // 가로
            {0, 3, 6}, {1, 4, 7}, {2, 5, 8}, // 세로
            {0, 4, 8}, {2, 4, 6}             // 대각선
        };

        for (int i = 0; i < 8; ++i) {
            int a = lines[i][0], b = lines[i][1], c = lines[i][2];
            if (!board[a].isEmpty() && board[a] == board[b] && board[a] == board[c]) {
                return board[a];
            }
        }

        if (!board.contains("")) return "Draw";
        return "";
    }
};

#endif // GAMEMANAGER_H
