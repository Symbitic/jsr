#ifndef ENDPOINT_H
#define ENDPOINT_H

#include <QtQml/qqml.h>
#include <QtNetwork/qrestaccessmanager.h>
#include <QtNetwork/qnetworkrequestfactory.h>
#include <QtCore/qobject.h>
#include <QtCore/qjsonobject.h>

class Endpoint : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonObject data READ data NOTIFY dataUpdated)
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathUpdated)
    Q_PROPERTY(QString method READ method WRITE setMethod NOTIFY methodUpdated)
    QML_ELEMENT

public:
    explicit Endpoint(QObject *parent = nullptr);
    ~Endpoint() override = default;

    QJsonObject data() const;

    QString path() const;
    void setPath(const QString &path);

    QString method() const;
    void setMethod(const QString &method);

    Q_INVOKABLE void fetchData(const QVariantMap &params);
    Q_INVOKABLE void fetchData();
    void setAccessManager(std::shared_ptr<QRestAccessManager> manager);
    void setServiceApi(std::shared_ptr<QNetworkRequestFactory> serviceApi);
    void setAccessToken(const QString &accessToken);
    void setBaseUrl(const QString &baseUrl);

signals:
    void dataUpdated();
    void pathUpdated();
    void methodUpdated();

private:
    void requestFinished(const QJsonDocument &json);
    void requestFailed();

    std::shared_ptr<QRestAccessManager> m_manager;
    std::shared_ptr<QNetworkRequestFactory> m_api;
    QJsonObject m_data;
    QString m_path;
    QString m_method;
    QString m_accessToken;
    QString m_baseUrl;
};

#endif // ENDPOINT_H
