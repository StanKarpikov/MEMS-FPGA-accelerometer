#ifndef COMREAD_H
#define COMREAD_H
#include <QObject>
#include <windows.h>


class COMRead : public QObject{
   Q_OBJECT
public:
    explicit COMRead(QObject *parent = 0);
    HANDLE COMport;
    DCB ComDCM;
    void open();
public slots:
    void process();
signals:
    void finished();
    void error(QString err);
};

#endif // COMREAD_H
