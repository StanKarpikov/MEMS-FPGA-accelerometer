/****************************************************************************
**
** Copyright (C) 2012 Denis Shienkov <denis.shienkov@gmail.com>
** Copyright (C) 2012 Laszlo Papp <lpapp@kde.org>
** Contact: http://www.qt.io/licensing/
**
** This file is part of the QtSerialPort module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL21$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** As a special exception, The Qt Company gives you certain additional
** rights. These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtCore/QtGlobal>
#include <QDebug>
#include <QMainWindow>
#include <windows.h>
#include "qcustomplot.h"
#include <QtSerialPort/QSerialPort>
#include "dialogconfig.h"

QT_BEGIN_NAMESPACE

extern OVERLAPPED overlappedR;						//Для операций чтения(структура необходима для асинхронных операций)
extern OVERLAPPED overlappedW;						//Для операций записи
extern char bufrd[65535],bufwr[255];			//Буферы для приёма и передачи
extern HANDLE reader,writer;						//Потоки чтения и записи
extern HANDLE COMport;
extern DCB ComDCM;

namespace Ui {
class MainWindow;
}

QT_END_NAMESPACE

class SettingsDialog;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    QCustomPlot *customPlot;
    QTimer dataTimer;
    double ACCdata,Freq;
    int ACCN;
    double Range;
    quint32 DATA,T1,T2;
    quint16 REG;
    quint8 Command;
    quint8 Addr_SRC;
    quint8 Addr_DST;
    QVector<double>  md;
    int Filter;
    quint16  CRC16CCITT(QByteArray bytes, quint16 N);
    void  UpdateData();
    void  SendRequest(quint8 AddrDST,quint8 Comm,quint16 Reg,quint32 Data);
public slots:
    void openSerialPort();
    void closeSerialPort();
    void about();
    void writeData(const QByteArray &data);
    void readData();
    void handleError(QString error);
    void Receive(QByteArray newdata);
    void realtimeDataSlot();

private slots:
    void on_action_0_005_triggered();

    void on_action_0_5_triggered();

    void on_action_0_1_triggered();

    void on_action_0_05_triggered();

    void on_action_0_01_triggered();

    void on_action_0_001_triggered();

    void on_action_triggered();

    void on_action_30_triggered();

    void on_action_100_triggered();

    void on_action_200_triggered();

    void on_action_2_triggered();

    void tochange(quint32 value,int var);
private:
    void initActionsConnections();

private:
    Ui::MainWindow *ui;
    SettingsDialog *settings;
    QSerialPort *serial;
    DialogConfig *config;
};
extern MainWindow *w;
#endif // MAINWINDOW_H
