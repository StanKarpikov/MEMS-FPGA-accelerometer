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

#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "console.h"
#include "settingsdialog.h"

#include <QMessageBox>
#include <QtSerialPort/QSerialPort>
#include "QSwitch.h"
//! [0]
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
//! [0]
    ui->setupUi(this);

    settings = new SettingsDialog;

    ui->actionConnect->setEnabled(true);
    ui->actionDisconnect->setEnabled(false);
    ui->actionQuit->setEnabled(true);
    ui->actionConfigure->setEnabled(true);

    initActionsConnections();
//-----------
    customPlot=new QCustomPlot();

    customPlot->addGraph(); // blue line
    customPlot->graph(0)->setPen(QPen(Qt::blue));
//    customPlot->graph(0)->setBrush(QBrush(QColor(240, 255, 200)));
    customPlot->graph(0)->setAntialiasedFill(false);

    customPlot->addGraph(); // blue dot
    customPlot->graph(1)->setPen(QPen(Qt::blue));
    customPlot->graph(1)->setLineStyle(QCPGraph::lsNone);
    customPlot->graph(1)->setScatterStyle(QCPScatterStyle::ssDisc);

  //  customPlot->addGraph(); // blue line
  //  customPlot->graph(2)->setPen(QPen(Qt::red));
 //   customPlot->addGraph(); // blue line
 //   customPlot->graph(3)->setPen(QPen(Qt::green));


    customPlot->xAxis->setTickLabelType(QCPAxis::ltDateTime);
    customPlot->xAxis->setDateTimeFormat("hh:mm:ss");
    customPlot->xAxis->setAutoTickStep(false);
    customPlot->xAxis->setTickStep(2);
    customPlot->axisRect()->setupFullAxesBox();

  //  QVBoxLayout *layout = new QVBoxLayout;
  //  layout->addWidget(customPlot);
  //  ui->centralWidget->setLayout(layout);
    ui->centralWidget->layout()->addWidget(customPlot);
    // make left and bottom axes transfer their ranges to right and top axes:
    connect(customPlot->xAxis, SIGNAL(rangeChanged(QCPRange)), customPlot->xAxis2, SLOT(setRange(QCPRange)));
    connect(customPlot->yAxis, SIGNAL(rangeChanged(QCPRange)), customPlot->yAxis2, SLOT(setRange(QCPRange)));

    ACCdata=0;
    ACCN=0;
    Freq=0;
    Range=0.05;
    Filter=1;


    T1=1;
    T2=1;
    // setup a timer that repeatedly calls MainWindow::realtimeDataSlot:
    connect(&dataTimer, SIGNAL(timeout()), this, SLOT(realtimeDataSlot()));

    serial = new QSerialPort(this);
    connect(serial, SIGNAL(error(QSerialPort::SerialPortError)), this,
            SLOT(handleError(QSerialPort::SerialPortError)));
    connect(serial, SIGNAL(readyRead()), this, SLOT(readData()));

    connect(settings, SIGNAL(isOK()), this, SLOT(openSerialPort()));

    QMetaObject::invokeMethod(settings, "show",
                              Qt::QueuedConnection);

//-----------------------------------
    QPushButton* butt=new QPushButton();
    config = new DialogConfig(this);

    ui->menuBar->setCornerWidget(butt);
    connect(butt, SIGNAL(clicked()), config, SLOT(show()));

    this->setContentsMargins(0,0,0,0);

    connect(config, SIGNAL(variable_changed(quint32,int)), this, SLOT(tochange(quint32,int)));
    config->show();

    dataTimer.start(0); // Interval 0 means to refresh as fast as possible
}

void MainWindow::tochange(quint32 value,int var){
    switch(var){
        case VAR_TAW:
            SendRequest(0x01,0x1,0,config->tAw);
            break;
        case VAR_TAO:
            SendRequest(0x01,0x1,1,config->tAo);
            break;
        case VAR_TBW:
            SendRequest(0x01,0x1,2,config->tBw);
            break;
        case VAR_TBO:
            SendRequest(0x01,0x1,3,config->tBo);
            break;
        case VAR_TF:
            SendRequest(0x01,0x1,4,config->tF);
            break;
        case VAR_EXTF:
        case VAR_SIGN:
        case VAR_TOZERO:
            DATA=(config->sign)&0x1;
            DATA|=((config->to_zero)&0x1)<<2;
            DATA|=((config->ExtF)&0x1)<<2;
            SendRequest(0x01,0x1,8,DATA);
            break;
        case VAR_TMIN:
            SendRequest(0x01,0x1,5,config->tmin);
            break;
    }
}

