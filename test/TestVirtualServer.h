#ifndef TESTVIRTUALSERVER
#define TESTVIRTUALSERVER

#include <QObject>
#include "common/QContact.h"

class TestVirtualServer: public QObject
{
    Q_OBJECT
public:
    TestVirtualServer(QObject *parent = 0);
    ~TestVirtualServer();

signals:
    void authResponse(quint32 length, quint32 delay, quint32 retries);
    void verifyResponse(const QString &token, const QContact* profile);

public slots:
    void onRequestAuth(const QString &phone);
    void onVerifyAuth(const QString &code);
    void onConfirmAuth(const QString &resultToken);
};

#endif // TESTVIRTUALSERVER
