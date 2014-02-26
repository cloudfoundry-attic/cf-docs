---
title: Integrating Dashboard Single Sign-On
---

## Introduction

Single sign-on (SSO) allows Cloud Foundry users to authenticate with third-party services
using their Cloud Foundry credentials.  SSO provides a streamlined experience to users,
limiting repeated logins and multiple accounts across their managed services.

In order to make this possible, CF provides API endpoints for configuration and
verification of the user credentials.  This allows third-party services to verify user credentials
without needing the user to login again.  The user's credentials are never directly transmitted to
the service since the OAuth2 protocol handles authentication.  Similarly, Cloud Controller provides
an endpoint to determine a user's authorization.

## The SSO interaction and points of integration
  1. In order to integrate a dashboard with CF, service brokers will need to include the necessary
    properties in their catalog. Specifically, each service implementing this feature must
    advertise a `dashboard_client` property in their JSON response from `/v2/catalog`. A valid
    response would appear as follows:

    ```
    {
      "services": [
        {
          "id": "44b26033-1f54-4087-b7bc-da9652c2a539",
          ...
          "dashboard_client": {
            "id": "p-mysql-client",
            "secret": "p-mysql-secret",
            "redirect_uri": "http://p-mysql.example.com/auth/create"
          }
        }
      ]
    }
    ```

    The properties under the `dashboard_client` key are explained
    [here](catalog-metadata.html#services-metadata-fields).

  2. Whenever the catalog for this service broker is created or updated, Cloud Controller will
    create or update UAA clients for any services that advertise SSO capability. This client
    will be used by the service to authenticate users. Operators verify the existance of
    service UAA clients using the [uaac](https://github.com/cloudfoundry/cf-uaac) tool.

    ```
    $ uaac clients
      admin
        scope: uaa.none
        resource_ids: none
        authorized_grant_types: client_credentials
        authorities: password.write clients.write clients.read scim.read uaa.admin clients.secret
      p-mysql-client
        scope: cloud_controller.read cloud_controller.write openid
        resource_ids: none
        authorized_grant_types: authorization_code refresh_token
        redirect_uri: http://p-mysql.example.com/auth/create
        authorities: uaa.none
    ```

  3. At this point, users will be able to click the `Manage` link on their CF Web console,
    seamlessly allowing them to access the dashboard for the service.
    <br />
    ![Managing a Service](../../../../images/web-ui-manage-service.png)

  4. At this point, the service will need to obtain an access token from UAA.  The service should
    use the standardized OAuth2 protocol to retrieve this token.  See [Resources](#resources)
    for more information regarding OAuth2 and for an example broker/service dashboard implementation.

    Users will be redirected from the service dashboard to UAA to login and approve the permissions
    requested by the service.  Upon granting the permissions, the user will be redirected back
    to the service `redirect_uri` described above.  The service will then need to check the specific
    user permissions for this service instance with Cloud Controller.

  5. UAA is responsible for authenticating a user and providing the service with an access token
    with the requested permissions.  However, it is the responsibility of the service to verify
    that the user making the request to manage an instance has the required permissions.  The service
    can accomplish this by hitting the `/v2/service_instances/:guid/permissions` endpoint on the
    Cloud Controller.  The API request would go as follows:

    ```
    curl -H 'Content-Type: application/json' \
         -H 'Authorization: bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoidWFhLWlkLTciLCJlbWFpbCI6ImVtYWlsLTdAc29tZWRvbWFpbi5jb20iLCJzY29wZSI6WyJjbG91ZF9jb250cm9sbGVyLmFkbWluIl0sImF1ZCI6WyJjbG91ZF9jb250cm9sbGVyIl0sImV4cCI6MTM5Mjc0NzIzNH0.IUsMEB95qiBazm-iyVlekBomBEuMYHTufeB3SLiGpWM' \
         http://api.cloudfoundry.com/v2/service_instances/44b26033-1f54-4087-b7bc-da9652c2a539/permissions

    =>
      {
        "manage": true
      }
    ```

    This request should use the token of the user for authorization.

    The response will indicate to the service whether this user is allowed to manage the given instance.
    A `true` value for the `manage` key indicates sufficient permissions; `false` would indicate insufficient
    permissions.  Since administrators may change the permissions of users, the service is responsible for
    determining a reasonable policy as to how often to check this endpoint in order to ensure that a user
    still has the necessary permissions.

<a id="resources"></a>
## Resources
  * [OAuth2](http://oauth.net/2/)
  * [Example broker SSO implementation](https://github.com/cloudfoundry/cf-mysql-broker)
  * [Cloud Controller API Docs](http://apidocs.cfapps.io/)