void MainWindow::SendRequest(quint8 AddrDST,quint8 Comm,quint16 Reg,quint32 Data){
    QByteArray sdata;
    quint8 tmp8;

    sdata[0]=0x55;

    sdata[1]=0x02;
    sdata[2]=AddrDST;

    tmp8=Comm<<6;
    tmp8|=(Reg>>8)&0x3F;
    sdata[3]=tmp8;

    sdata[4]=Reg&0xFF;

    sdata[5]=Data>>24;
    sdata[6]=Data>>16;
    sdata[7]=Data>>8;
    sdata[8]=Data;

    quint16 CRC=CRC16CCITT(sdata,9);
    sdata[9]=(CRC>>8)&0xFF;
    sdata[10]=CRC&0xFF;

    writeData(sdata);
}

void MainWindow::realtimeDataSlot(){
    double key = QDateTime::currentDateTime().toMSecsSinceEpoch()/1000.0;
    static double lastPointKey = 0;
    if (key-lastPointKey > 0.1){ // at most add point every 100 ms / 10 Гц
        SendRequest(0x01,0x2,6,0);
        SendRequest(0x01,0x2,7,0);
        lastPointKey = key;
    }

    // make key axis range scroll with the data (at a constant range size of 8):
    customPlot->xAxis->setRange(key+0.25, 10, Qt::AlignRight);

    if(Range>0){
        customPlot->yAxis->setRange(-Range,Range);
    }

    customPlot->replot();

    // calculate frames per second:
    static double lastFpsKey;
    static int frameCount;
    ++frameCount;
    if (key-lastFpsKey > 2) // average fps over 2 seconds
    {
      ui->statusBar->showMessage(
            QString("%1 FPS, Total Data points: %2, Частота автоколебаний: %3")
            .arg(frameCount/(key-lastFpsKey), 0, 'f', 0)
            .arg(customPlot->graph(0)->data()->count()+customPlot->graph(1)->data()->count())
            .arg(Freq)
            , 0);
      //Freq=0;
      lastFpsKey = key;
      frameCount = 0;
    }
}

MainWindow::~MainWindow(){
    delete settings;
    delete config;
    delete ui;
}

QByteArray pdata;
MainWindow *w;
quint64 pos;

OVERLAPPED overlappedR;						//Для операций чтения(структура необходима для асинхронных операций)
OVERLAPPED overlappedW;						//Для операций записи
char bufrd[65535],bufwr[255];			//Буферы для приёма и передачи
HANDLE reader,writer;						//Потоки чтения и записи
HANDLE COMport;
DCB ComDCM;

#ifdef WINPORT
DWORD WINAPI ReadThread(LPVOID){
    COMSTAT comstat;							//Структура текущего состояния порта
    DWORD btr, temp, mask, signal;				//Переменные для потоков работы с портом

    overlappedR.hEvent = CreateEvent(NULL, true, true, NULL);
    SetCommMask(COMport, EV_RXCHAR);       								//Устанавливается маска на срабатывание по событию приёма байта в порт

    while(1){
        if(!COMport)return 0;
        WaitCommEvent(COMport, &mask, &overlappedR);					//Ожидание события приёма байта

        signal = WaitForSingleObject(overlappedR.hEvent, INFINITE);		//Приостановить поток до прихода байта.
        if(signal == WAIT_OBJECT_0){									//Если событие прихода байта произошло -
          if(GetOverlappedResult(COMport, &overlappedR, &temp, true))	//проверяем, успешно ли завершилась WaitCommEvent.
              if((mask & EV_RXCHAR)!=0){								//Если произошло именно событие прихода байта,

                ClearCommError(COMport, &temp, &comstat);				//нужно заполнить структуру COMSTAT
                btr = comstat.cbInQue;                          		//и получить из неё количество принятых байтов.
                //btr-=btr%12;
                if(btr){                         						//Если действительно есть байты для чтения,
                    ReadFile(COMport, bufrd, btr, &temp, &overlappedR); //прочитать байты из порта в буфер программы.
                   // for(BYTE j=0;j<(BYTE)btr;j++)
                   //     pdata.append(bufrd[j]);	//Обработать все байты

                    QByteArray pdat(bufrd,btr);

                    if(!COMport)return 0;
                    QMetaObject::invokeMethod( w, "Receive",Q_ARG(QByteArray,pdat));
                }
              }
        }
    }
}
#endif

