#include "dialogconfig.h"
#include "ui_dialogconfig.h"
#include <QtWin>

DialogConfig::DialogConfig(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogConfig)
{
    ui->setupUi(this);
  //   QtWin::extendFrameIntoClientArea(this,-1, -1, -1, -1);
  //  setWindowOpacity(1.0);

  //  QtWin::enableBlurBehindWindow(this,QRegion(-1,-1,-1,-1));
//    setStyleSheet("background:transparent;");
//    setAttribute(Qt::WA_TranslucentBackground);
  //  setPalette(QPalette(QPalette::Background, QColor(255, 255, 255, 128)));
   // setAutoFillBackground(true);
   //  setAttribute(Qt::WA_TranslucentBackground, true);
   //  QtWin::enableBlurBehindWindow(this);
  //   QtWin::disableBlurBehindWindow(this);
  //   QtWin::disableBlurBehindWindow(window());
   //  QtWin::setWindowExcludedFromPeek(this,1);
  //   setAttribute(Qt::WA_NoSystemBackground, true);
  //   setAttribute(Qt::WA_TranslucentBackground);

   //  setWindowFlags(windowFlags() | Qt::WindowMinimizeButtonHint|Qt::Tool & (~Qt::WindowCloseButtonHint));
  //   setWindowFlags((
  //   (windowFlags() | Qt::CustomizeWindowHint|Qt::WindowMinimizeButtonHint|Qt::Popup | Qt:: Dialog)
  //   & ~Qt::WindowCloseButtonHint
  //   ));

     setWindowFlags(Qt::Popup | Qt:: Dialog);
     setWindowModality(Qt::NonModal);
  //   setAttribute(Qt::WA_AlwaysStackOnTop);
   //  setWindowFlags(Qt::Window);

     to_zero=0;
     tmin=1000;
     sign=0;
     ExtF=0;

     ui->horizontalScrollBar->setValue(1500000);//tAo);
     ui->horizontalScrollBar_2->setValue(0);//tAw);
     ui->horizontalScrollBar_3->setValue(0);//tF);
     ui->horizontalScrollBar_4->setValue(1500000);//tBo);
     ui->horizontalScrollBar_5->setValue(1500000);//tBw);

     ui->checkBox_2->setChecked(0);//sign);
     ui->checkBox->setChecked(1);//ExtF);
}

DialogConfig::~DialogConfig()
{
    delete ui;
}

void DialogConfig::on_spinBox_valueChanged(int arg1)
{//tAw
   if(arg1!=tAw){
       tAw=arg1;
       ui->horizontalScrollBar_2->setValue(arg1);       
       emit variable_changed(tAw,VAR_TAW);
   }
}

void DialogConfig::on_horizontalScrollBar_2_valueChanged(int value)
{//tAw slider
    if(value!=tAw){       
        tAw=value;
        ui->spinBox->setValue(value);
        emit variable_changed(tAw,VAR_TAW);
    }
}

void DialogConfig::on_spinBox_2_valueChanged(int arg1)
{//tAO
    if(arg1!=tAo){
        tAo=arg1;
       ui->horizontalScrollBar->setValue(arg1);

        emit variable_changed(tAo,VAR_TAO);
    }
}

void DialogConfig::on_horizontalScrollBar_valueChanged(int value)
{//tAO slider
    if(value!=tAo){
        tAo=value;
        ui->spinBox_2->setValue(value);

        emit variable_changed(tAo,VAR_TAO);
    }
}

void DialogConfig::on_spinBox_3_valueChanged(int arg1)
{//tF
    if(arg1!=tF){
         tF=arg1;
        ui->horizontalScrollBar_3->setValue(arg1);

        emit variable_changed(tF,VAR_TF);
    }
}

void DialogConfig::on_horizontalScrollBar_3_valueChanged(int value)
{//tF slider
    if(value!=tF){
         tF=value;
        ui->spinBox_3->setValue(value);

        emit variable_changed(tF,VAR_TF);
    }
}

void DialogConfig::on_spinBox_4_valueChanged(int arg1)
{//tBw
    if(arg1!=tBw){
         tBw=arg1;
        ui->horizontalScrollBar_5->setValue(arg1);

        emit variable_changed(tBw,VAR_TBW);
    }
}

void DialogConfig::on_horizontalScrollBar_5_valueChanged(int value)
{//tBw slider
    if(value!=tBw){
        tBw=value;
        ui->spinBox_4->setValue(value);

        emit variable_changed(tBw,VAR_TBW);
    }
}

void DialogConfig::on_spinBox_5_valueChanged(int arg1)
{//tBo
    if(arg1!=tBo){
        tBo=arg1;
        ui->horizontalScrollBar_4->setValue(arg1);

        emit variable_changed(tBo,VAR_TBO);
    }
}

void DialogConfig::on_horizontalScrollBar_4_valueChanged(int value)
{//tBo slider
    if(value!=tBo){
        tBo=value;
        ui->spinBox_5->setValue(value);

        emit variable_changed(tBo,VAR_TBO);
    }
}

void DialogConfig::on_checkBox_2_stateChanged(int arg1)
{//sign
    if(arg1!=(sign<<1)){
        sign=arg1>>1;
        emit variable_changed(sign,VAR_SIGN);
    }
}

void DialogConfig::on_checkBox_stateChanged(int arg1)
{//Ext.F
    if(arg1!=(ExtF<<1)){
        ExtF=arg1>>1;
        emit variable_changed(ExtF,VAR_EXTF);
    }
}
