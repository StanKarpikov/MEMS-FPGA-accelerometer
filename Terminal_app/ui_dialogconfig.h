/********************************************************************************
** Form generated from reading UI file 'dialogconfig.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DIALOGCONFIG_H
#define UI_DIALOGCONFIG_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QDialog>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QScrollBar>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_DialogConfig
{
public:
    QScrollBar *horizontalScrollBar;
    QScrollBar *horizontalScrollBar_2;
    QTextEdit *textEdit_5;
    QSpinBox *spinBox;
    QSpinBox *spinBox_2;
    QWidget *widget;
    QCheckBox *checkBox;
    QTextEdit *textEdit_6;
    QTextEdit *textEdit_3;
    QScrollBar *horizontalScrollBar_4;
    QScrollBar *horizontalScrollBar_3;
    QCheckBox *checkBox_2;
    QSpinBox *spinBox_4;
    QTextEdit *textEdit_2;
    QSpinBox *spinBox_3;
    QScrollBar *horizontalScrollBar_5;
    QSpinBox *spinBox_5;
    QTextEdit *textEdit_4;

    void setupUi(QDialog *DialogConfig)
    {
        if (DialogConfig->objectName().isEmpty())
            DialogConfig->setObjectName(QStringLiteral("DialogConfig"));
        DialogConfig->setWindowModality(Qt::NonModal);
        DialogConfig->resize(460, 380);
        QSizePolicy sizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(DialogConfig->sizePolicy().hasHeightForWidth());
        DialogConfig->setSizePolicy(sizePolicy);
        DialogConfig->setMinimumSize(QSize(460, 380));
        DialogConfig->setMaximumSize(QSize(460, 380));
        DialogConfig->setAutoFillBackground(false);
        DialogConfig->setModal(false);
        horizontalScrollBar = new QScrollBar(DialogConfig);
        horizontalScrollBar->setObjectName(QStringLiteral("horizontalScrollBar"));
        horizontalScrollBar->setGeometry(QRect(23, 283, 211, 16));
        horizontalScrollBar->setMaximum(99999999);
        horizontalScrollBar->setOrientation(Qt::Horizontal);
        horizontalScrollBar_2 = new QScrollBar(DialogConfig);
        horizontalScrollBar_2->setObjectName(QStringLiteral("horizontalScrollBar_2"));
        horizontalScrollBar_2->setGeometry(QRect(23, 233, 211, 16));
        horizontalScrollBar_2->setMaximum(99999999);
        horizontalScrollBar_2->setOrientation(Qt::Horizontal);
        textEdit_5 = new QTextEdit(DialogConfig);
        textEdit_5->setObjectName(QStringLiteral("textEdit_5"));
        textEdit_5->setGeometry(QRect(260, 250, 51, 30));
        textEdit_5->setAutoFillBackground(true);
        textEdit_5->setStyleSheet(QStringLiteral("background-color: transparent;"));
        textEdit_5->setFrameShape(QFrame::NoFrame);
        textEdit_5->setFrameShadow(QFrame::Sunken);
        textEdit_5->setReadOnly(true);
        spinBox = new QSpinBox(DialogConfig);
        spinBox->setObjectName(QStringLiteral("spinBox"));
        spinBox->setGeometry(QRect(103, 203, 111, 22));
        spinBox->setMaximum(99999999);
        spinBox_2 = new QSpinBox(DialogConfig);
        spinBox_2->setObjectName(QStringLiteral("spinBox_2"));
        spinBox_2->setGeometry(QRect(103, 253, 111, 22));
        spinBox_2->setMaximum(99999999);
        widget = new QWidget(DialogConfig);
        widget->setObjectName(QStringLiteral("widget"));
        widget->setGeometry(QRect(3, 3, 481, 201));
        widget->setAutoFillBackground(false);
        widget->setStyleSheet(QStringLiteral("border-image: url(:/images/Doc3.png) 0 0 0 0 stretch stretch;"));
        checkBox = new QCheckBox(DialogConfig);
        checkBox->setObjectName(QStringLiteral("checkBox"));
        checkBox->setGeometry(QRect(253, 343, 161, 17));
        textEdit_6 = new QTextEdit(DialogConfig);
        textEdit_6->setObjectName(QStringLiteral("textEdit_6"));
        textEdit_6->setGeometry(QRect(260, 200, 51, 30));
        textEdit_6->setAutoFillBackground(true);
        textEdit_6->setStyleSheet(QStringLiteral("background-color: transparent;"));
        textEdit_6->setFrameShape(QFrame::NoFrame);
        textEdit_6->setFrameShadow(QFrame::Sunken);
        textEdit_6->setReadOnly(true);
        textEdit_3 = new QTextEdit(DialogConfig);
        textEdit_3->setObjectName(QStringLiteral("textEdit_3"));
        textEdit_3->setGeometry(QRect(50, 250, 51, 30));
        textEdit_3->setAutoFillBackground(true);
        textEdit_3->setStyleSheet(QStringLiteral("background-color: transparent;"));
        textEdit_3->setFrameShape(QFrame::NoFrame);
        textEdit_3->setFrameShadow(QFrame::Sunken);
        textEdit_3->setReadOnly(true);
        horizontalScrollBar_4 = new QScrollBar(DialogConfig);
        horizontalScrollBar_4->setObjectName(QStringLiteral("horizontalScrollBar_4"));
        horizontalScrollBar_4->setGeometry(QRect(233, 283, 211, 16));
        horizontalScrollBar_4->setMaximum(99999999);
        horizontalScrollBar_4->setOrientation(Qt::Horizontal);
        horizontalScrollBar_3 = new QScrollBar(DialogConfig);
        horizontalScrollBar_3->setObjectName(QStringLiteral("horizontalScrollBar_3"));
        horizontalScrollBar_3->setGeometry(QRect(23, 343, 211, 16));
        horizontalScrollBar_3->setMaximum(99999999);
        horizontalScrollBar_3->setOrientation(Qt::Horizontal);
        checkBox_2 = new QCheckBox(DialogConfig);
        checkBox_2->setObjectName(QStringLiteral("checkBox_2"));
        checkBox_2->setGeometry(QRect(253, 313, 161, 17));
        spinBox_4 = new QSpinBox(DialogConfig);
        spinBox_4->setObjectName(QStringLiteral("spinBox_4"));
        spinBox_4->setGeometry(QRect(313, 203, 111, 22));
        spinBox_4->setMaximum(99999999);
        textEdit_2 = new QTextEdit(DialogConfig);
        textEdit_2->setObjectName(QStringLiteral("textEdit_2"));
        textEdit_2->setGeometry(QRect(50, 200, 51, 30));
        textEdit_2->setAutoFillBackground(true);
        textEdit_2->setStyleSheet(QStringLiteral("background-color: transparent;"));
        textEdit_2->setFrameShape(QFrame::NoFrame);
        textEdit_2->setFrameShadow(QFrame::Sunken);
        textEdit_2->setReadOnly(true);
        spinBox_3 = new QSpinBox(DialogConfig);
        spinBox_3->setObjectName(QStringLiteral("spinBox_3"));
        spinBox_3->setGeometry(QRect(103, 313, 111, 22));
        spinBox_3->setMaximum(99999999);
        horizontalScrollBar_5 = new QScrollBar(DialogConfig);
        horizontalScrollBar_5->setObjectName(QStringLiteral("horizontalScrollBar_5"));
        horizontalScrollBar_5->setGeometry(QRect(233, 233, 211, 16));
        horizontalScrollBar_5->setMaximum(99999999);
        horizontalScrollBar_5->setOrientation(Qt::Horizontal);
        spinBox_5 = new QSpinBox(DialogConfig);
        spinBox_5->setObjectName(QStringLiteral("spinBox_5"));
        spinBox_5->setGeometry(QRect(313, 253, 111, 22));
        spinBox_5->setMaximum(99999999);
        textEdit_4 = new QTextEdit(DialogConfig);
        textEdit_4->setObjectName(QStringLiteral("textEdit_4"));
        textEdit_4->setGeometry(QRect(50, 310, 51, 30));
        textEdit_4->setAutoFillBackground(true);
        textEdit_4->setStyleSheet(QStringLiteral("background-color: transparent;"));
        textEdit_4->setFrameShape(QFrame::NoFrame);
        textEdit_4->setFrameShadow(QFrame::Sunken);
        textEdit_4->setReadOnly(true);

        retranslateUi(DialogConfig);

        QMetaObject::connectSlotsByName(DialogConfig);
    } // setupUi

    void retranslateUi(QDialog *DialogConfig)
    {
        DialogConfig->setWindowTitle(QApplication::translate("DialogConfig", "Config", 0));
        textEdit_5->setHtml(QApplication::translate("DialogConfig", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:12pt; font-style:italic;\">t</span><span style=\" font-size:12pt; font-style:italic; vertical-align:sub;\">Bo </span><span style=\" font-size:12pt;\">=</span></p></body></html>", 0));
        checkBox->setText(QApplication::translate("DialogConfig", "\320\237\321\200\320\270\320\275\321\203\320\264\320\270\321\202\320\265\320\273\321\214\320\275\321\213\320\271 \320\267\320\260\320\277\321\203\321\201\320\272", 0));
        textEdit_6->setHtml(QApplication::translate("DialogConfig", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:12pt; font-style:italic;\">t</span><span style=\" font-size:12pt; font-style:italic; vertical-align:sub;\">Bw </span><span style=\" font-size:12pt;\">=</span></p></body></html>", 0));
        textEdit_3->setHtml(QApplication::translate("DialogConfig", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:12pt; font-style:italic;\">t</span><span style=\" font-size:12pt; font-style:italic; vertical-align:sub;\">Ao </span><span style=\" font-size:12pt;\">=</span></p></body></html>", 0));
        checkBox_2->setText(QApplication::translate("DialogConfig", "\320\236\320\261\321\200\320\260\321\202\320\275\320\260\321\217 \320\277\320\276\320\273\321\217\321\200\320\275\320\276\321\201\321\202\321\214", 0));
        textEdit_2->setHtml(QApplication::translate("DialogConfig", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:12pt; font-style:italic;\">t</span><span style=\" font-size:12pt; font-style:italic; vertical-align:sub;\">Aw </span><span style=\" font-size:12pt;\">=</span></p></body></html>", 0));
        textEdit_4->setHtml(QApplication::translate("DialogConfig", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:12pt; font-style:italic;\">t</span><span style=\" font-size:12pt; font-style:italic; vertical-align:sub;\">F </span><span style=\" font-size:12pt;\">=</span></p></body></html>", 0));
    } // retranslateUi

};

namespace Ui {
    class DialogConfig: public Ui_DialogConfig {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DIALOGCONFIG_H