quint16  MainWindow::CRC16CCITT(QByteArray bytes, quint16 N) {
    quint16 crc = 0xFFFF;          // initial value
    quint16 polynomial = 0x1021;   // 0001 0000 0010 0001  (0, 5, 12)

    for (int b=1;b<N;b++) {//1 - 0x55
        for (int i = 0; i < 8; i++) {
            quint8 bit = ((bytes[b]   >> (7-i) & 1) == 1);
            quint8 c15 = ((crc >> 15    & 1) == 1);
            crc <<= 1;
            if (c15 ^ bit) crc ^= polynomial;
         }
    }

    crc &= 0xffff;

    return crc;
}

void  MainWindow::UpdateData(){
    double ff=(double)450E6/((double)T1+(double)T2);
    double xx=(double)((double)T1-(double)T2)/((double)T1+(double)T2);

    int Size;
    if(Filter){
        switch(Filter){
            case 1://30
                Size=20;
            break;
            case 2://100
                Size=50;
            break;
            default://200
                Size=100;
            break;
        }

        md.append(xx);
        if(md.size()>=Size){
            while(md.size()>=Size)md.remove(0,1);

            double tmp;
            QVector<double> mdx(md);
            for(int k=0;k<mdx.size()-1;k++){
                for(int kj=0;kj<mdx.size()-k-1;kj++){
                    if(mdx[kj]>mdx[kj+1]){
                        tmp=mdx[kj];
                        mdx[kj]=mdx[kj+1];
                        mdx[kj+1]=tmp;
                    }
                }
            }
            mdx.remove(0,Size/5);
            mdx.remove(mdx.size()-Size/5-1,Size/5);

            tmp=0;
            for(int k=0;k<mdx.size();k++){
                tmp+=mdx[k];
            }
            tmp/=mdx.size();

            ACCdata=tmp;
        }else{
            ACCdata=xx;
        }
    }else{//Filter none
        ACCdata=xx;
    }

    Freq=ff;
    double key = QDateTime::currentDateTime().toMSecsSinceEpoch()/1000.0;
    // add data to lines:
    customPlot->graph(0)->addData(key, ACCdata);
  //  customPlot->graph(2)->addData(key, xx);
 //   customPlot->graph(2)->addData(key, ((double)t1-(double)498900)/(double)1E6);
 //   customPlot->graph(3)->addData(key, ((double)t2-(double)990000)/(double)1E6);
    // set data of dots:
    customPlot->graph(1)->clearData();
    customPlot->graph(1)->addData(key, ACCdata);
    // remove data of lines that's outside visible range:
    customPlot->graph(0)->removeDataBefore(key-20);
 //   customPlot->graph(2)->removeDataBefore(key-20);
  //  customPlot->graph(3)->removeDataBefore(key-20);
    // rescale value (vertical) axis to fit the current data:
    if(Range<0){
        customPlot->graph(0)->rescaleValueAxis();
    }
}

