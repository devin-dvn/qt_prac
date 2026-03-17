#ifndef FILEIO_H
#define FILEIO_H

#include <QUrl>


#include <QObject>
#include <QFile>
#include <QTextStream>

class FileIO : public QObject {
    Q_OBJECT
public:
    explicit FileIO(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QString readFile(const QString &sourceUrl) {
        if (sourceUrl.isEmpty()) return "";

        // 2. QString(URL 형태)을 QUrl로 바꾼 뒤 로컬 경로로 변환
        QUrl url(sourceUrl);
        QString localPath = url.toLocalFile();

        // 만약 전달된 게 URL이 아니라 이미 일반 경로라면 그대로 사용
        if (localPath.isEmpty()) localPath = sourceUrl;

        QFile file(localPath);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return "";

        return QTextStream(&file).readAll();
    }

    Q_INVOKABLE bool saveFile(const QString &sourceUrl, const QString &data) {
        if (sourceUrl.isEmpty()) return false;

        QUrl url(sourceUrl);
        QString localPath = url.toLocalFile();
        if (localPath.isEmpty()) localPath = sourceUrl;

        QFile file(localPath);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) return false;

        QTextStream out(&file);
        out << data;
        return true;
    }
};
#endif
