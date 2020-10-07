#ifndef DIALOGCONFIG_H
#define DIALOGCONFIG_H

#include <QDialog>

#define VAR_TAW 1
#define VAR_TAO 2
#define VAR_TBW 3
#define VAR_TBO 4
#define VAR_TF  5
#define VAR_EXTF 6
#define VAR_SIGN 7
#define VAR_TMIN 8
#define VAR_TOZERO 9

namespace Ui {
class DialogConfig;
}

class DialogConfig : public QDialog
{
    Q_OBJECT

public:
    explicit DialogConfig(QWidget *parent = 0);
    ~DialogConfig();
    quint32 sign,ExtF,tAw,tBw,tAo,tBo,tF,to_zero,tmin;

private slots:
    void on_spinBox_valueChanged(int arg1);

    void on_horizontalScrollBar_2_valueChanged(int value);

    void on_spinBox_2_valueChanged(int arg1);

    void on_horizontalScrollBar_valueChanged(int value);

    void on_spinBox_3_valueChanged(int arg1);

    void on_horizontalScrollBar_3_valueChanged(int value);

    void on_spinBox_4_valueChanged(int arg1);

    void on_horizontalScrollBar_5_valueChanged(int value);

    void on_spinBox_5_valueChanged(int arg1);

    void on_horizontalScrollBar_4_valueChanged(int value);

    void on_checkBox_2_stateChanged(int arg1);

    void on_checkBox_stateChanged(int arg1);

signals:
    void variable_changed(quint32 value,int var);
private:
    Ui::DialogConfig *ui;
};

#endif // DIALOGCONFIG_H
