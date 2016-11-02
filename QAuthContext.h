#ifndef QAUTHCONTEXT_H
#define QAUTHCONTEXT_H

#include <QObject>
#include <QVariant>

#include "common/QContact.h"

namespace Ui {
class QAuthContext;
}

class QAuthContext : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant phone READ phone WRITE setPhone NOTIFY phoneChanged)

public:
    // Call it before loading qml
    static void DeclareQML();

    explicit QAuthContext(QObject *parent = 0);
    ~QAuthContext();

    QVariant phone() const;
    void setPhone(const QVariant &phone);

    void reset();

    Q_INVOKABLE void resend();
    Q_INVOKABLE void setAuthCode(const QVariant &code);
    Q_INVOKABLE QString secondsToDHMS(quint32 duration);
    Q_INVOKABLE void confirmProfile();

signals:
    void resetPages();
    void phoneChanged();

    void requestAuth(const QString &phone);
    void verifyAuth(const QString &verifyCode);
    void confirmAuth(const QString &tokenType);

    void authReRequest(quint32 length, quint32 delay, quint32 retries);
    void authReVerify(const QString &name, const QString &avatarUrl);

public slots:
    void onAuthConfirmPage(const QString &token, const QContact *profile);

private:
    QVariant mPhone;
};

#endif // QAUTHCONTEXT_H