void MainWindow::Receive(QByteArray newdata){
    quint16 CRC;

    for(quint32 j=0;j<newdata.size();j++)pdata.append(newdata[j]);

    for(;pdata.size()>=11;pdata.remove(0,1)){
        CRC=(quint8)pdata[9];
        CRC<<=8;
        CRC|= ((quint8)pdata[10])&0xFF;
        if((((quint8)pdata[0])==0x55) && (CRC16CCITT(pdata,9)==CRC)){
            Addr_SRC=(quint8)pdata[1];
            Addr_DST=(quint8)pdata[2];
            Command=(quint8)pdata[3]>>6;

            REG=((quint16)((quint8)pdata[3]&0x3F))<<8;
            REG|=(quint8)pdata[4];

            DATA=(quint8)pdata[5]<<24;
            DATA|=(quint8)pdata[6]<<16;
            DATA|=(quint8)pdata[7]<<8;
            DATA|=(quint8)pdata[8];

            if(Addr_DST==0x02 && Command==0x03 && Addr_SRC==0x01){//my address and command = OK
                switch(REG){
                    case 0://T_WAIT_A
                        if(DATA!=config->tAw){//??
                        //    qDebug()<<"Err in DATA="<<DATA<<"tAw="<<config->tAw;
                        }
                        break;
                    case 1://T_OFF_A
                        if(DATA!=config->tAo){//??
                        //     qDebug()<<"Err in DATA="<<DATA<<"tAw="<<config->tAo;
                        }
                        break;
                    case 2://T_WAIT_B
                        if(DATA!=config->tBw){//??
                        //     qDebug()<<"Err in DATA="<<DATA<<"tAw="<<config->tBw;
                        }
                        break;
                    case 3://T_OFF_B
                        if(DATA!=config->tBo){//??
                        //     qDebug()<<"Err in DATA="<<DATA<<"tAw="<<config->tBo;
                        }
                        break;
                    case 4://F_START
                        if(DATA!=config->tF){//??
                        //     qDebug()<<"Err in DATA="<<DATA<<"tAw="<<config->tF;
                        }
                        break;
                    case 5://MIN_T
                        if(DATA!=config->tmin){//??
                        //     qDebug()<<"Err in DATA="<<DATA<<"tAw="<<config->tmin;
                        }
                        break;
                    case 6://T1
                        T1=DATA;
                        UpdateData();
                        break;
                    case 7://T2
                        T2=DATA;
                        UpdateData();
                        break;
                    case 8://SIGN(0) + To_ZERO(1) + EXT_IN(2)
                        if(((DATA)&0x1)!=config->sign || ((DATA>>1)&0x1)!=config->to_zero || ((DATA>>2)&0x1)!=config->ExtF){//??
                             qDebug()<<"Err in DATA="<<DATA<<"sign="<<config->sign<<"to_zero="<<config->to_zero<<"ExtF="<<config->ExtF;
                        }
                        break;
                    default://?
                        qDebug()<<"Unknown REG";
                        break;
                }
                }//end if(Addr_DST==0x02 && Command==0x03 && Addr_SRC==0x01)

                pdata.remove(0,10);
        }else{
            qDebug()<<"CRC error, frame start error";
        }
    }
}

void MainWindow::openSerialPort()
{
#ifdef WINPORT
    SettingsDialog::Settings p = settings->settings();

    if(COMport){
        CloseHandle(COMport);
        PurgeComm(COMport,PURGE_TXABORT| PURGE_RXABORT| PURGE_TXCLEAR| PURGE_RXCLEAR);
        COMport=NULL;
    }
    wchar_t name[255];
    p.name.toWCharArray(name);

    COMport = CreateFile(name,GENERIC_READ | GENERIC_WRITE, 0,NULL, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);

    if(COMport){
        ui->actionConnect->setEnabled(false);
        ui->actionDisconnect->setEnabled(true);

                memset(&ComDCM,0,sizeof(ComDCM));
                ComDCM.DCBlength = sizeof(DCB);
                GetCommState(COMport, &ComDCM);
                ComDCM.BaudRate = DWORD(p.baudRate);
                ComDCM.ByteSize = p.dataBits;
                SetCommState(COMport, &ComDCM);
    PurgeComm(COMport,PURGE_TXABORT| PURGE_RXABORT| PURGE_TXCLEAR| PURGE_RXCLEAR);

        reader = CreateThread(NULL, 0, ReadThread, NULL, 0, NULL);					//Создать поток чтения
            //    writer = CreateThread(NULL, 0, WriteThread, NULL, CREATE_SUSPENDED, NULL);	//Создать поток записи, он выключен пока
    }else{
        qDebug()<<"error";
    }
#else
    SettingsDialog::Settings p = settings->settings();

    qDebug()<<QString(tr("Try to connect to %1 : %2, %3, %4, %5, %6")).arg(p.name).arg(p.stringBaudRate).arg(p.stringDataBits)
                      .arg(p.stringParity).arg(p.stringStopBits).arg(p.stringFlowControl);

    serial->setPortName(p.name);
    serial->setBaudRate(p.baudRate);
    serial->setDataBits(p.dataBits);
    serial->setParity(p.parity);
    serial->setStopBits(p.stopBits);
    serial->setFlowControl(p.flowControl);
    if (serial->open(QIODevice::ReadWrite)) {

        ui->actionConnect->setEnabled(false);
        ui->actionDisconnect->setEnabled(true);
        ui->actionConfigure->setEnabled(false);

        qDebug()<<"Connected";
     //   PrintLog(QString(tr("Connected to %1 : %2, %3, %4, %5, %6")).arg(p.name).arg(p.stringBaudRate).arg(p.stringDataBits)
      //           .arg(p.stringParity).arg(p.stringStopBits).arg(p.stringFlowControl),Qt::gray);
    } else {
        QMessageBox::critical(this, tr("Error"), serial->errorString());
    }
#endif
}

