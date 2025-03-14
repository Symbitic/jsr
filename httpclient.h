#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QtQml/qqml.h>
#include <QtQml/qqmlparserstatus.h>
#include <QtNetwork/qrestaccessmanager.h>
#include <QtNetwork/qnetworkrequestfactory.h>
#include <QtCore/qobject.h>
#include "endpoint.h"

class HTTPClient : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(QString accessToken READ accessToken WRITE setAccessToken NOTIFY accessTokenChanged)
    Q_PROPERTY(QUrl base READ base WRITE setBase NOTIFY baseChanged)
    Q_PROPERTY(QQmlListProperty<Endpoint> endpoints READ endpoints)
    Q_CLASSINFO("DefaultProperty", "endpoints")
    Q_INTERFACES(QQmlParserStatus)
    QML_ELEMENT

public:
    explicit HTTPClient(QObject *parent = nullptr);
    ~HTTPClient() override = default;

    QString accessToken() const;
    void setAccessToken(const QString &accessToken);

    QUrl base() const;
    void setBase(const QUrl &base);

    void classBegin() override;
    void componentComplete() override;

    QQmlListProperty<Endpoint> endpoints();

signals:
    void accessTokenChanged();
    void baseChanged();

private:
    QString m_accessToken;
    QUrl m_base;
    QList<Endpoint *> m_endpoints;
    QNetworkAccessManager m_networkAccessManager;
    std::shared_ptr<QRestAccessManager> m_manager;
    std::shared_ptr<QNetworkRequestFactory> m_serviceApi;
};

#endif
