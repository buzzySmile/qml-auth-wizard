#include <QApplication>
#include <QThread>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>

#include "test/TestVirtualServer.h"
#include "QAuthContext.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    //QAuthContext::DeclareQML();

    TestVirtualServer *testAuthServer = new TestVirtualServer();
    QAuthContext *authContext = new QAuthContext();

    QObject::connect(authContext, SIGNAL(requestAuth(QString)),
                     testAuthServer,   SLOT(onRequestAuth(QString)));

    QObject::connect(testAuthServer, SIGNAL(authResponse(quint32,quint32,quint32)),
                     authContext, SIGNAL(authReRequest(quint32,quint32,quint32)));

    QObject::connect(authContext, SIGNAL(verifyAuth(QString)),
                     testAuthServer,   SLOT(onVerifyAuth(QString)));

    QObject::connect(testAuthServer, SIGNAL(verifyResponse(QString,const QContact*)),
                     authContext,   SLOT(onAuthConfirmPage(QString,const QContact*)));

    QObject::connect(authContext, SIGNAL(confirmAuth(QString)),
                     testAuthServer,   SLOT(onConfirmAuth(QString)));

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("Authenticator", authContext);
    engine.load(QUrl("qrc:/qml/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    QObject::connect((QObject*) &engine, SIGNAL(quit()), (QObject*) &app, SLOT(quit()));
    return app.exec();
}
