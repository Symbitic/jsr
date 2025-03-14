#include <QRestAccessManager>
#include "httpclient.h"

HTTPClient::HTTPClient(QObject *parent)
    : QObject(parent)
{
    m_networkAccessManager.setAutoDeleteReplies(true);
    m_manager = std::make_shared<QRestAccessManager>(&m_networkAccessManager);
    m_serviceApi = std::make_shared<QNetworkRequestFactory>();
}

QString HTTPClient::accessToken() const
{
    return m_accessToken;
}

void HTTPClient::setAccessToken(const QString &accessToken)
{
    if (m_accessToken == accessToken) {
        return;
    }
    m_accessToken = accessToken;

    for (const auto endpoint : std::as_const(m_endpoints)) {
        endpoint->setAccessToken(m_accessToken);
    }
    emit accessTokenChanged();
}

QUrl HTTPClient::base() const
{
    return m_serviceApi->baseUrl();
}

void HTTPClient::setBase(const QUrl &url)
{
    if (m_serviceApi->baseUrl() == url) {
        return;
    }
    m_serviceApi->setBaseUrl(url);
    emit baseChanged();
}

QQmlListProperty<Endpoint> HTTPClient::endpoints()
{
    return { this, &m_endpoints };
}

void HTTPClient::classBegin() { }

void HTTPClient::componentComplete()
{
    for (const auto endpoint : std::as_const(m_endpoints)) {
        endpoint->setAccessManager(m_manager);
        endpoint->setServiceApi(m_serviceApi);
        endpoint->setAccessToken(m_accessToken);
    }
}
