#include "QSwitch.h"

QSwitch::QSwitch(QWidget *parent):QSlider(){
    connect(this, SIGNAL(sliderReleased()),
        this, SLOT(toSliderReleased()));
    setRange(0,99);
    setOrientation(Qt::Horizontal);
    setPageStep(0);
    setMaximumHeight(31);
    setMaximumWidth(71);
    setMinimumHeight(31);
    setMinimumWidth(71);
    resize(71, 31);
    setSizePolicy(QSizePolicy::Fixed,QSizePolicy::Fixed);
    animation=new QPropertyAnimation(this);
    animation_color=new QPropertyAnimation(this);

    animation->setTargetObject(this);
    animation->setPropertyName("value");
    animation->setDuration(300);
    animation->setEasingCurve(QEasingCurve::InOutSine);

//    animation_color=new QPropertyAnimation(eEffect);
 //   animation_color->setTargetObject(eEffect);
 //   animation_color->setPropertyName("color");
 //   animation_color->setDuration(300);
 //   animation_color->setEasingCurve(QEasingCurve::InOutExpo);

    connect(this, SIGNAL(valueChanged(int)), this, SLOT(tovalueChanged(int)));
}
void QSwitch::tovalueChanged(int val){
    QString backgroundColor = QString("rgb(%1, %2, %3);").arg(255-val*2.55).arg(0).arg(val*2.55);
    setStyleSheet("QSlider{ background-color: " + backgroundColor  + " } ");
}

void QSwitch::mouseDoubleClickEvent ( QMouseEvent * event ){
    event->accept();
}
void QSwitch::mouseReleaseEvent ( QMouseEvent * event ){
    if (event->button() == Qt::LeftButton){
        if(animation->state()!=QAbstractAnimation::Stopped)return;
        animation->setStartValue(value());
        if(value()<50){
            animation->setEndValue(99);
            animation->setDuration((99-value())*1);
        }else{
            animation->setEndValue(0);
            animation->setDuration(value()*1);
        }
        animation->start();
        event->accept();
    }
    QSlider::mouseReleaseEvent(event);
}
void QSwitch::mousePressEvent ( QMouseEvent * event )
 {

    QSlider::mousePressEvent(event);
    return;
   if (event->button() == Qt::LeftButton)
   {
     //  if (orientation() == Qt::Vertical)
     //      setValue(minimum() + ((maximum()-minimum()) * (height()-event->y())) / height() ) ;
     //  else
     //      setValue(minimum() + ((maximum()-minimum()) * event->x()) / width() ) ;
       animation->setStartValue(value());
       if(value()<50){
           animation->setEndValue(99);
           animation->setDuration((99-value())*22);
       }else{
           animation->setEndValue(0);
           animation->setDuration(value()*22);
       }
       animation->start();
       event->accept();
   }
 //  QSlider::mousePressEvent(event);
 }
void QSwitch::toSliderReleased() {
    animation->setStartValue(value());
 //   animation_color->setStartValue(QColor(Qt::red));
    if(value()>50){
        animation->setEndValue(99);
        animation->setDuration((99-value())*3);

   //     animation_color->setEndValue(QColor(Qt::red));
   //     animation_color->setDuration((99-value())*6);
    }else{
        animation->setEndValue(0);
        animation->setDuration(value()*3);

    //    animation_color->setEndValue(QColor(Qt::blue));
    //    animation_color->setDuration((99-value())*6);
    }
    animation->start();
   // animation_color->start();
}
