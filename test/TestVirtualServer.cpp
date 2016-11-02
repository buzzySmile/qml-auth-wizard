#include <QEventLoop>
#include <QTimer>
#include <QDebug>

#include "common/QTokens.h"
#include "TestVirtualServer.h"

TestVirtualServer::TestVirtualServer(QObject *parent) :
    QObject(parent)
{
}

TestVirtualServer::~TestVirtualServer()
{
}

void TestVirtualServer::onRequestAuth(const QString &phone)
{
    qDebug() << "cpp: SERVER: phone received" << phone;

    // 3 sec delay
    QEventLoop loop; QTimer::singleShot(3000, &loop, SLOT(quit())); loop.exec();

    emit authResponse(4, 5, 0);
}

void TestVirtualServer::onVerifyAuth(const QString &code)
{
    qDebug() << "cpp: SERVER: sms code received" << code;

    // 3 sec delay
    QEventLoop loop; QTimer::singleShot(3000, &loop, SLOT(quit())); loop.exec();

    QContact *profile = new QContact();
    profile->setUsername("John Cena");
    profile->setAvatarUrl(QUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/John_Cena_2012.jpg/360px-John_Cena_2012.jpg"));
//    profile->setAvatarUrl("https://at-cdn-s01.audiotool.com/2015/08/02/users/jojceec/avatar256x256-051a64890f544fc59f3fc75b56a26e2c.jpg");

    emit verifyResponse(QTokens::CONFIRM, profile);
}

void TestVirtualServer::onConfirmAuth(const QString &resultToken)
{
    qDebug() << "cpp: SERVER: result token received" << resultToken;
}