void MainWindow::closeSerialPort()
{
#ifdef WINPORT
    if(COMport){
        CloseHandle(COMport);
        PurgeComm(COMport,PURGE_TXABORT| PURGE_RXABORT| PURGE_TXCLEAR| PURGE_RXCLEAR);
        COMport=NULL;
    }
#else
    if (serial->isOpen()) serial->close();
#endif
    ui->actionConnect->setEnabled(true);
    ui->actionDisconnect->setEnabled(false);
    ui->actionConfigure->setEnabled(true);
    ui->statusBar->showMessage(tr("Disconnected"));
}


void MainWindow::about()
{
    QMessageBox::about(this, tr("About Simple Terminal"),
                       tr("The <b>Simple Terminal</b> example demonstrates how to "
                          "use the Qt Serial Port module in modern GUI applications "
                          "using Qt, with a menu bar, toolbars, and a status bar."));
}

void MainWindow::writeData(const QByteArray &data)
{
#ifdef WINPORT
#else
    if(serial->isOpen()){
        serial->write(data);
        QObject().thread()->usleep(300);
    }
#endif
}

void MainWindow::readData()
{
#ifdef WINPORT
#else
    QByteArray data = serial->readAll();
    Receive(data);
#endif
}

void MainWindow::handleError(QString error)
{
#ifdef WINPORT
        QMessageBox::critical(this, tr("Critical Error"), error);
        closeSerialPort();
#else
        //if (error == QSerialPort::ResourceError) {
            QMessageBox::critical(this, tr("Critical Error"), serial->errorString());
            closeSerialPort();
      //  }
#endif
}

void MainWindow::initActionsConnections()
{
    connect(ui->actionConnect, SIGNAL(triggered()), this, SLOT(openSerialPort()));
    connect(ui->actionDisconnect, SIGNAL(triggered()), this, SLOT(closeSerialPort()));
    connect(ui->actionQuit, SIGNAL(triggered()), this, SLOT(close()));
    connect(ui->actionConfigure, SIGNAL(triggered()), settings, SLOT(show()));
    connect(ui->actionAbout, SIGNAL(triggered()), this, SLOT(about()));
    connect(ui->actionAboutQt, SIGNAL(triggered()), qApp, SLOT(aboutQt()));
}

void MainWindow::on_action_0_005_triggered()
{
    Range=0.005;
}

void MainWindow::on_action_0_5_triggered()
{
     Range=0.5;
}

void MainWindow::on_action_0_1_triggered()
{
     Range=0.1;
}

void MainWindow::on_action_0_05_triggered()
{
     Range=0.05;
}

void MainWindow::on_action_0_01_triggered()
{
     Range=0.01;
}

void MainWindow::on_action_0_001_triggered()
{
     Range=0.001;
}

void MainWindow::on_action_triggered()
{
    Filter=0;
}

void MainWindow::on_action_30_triggered()
{
    Filter=1;
}

void MainWindow::on_action_100_triggered()
{
    Filter=2;
}

void MainWindow::on_action_200_triggered()
{
    Filter=3;
}

void MainWindow::on_action_2_triggered()
{
     Range=-1;
}

