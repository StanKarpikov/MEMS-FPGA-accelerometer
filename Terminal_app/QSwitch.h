#ifndef QSWITCH_H
#define QSWITCH_H
#include <QSlider>
#include <QPropertyAnimation>
#include <QMouseEvent>
#include <QGraphicsColorizeEffect>
#include <QPalette>
#include <QWidget>

class QSwitch : public QSlider {
    Q_OBJECT

public:
    QPropertyAnimation *animation;
    QPropertyAnimation *animation_color;
    QGraphicsColorizeEffect *eEffect;
    QPalette *palette;

    QSwitch(QWidget *parent = 0);

public slots:
    void mouseDoubleClickEvent ( QMouseEvent * event );
    void mouseReleaseEvent ( QMouseEvent * event );
    void mousePressEvent ( QMouseEvent * event );
    void toSliderReleased() ;
    void tovalueChanged(int val);
};


#endif // QSWITCH_H
