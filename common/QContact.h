#ifndef QCONTACT_H
#define QCONTACT_H

#include <QObject>
#include <QUrl>

class QContact: public QObject
{
    Q_OBJECT

public:
    QContact(QObject *parent = 0);
    ~QContact();

    QUrl avatarUrl() const;
    void setAvatarUrl(const QUrl &url);

    QString username() const;
    void setUsername(const QString &name);

private:
    QUrl    url;
    QString name;
};

#endif // QCONTACT_H
