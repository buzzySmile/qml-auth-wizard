#include <QtQml>
#include <QDebug>

#include "common/QContact.h"
#include "common/QTokens.h"

#include "QAuthContext.h"


void QAuthContext::DeclareQML()
{
    qmlRegisterType<QAuthContext>("com.buzzySmile.Authenticator", 1, 0, "Authenticator");
}

QAuthContext::QAuthContext(QObject *parent) :
    QObject(parent)
{
}

QAuthContext::~QAuthContext()
{
}

void QAuthContext::reset()
{
    mPhone.clear();
    emit resetPages();
}

void QAuthContext::resend()
{
    emit requestAuth("+7"+mPhone.toString());
    qDebug() << "cpp: emit phone +7" << mPhone.toString();
}

void QAuthContext::setAuthCode(const QVariant &code)
{
    emit verifyAuth(code.toString());
    qDebug() << "cpp: emit code" << code.toString();
}

QVariant QAuthContext::phone() const
{
    QString phone = mPhone.toString();
    return QString("+7 (%1) %2-%3-%4")
                    .arg(phone.left(3))
                    .arg(phone.mid(3, 3))
                    .arg(phone.mid(6, 2))
                    .arg(phone.mid(8, 2));
}

void QAuthContext::setPhone(const QVariant &phone)
{
    mPhone = phone;
    emit requestAuth("+7"+phone.toString());
    qDebug() << "cpp: emit phone +7" << phone.toString();

    emit phoneChanged();
}

void QAuthContext::confirmProfile()
{
    emit confirmAuth(QTokens::CONFIRM);

    qDebug() << "cpp: emit CONFIRM token to server";
}

void QAuthContext::onAuthConfirmPage(const QString &token, const QContact *profile)
{
    Q_UNUSED(token)
    emit authReVerify(profile->username(), profile->avatarUrl().toString());
}

QString QAuthContext::secondsToDHMS(quint32 duration)
{
    //return QTamApp::secondsToDHMS(duration);
    QString res;
    int seconds = (int) (duration % 60);
    duration /= 60;
    int minutes = (int) (duration % 60);
    duration /= 60;
    int hours = (int) (duration % 24);
    int days = (int) (duration / 24);
    if((hours == 0) && (days == 0))
        return res.sprintf("%02d:%02d", minutes, seconds);
    else if (days == 0)
        return res.sprintf("%02d:%02d:%02d", hours, minutes, seconds);
    else
        return res.sprintf("%dd %02d:%02d:%02d", days, hours, minutes, seconds);
}
