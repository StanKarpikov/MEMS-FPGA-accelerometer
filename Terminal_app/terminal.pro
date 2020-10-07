QT += widgets serialport printsupport winextras

TARGET = terminal
TEMPLATE = app

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    settingsdialog.cpp \
    qcustomplot.cpp \
    QSwitch.cpp \
    dialogconfig.cpp

HEADERS += \
    mainwindow.h \
    settingsdialog.h \
    qcustomplot.h \
    QSwitch.h \
    dialogconfig.h

FORMS += \
    mainwindow.ui \
    settingsdialog.ui \
    dialogconfig.ui

RESOURCES += \
    terminal.qrc
