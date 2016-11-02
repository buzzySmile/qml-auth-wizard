QT += core gui quick

greaterThan(QT_MAJOR_VERSION, 4) {
    QT += widgets
}

TARGET = qmlwizard

HEADERS = \
    $$PWD/test/TestVirtualServer.h \
    $$PWD/QAuthContext.h \
    $$PWD/common/QContact.h \
    $$PWD/common/QTokens.h
SOURCES = \
    $$PWD/common/QContact.cpp \
    $$PWD/test/TestVirtualServer.cpp \
    $$PWD/QAuthContext.cpp \
    $$PWD/main.cpp

RESOURCES = qmlwizard.qrc

# install
target.path = $$[PWD]/bin
INSTALLS += target

OTHER_FILES += \
    $$PWD/qml/styles/CustomBusyIndicatorStyle.qml \
    $$PWD/qml/AuthRequest.qml \
    $$PWD/qml/AuthCode.qml \
    $$PWD/qml/AuthConfirm.qml \
    $$PWD/qml/main.qml

# DEV DEPLOYMENT
OBJECTS_DIR = $$OUT_PWD/_build/obj
MOC_DIR     = $$OUT_PWD/_build/moc
RCC_DIR     = $$OUT_PWD/_build/rcc
UI_DIR      = $$OUT_PWD/_build/ui
