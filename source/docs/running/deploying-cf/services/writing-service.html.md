---
title: Writing a CloudFoundry Service
---

There are 2 versions of the SERVICES API, this document represents version 1 of that API.
Documentation for the newer v2 API will be available when that API is sufficiently finished, as it is currently under construction.

Writing a service involves writing a gateway that obeys the API contract between CloudController v2 (CC) and the gateway v1 (GW).
The protocol is entirely RESTful HTTP, with _bidirectional communication_.
There are 6 basic operations that take place, described later in this document:

* [catalog management](#catalog)
* [provision](#provision)
* [bind](#bind)
* [unbind](#unbind)
* [deprovision](#deprovision)
* [orphan detection](#orphans) _(optional)_

Authentication
--------------
_CC authenticates to a GW using a shared secret_

The GW must reject all requests not including the shared secret with a 401 unauthorized response.
The token is registered into CC by an admin user, usually using the cf CLI gem which adds commands like `cf create-service-auth-token`.
Or one can directly make calls to the CC v2 RESTful API to register a new shared secret (called auth token).

_A GW authenticates to CC using a UAA token_

Like all API endpoints in CC, the GW must first obtain and then include a valid Oauth2 token from UAA.  This token must include
the scope `cloud_controller.admin`, because only this scope has permission to modify the services catalog.

<span id="catalog">Catalog Management</span>
------------------
With v2 of CC, a gateway is responsible for maintaining its catalog of offerings and plans by issuing various RESTful API calls to CC.
Normally the lifecycle is as follows:

1. On startup, the gateway communicates with UAA to get an access token with sufficient permissions to access CC (currently admin access).
1. It then downloads the catalog of all available service offerings and plans from CC
1. It issues POST requests to create missing offerings and plans.  Offerings include a URL to access the gateway responsible for future provision/bind requests.
1. It issues PUT requests to update existing offerings and plans that are not in sync
1. It issues DELETE requests to remove offerings and plans it no longer wants to advertise

All catalog management APIs are in the CloudController.
A service is identified by the combination of `[label, provider, version]`, which must be unique.
A plan is identified by `[service_guid, name]`, which must also be unique.

Because compound primary keys are annoying to work with, we introduced the concept of `unique_id` string fields, but we made them optional for backwards compatibility.
Updating a service by `unique_id` allows you to make changes to fields inside the old primary key, like label and provider, without having to create a new service.

To generate a `unique_id`, try this [Online GUID Generator](http://www.guidgenerator.com/ "Online GUID Generator").

_API_

Creating a new service in the catalog: `POST /v2/services`
<table>
<thead>
<tr>
  <th>Request field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>label*</td>
  <td>string</td>
  <td>The type of service offered, like “mongodb”, this must match the name of the service used for the service-auth-token</td>
</tr>
<tr>
  <td>provider*</td>
  <td>string</td>
  <td>The provider of the service, such as “core” or “mongolab”</td>
</tr>
<tr>
  <td>url*</td>
  <td>string</td>
  <td>The callback URL of the gateway</td>
</tr>
<tr>
  <td>description*</td>
  <td>string</td>
  <td>Description to be displayed in CF frontends</td>
</tr>
<tr>
  <td>version*</td>
  <td>string</td>
  <td>The version string of the service provided to be displayed to users, 5.5 for mysql “5.5”.  Multiple of the same services can exist with different versions.</td>
</tr>
<tr>
  <td>info_url</td>
  <td>string</td>
  <td>(Currently unused) A URL that users can visit to determine more information about a service offering</td>
</tr>
<tr>
  <td>acls</td>
  <td>string</td>
  <td>(Currently unused)</td>
</tr>
<tr>
  <td>timeout</td>
  <td>integer</td>
  <td>(Currently unused) How long the CC should wait for a gateway to finish an operation before giving up.</td>
</tr>
<tr>
  <td>active</td>
  <td>bool</td>
  <td>Used as a hint to CF front-ends that a service is not active and can no longer be provisioned (not enforced by CC)</td>
</tr>
<tr>
  <td>extra</td>
  <td>string</td>
  <td>JSON-encoded-string of extra data to be used by frontend clients</td>
</tr>
<tr>
  <td>unique_id</td>
  <td>string</td>
  <td>A new identifier that must be globally unique.  This ID will be passed as part of provision, bind, etc. requests.  This “primary key” is easier to work with than the combination of [label, provider, version] which also forms a “primary key”.</td>
</tr>
<tr>
  <td>service_plans</td>
  <td>array of objects</td>
  <td>A list of service plan objects to created along as part of this service (see POST /v2/service_plans for list of fields).</td>
</tr>
</tbody>
</table>
<table>
<thead>
<tr>
  <th>Response field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>metadata</td>
  <td>object</td>
  <td>Contains guid and CC URL for manipulating the newly created resource</td>
</tr>
<tr>
  <td>entity</td>
  <td>object</td>
  <td>Contains all the same fields as above</td>
</tr>
</tbody>
</table>
<table>
<thead>
<tr>
  <th>Response code</th>
  <th>Response meaning</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>201</td>
  <td>Created</td>
  <td>
  Service successfully created, example response:

    {
      "metadata" = > {
        "guid" = > "9201fc22-ee74-42c8-9dcd-4425be183074",
        "url" = > "/v2/services/9201fc22-ee74-42c8-9dcd-4425be183074",
        "created_at" = > "2013-07-01 14:54:06 +0000",
        "updated_at" = > nil
      }, "entity" = > {
        "label" = > "push-gateway-1.0",
        "provider" = > "aws",
        "url" = > "http://where.your.gateway.lives.org",
        "description" = > "Your Gateway",
        "version" = > "1.0",
        "info_url" = > nil,
        "active" = > false,
        "unique_id" = > "pg-1.0",
        "extra" = > nil,
        "service_plans_url" = > "/v2/services/9201fc22-ee74-42c8-9dcd-4425be183074/service_plans"
      }
    }

  </td>
</tr>
<tr>
  <td>400</td>
  <td>Bad request</td>
  <td>one of: already defined, bad request, invalid params, missing field (error message in the CC log will have details as to why)</td>
</tr>
<tr>
  <td>401/403</td>
  <td>Unauthenticated/Forbidden</td>
  <td>Invalid or missing UAA oauth2 token in request</td>
</tr>
<tr>
  <td>500</td>
  <td>Server error</td>
  <td>Something in CC went wrong, check log</td>
</tr>
</tbody>
</table>

Updating a service in the catalog:  `PUT /v2/services`
<table>
<thead>
<tr>
  <th>Optional request query parameter</th>
  <th>Possible values</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>collection-method</td>
  <td>add<br/>replace</td>
  <td>Merge any supplied plans with existing plans<br/>Replace existing plans with supplied plans </td>
</tr>
</tbody>
</table>

<table>
<thead>
<tr>
  <th>Request field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>label*<br/>provider*</br>version*</td>
  <td>string</td>
  <td>If unique_id is not provided, used to find the existing service to be updated</td>
</tr>
<tr>
  <td>unique_id</td>
  <td>string</td>
  <td>When provided, used to find the existing service to be updated</td>
</tr>
<tr>
  <td colspan="3"><em>Everything else same as create endpoint</em></td>
</tr>
</tbody>
</table>

Listing the services catalog:  `GET /v2/services`
<table>
<thead>
<tr>
  <th>Optional request query parameter</th>
  <th>Possible values</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>limit</td>
  <td>integer</td>
  <td></td>
</tr>
<tr>
  <td>offset</td>
  <td>integer</td>
  <td></td>
</tr>
<tr>
  <td>urls-only</td>
  <td>1</td>
  <td>If 1 only return a list of URLs for each service</td>
</tr>
<tr>
  <td>inline-relation-depth</td>
  <td>0-3</td>
  <td>Set to 1 to get plans as well<br/>Set to 2 to get plans & instances<br/>Set to 3 to get plans & instances & bindings</td>
</tr>
<tr>
  <td>q</td>
  <td>string</td>
  <td>Query to filter the returned service offerings, like `active:1`</td>
</tr>
</tbody>
</table>

<table>
<thead>
<tr>
  <th>Response field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>metadata</td>
  <td>object</td>
  <td>Contains guid and CC URL for each service resource</td>
</tr>
<tr>
  <td>entity</td>
  <td>object</td>
  <td>
    <em>Contains all the same fields as create</em><br/>
    Also contains “service_plans_url”, a CC URL to download the list of plans.  May also contain a full list of plans, depending in query params
  </td>
</tr>
</tbody>
</table>

Removing a service from the catalog:  `DELETE /v2/services/:guid`

No body or query parameters.  This request is expected to fail if there are plans, instances, or bindings attached to this service, as they must be deleted first.

Creating a new plan in the catalog: `POST /v2/service_plans`

<table>
<thead>
<tr>
  <th>Request field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>name*</td>
  <td>string</td>
  <td>The name of the plan, unique when scoped by service GUID</td>
</tr>
<tr>
  <td>free*</td>
  <td>bool</td>
  <td>Displayed by frontends, used by quota_definitions to determine whether an org can provision a service</td>
</tr>
<tr>
  <td>description*</td>
  <td>string</td>
  <td>Description to be displayed in CF frontends</td>
</tr>
<tr>
  <td>extra</td>
  <td>string</td>
  <td>JSON-encoded-string of extra data to be used by frontend clients</td>
</tr>
<tr>
  <td>unique_id</td>
  <td>string</td>
  <td>A new identifier that must be unique.  This ID will be passed as part of provision, bind, etc. requests.  This “primary key” is easier to work with than the combination of [label, provider, version] which also forms a “primary key”.</td>
</tr>
<tr>
  <td>public</td>
  <td>bool</td>
  <td>Whether a plan should be automatically visible for all users. When false, the rules behind service_plan_visibilities are used to decide visibility.</td>
</tr>
<tr>
  <td>service_guid*</td>
  <td>string</td>
  <td>GUID of the parent service for this plan</td>
</tr>
</tbody>
</table>

<table>
<thead>
<tr>
  <th>Response field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>metadata</td>
  <td>object</td>
  <td>Contains guid and CC URL for manipulating the newly created resource</td>
</tr>
<tr>
  <td>entity</td>
  <td>object</td>
  <td>
    <em>Contains all the same fields as create</em>
  </td>
</tr>
</tbody>
</table>

Listing the plans: `GET /v2/service_plans`
<table>
<thead>
<tr>
  <th>Optional request query parameter</th>
  <th>Possible values</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>limit</td>
  <td>integer</td>
  <td></td>
</tr>
<tr>
  <td>offset</td>
  <td>integer</td>
  <td></td>
</tr>
<tr>
  <td>urls-only</td>
  <td>1</td>
  <td>If 1 only return a list of URLs for each plan</td>
</tr>
<tr>
  <td>inline-relation-depth</td>
  <td>0-2</td>
  <td>Set to 1 to get instances & spaces & service as well<br/>Set to 2 to get service & instances & spaces & bindings
</tr>
<tr>
  <td>q</td>
  <td>string</td>
  <td>Query to filter the returned service offerings, like `name:something`</td>
</tr>
</tbody>
</table>

<table>
<thead>
<tr>
  <th>Response field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>metadata</td>
  <td>object</td>
  <td>Contains guid and CC URL for each plan resource</td>
</tr>
<tr>
  <td>entity</td>
  <td>object</td>
  <td>
    <em>Contains all the same fields as create</em><br/>
    Also contains “service_instances_url”, a CC URL to download the list of instances, and “service_url”, a CC URL to the parent service
  </td>
</tr>
</tbody>
</table>

Updating a plan in the catalog: `PUT /v2/service_plans/:guid`

<table>
<thead>
<tr>
  <th>Request field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>service_guid*<br/>name*
  <td>string</td>
  <td>If unique_id is not provided, used to find the existing plan to be updated</td>
</tr>
<tr>
  <td>unique_id</td>
  <td>string</td>
  <td>When provided, used to find the existing plan to be updated</td>
</tr>
<tr>
  <td colspan="3"><em>Everything else same as create endpoint</em></td>
</tr>
</tbody>
</table>

Removing a plan from the catalog: `DELETE /v2/service_plans/:guid`

* No body
* No query parameters.

This request is expected to fail if there instances or bindings attached to this plan, as they must be deleted first.

<span id="provision">Provisioning</span>
--------------------

When a developer asks to provision a service (using `cf create-service`), they issue an API request to CC including the offering, plan, and space.
CC uses its database to determine what gateway is responsible for this offering and issues an API request synchronously to the GW to provision the resources.
This request includes less information than the user-initiated request, because GWs are supposed to not care about some CF concepts like users, spaces, and organizations.

The GW must then provision the resource, if possible, and respond with a “gateway identifier” (GWID) that can be used to identify the resource for future operations.
In CF terms, what is created after provisioning is a “service instance”.
No application should have access to the service instance until it has been bound by the user, so usually no service credentials exist at the time of provisioning.

To provision, CC sends a provision request to the gateway.
The full request URL is determined by concatenating the URL in the catalog + the path below.

`POST :service_url/gateway/v1/configurations`

<table>
<thead>
<tr>
  <th>Request field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>unique_id*</td>
  <td>string</td>
  <td>The unique_id of the desired <strong>service_plan</strong> to be provisioned</td>
</tr>
<tr>
  <td>name*</td>
  <td>string</td>
  <td>The user-provided name of the new instance</td>
</tr>
<tr>
  <td>email</td>
  <td>string</td>
  <td>The email address of the provisioning user</br><em>do not use</em></td>
</tr>
<tr>
  <td>provider</td>
  <td>string</td>
  <td>The provider of the service to provision, in case the gateway is responsible for multiple services</td>
</tr>
<tr>
  <td>label</td>
  <td>string</td>
  <td>The label of the service to provision, in case the gateway is responsible for multiple services</td>
</tr>
<tr>
  <td>plan</td>
  <td>string</td>
  <td>The name of the plan to be provisioned</td>
</tr>
<tr>
  <td>version</td>
  <td>string</td>
  <td>The version of the service to provision, in case the gateway is responsible for multiple versions</td>
</tr>
<tr>
  <td>organization_guid</td>
  <td>string</td>
  <td>The GUID of the organization under which the service will be provisioned (try not to use this)</td>
</tr>
<tr>
  <td>space_guid</td>
  <td>string</td>
  <td>The GUID of the space under which the service will be provisioned (try not to use this)</td>
</tr>
<tr>
  <td>plan_option</td>
  <td>string</td>
  <td>(Currently unused) User-provided options for the instance</td>
</tr>
</tbody>
</table>

<table>
<thead>
<tr>
  <th>Response field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>service_id*</td>
  <td>string</td>
  <td>A GW-generated identifier that represents the resource, and will be passed to the GW for future bind/deprovision requests</td>
</tr>
<tr>
  <td>configuration*</td>
  <td>object</td>
  <td>The configuration used to provision this service, usually a copy of the request attributes</td>
</tr>
<tr>
  <td>credentials*</td>
  <td>object</td>
  <td>Any credentials that were generated as a result of provisioning, that the GW would like to be stored in CC.</td>
</tr>
<tr>
  <td>dashboard_url</td>
  <td>string</td>
  <td>If applicable, the URL that an end-user can visit to monitor/manage the provisioned instances</td>
</tr>
</tbody>
</table>

<span id="bind">Binding</span>
--------

Binding is a developer-initiated intention (using `cf bind-service`) to make a service instance available to a specific application,
and it usually has side effects (such as creating new credentials for an application to access a database).
Like provisioning, the developer makes an API call to CC including the instance ID and app ID to be bound,
and CC makes an API call to the GW including just the service instance ID (gateways don’t know about apps).

The GW must then create a binding, if possible, and respond with both a GWID and credentials.
For services where there is only 1 set of credentials to a logical resource,
binding can simply return the same credentials to each application,
though it will be impossible to properly revoke access to an application during unbind.

To bind, CC sends a bind request to the gateway.
The full request URL is determined by concatenating the URL in the catalog + the path below.
For legacy reasons, a binding is known as a “handle” on the gateway side.

`POST /gateway/v1/configurations/:service_id/handles`

<table>
<thead>
<tr>
  <th>Request field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>service_id*</td>
  <td>string</td>
  <td>The GW-generated identifier that identifies the instance to be bound</td>
</tr>
<tr>
  <td>label*</td>
  <td>string</td>
  <td>The string "#{service.label}-#{service.version}", such as “mysql-5.5”</td>
</tr>
<tr>
  <td>email*</td>
  <td>string</td>
  <td>The email address of the provisioning user<br/>
  <em>do not use, but it it required to make a valid message</em>
  </td>
</tr>
<tr>
  <td>binding_options*</td>
  <td>object</td>
  <td>(Currently unused) User-provided options for the binding</td>
</tr>
</tbody>
</table>

<table>
<thead>
<tr>
  <th>Response field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>service_id*</td>
  <td>string</td>
  <td>An identifier that’s generated by the GW and will be passed to the GW for future unbind requests, it’s really a “handle_id” not a service_id.</td>
</tr>
<tr>
  <td>configuration*</td>
  <td>object</td>
  <td>The configuration used to provision this service, usually a copy of the request attributes</td>
</tr>
<tr>
  <td>credentials*</td>
  <td>object</td>
  <td>The credentials that were generated as part of this binding. These credentials will be passed to the bound application as part of the VCAP_SERVICES environment variable.</td>
</tr>
</tbody>
</table>

<span id="unbind">Unbinding</span>
--------
Simply the opposite of bind, unbind is the developer-initiated intention to revoke a specific application’s access to a service instance.
The developer makes an API call to CC, which makes an API call to the GW including the GWID of the binding that should be destroyed.
If possible, the bound credentials should be destroyed so that application can no longer access the resource.

To delete a binding, CC sends an unbind request to the gateway.
The full request URL is determined by concatenating the URL in the catalog + the path below.

`DELETE /gateway/v1/configurations/:service_id/handles/:handle_id`

* Note: the `service_id` and `handle_id` exist in both the URL and BODY, see table:

<table>
<thead>
<tr>
  <th>Request field</th>
  <th>Type</th>
  <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td>service_id*</td>
  <td>string</td>
  <td>The GW service_id that was returned from the <strong>provision</strong> response</td>
</tr>
<tr>
  <td>handle_id*</td>
  <td>string</td>
  <td>The GW service_id that was returned from the <strong>binding</strong> response</td>
</tr>
<tr>
  <td>binding_options</td>
  <td>string</td>
  <td>(Currently Unused)</td>
</tr>
</tbody>
</table>

<span id="deprovision">Deprovisioning</span>
--------------
Simply the opposite of provision, deprovision is the developer-initiated intention to remove a specific service instance.
The developer makes an API call to CC, which makes an API call to the GW including the GWID of the instance that should be destroyed.
The resources consumed by the service instance should be released, and hopefully made available to future requests.

To delete a service instance, CC sends a deprovision request to the gateway.
The full request URL is determined by concatenating the URL in the catalog + the path below.

`DELETE /gateway/v1/configurations/:service_id`

* No body
* No query parameters

The only argument, `service_id` is the GW service_id that was returned from the provision response, and there is no body to the request or response.

<span id="orphans">Orphan Detection and Cleanup</span>
--------------------

CC is the source of truth, and the GW and CC can end up disagreeing about which services and binding exist.
In this case, the GW is responsible for removing the bindings and instances that don’t exist anymore in the CC.
There are CC endpoints for getting a list of bindings and instances, and the GW should use these to find orphans and prune them.
