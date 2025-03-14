#include <QtNetwork/qrestaccessmanager.h>
#include <QtNetwork/qrestreply.h>
#include <QtCore/qjsonarray.h>
#include <QtCore/qjsondocument.h>
#include <QtCore/qjsonobject.h>
#include <QtCore/qurlquery.h>
#include "endpoint.h"

Endpoint::Endpoint(QObject *parent)
    : QObject(parent)
{
}

void Endpoint::setAccessManager(std::shared_ptr<QRestAccessManager> manager)
{
    m_manager = manager;
}

void Endpoint::setServiceApi(std::shared_ptr<QNetworkRequestFactory> serviceApi)
{
    m_api = serviceApi;
}

void Endpoint::setAccessToken(const QString &accessToken)
{
    m_accessToken = accessToken;
}

void Endpoint::setBaseUrl(const QString &baseUrl)
{
    m_baseUrl = baseUrl;
}

QJsonObject Endpoint::data() const
{
    return m_data;
}

QString Endpoint::path() const
{
    return m_path;
}

void Endpoint::setPath(const QString &path)
{
    if (m_path == path || path.isEmpty()) {
        return;
    }
    m_path = path;
    emit pathUpdated();
}

QString Endpoint::method() const
{
    return m_method;
}

void Endpoint::setMethod(const QString &method)
{
    if (m_method == method || method.isEmpty()) {
        return;
    }
    m_method = method;
    emit methodUpdated();
}

void Endpoint::fetchData()
{
    fetchData({});
}

void Endpoint::fetchData(const QVariantMap &params)
{
    QUrlQuery query;
    if (!params.isEmpty()) {
        for (auto it = params.begin(); it != params.end(); ++it) {
            query.addQueryItem(it.key(), it.value().toString());
        }
    }
    if (m_method.toUpper() == QStringLiteral("GET")) {
        m_manager->get(m_api->createRequest(m_path, query), this, [this](QRestReply &reply) {
            if (const auto json = reply.readJson()) {
                requestFinished(*json);
            } else {
                requestFailed();
            }
        });
    }
}

void Endpoint::requestFinished(const QJsonDocument &json)
{
    m_data = json.object();
    emit dataUpdated();
}

void Endpoint::requestFailed()
{
    // TODO: How to handle errors?
}
