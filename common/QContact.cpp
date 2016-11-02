#include "QContact.h"

QContact::QContact(QObject *parent) :
    QObject(parent)
{

}

QContact::~QContact()
{
}

QUrl QContact::avatarUrl() const
{
    return this->url;
}

void QContact::setAvatarUrl(const QUrl &url)
{
    this->url = url;
}

void QContact::setUsername(const QString &name)
{
    this->name = name;
}

QString QContact::username() const
{
    return this->name;
}
