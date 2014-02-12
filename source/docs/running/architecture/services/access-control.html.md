---
title: Access Control
---

By default, new service plans are private. This means that when adding a new broker, or adding a new plan to a broker's catalog and updating the broker in Cloud Foundry, the plans won't immediately be available to end users. This enables an admin to control which service plans are available to end users, and to manage limited availability. This is important as in many cases Cloud Foundry admins will not have operational control of service brokers as they may be deployed and managed by other service providers.

Currently, access control requires using `cf curl`. Dedicated CLI commands are coming soon. These instructions assume use of the [go-based v6 CLI](https://github.com/cloudfoundry/cli).

## <a id='make-plans-public'></a>Make Plans Public ##

The first step is to get the service plan guid. The following curl will return a JSON response which includes something like the following for each service plan.

<pre class="terminal">
$ cf curl /v2/service_plans
...
{
      "metadata": {
        "guid": "1afd5050-664e-4be2-9389-6bf0c967c0c6",
        "url": "/v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6",
        "created_at": "2014-02-12T06:24:04+00:00",
        "updated_at": "2014-02-12T18:46:52+00:00"
      },
      "entity": {
        "name": "plan-name-1",
        "free": true,
        "description": "plan-desc-1",
        "service_guid": "d9011411-1463-477c-b223-82e04996b91f",
        "extra": "{\"bullets\":[\"bullet1\",\"bullet2\"]}",
        "unique_id": "plan-id-1",
        "public": false,
        "service_url": "/v2/services/d9011411-1463-477c-b223-82e04996b91f",
        "service_instances_url": "/v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6/service_instances"
      }
}
</pre>

Now run the following curl using the service plan url above. In the response you can verify that `"public": true"`.

<pre class="terminal">
$ cf curl /v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6 -X PUT -d '{"public":true}'
{
  "metadata": {
    "guid": "1afd5050-664e-4be2-9389-6bf0c967c0c6",
    "url": "/v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6",
    "created_at": "2014-02-12T06:24:04+00:00",
    "updated_at": "2014-02-12T20:55:10+00:00"
  },
  "entity": {
    "name": "plan-name-1",
    "free": true,
    "description": "plan-desc-1",
    "service_guid": "d9011411-1463-477c-b223-82e04996b91f",
    "extra": "{\"bullets\":[\"bullet1\",\"bullet2\"]}",
    "unique_id": "plan-id-1",
    "public": true,
    "service_url": "/v2/services/d9011411-1463-477c-b223-82e04996b91f",
    "service_instances_url": "/v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6/service_instances"
  }
}
</pre>

All users should now see the service plan in the list of available services. See [Managing Services](../../../using/services/managing-services.html).

### <a id='make-plans-private'></a>Make Plans Private ###

Same as above except use `"public":false`.

<pre class="terminal">
$ cf curl /v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6 -X PUT -d '{"public":false}'
{
  "metadata": {
    "guid": "1afd5050-664e-4be2-9389-6bf0c967c0c6",
    "url": "/v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6",
    "created_at": "2014-02-12T06:24:04+00:00",
    "updated_at": "2014-02-12T20:55:43+00:00"
  },
  "entity": {
    "name": "plan-name-1",
    "free": true,
    "description": "plan-desc-1",
    "service_guid": "d9011411-1463-477c-b223-82e04996b91f",
    "extra": "{\"bullets\":[\"bullet1\",\"bullet2\"]}",
    "unique_id": "plan-id-1",
    "public": false,
    "service_url": "/v2/services/d9011411-1463-477c-b223-82e04996b91f",
    "service_instances_url": "/v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6/service_instances"
  }
}
</pre>

## <a id='limited-availability'></a>Limited Availability ##

To make a private plan available to a specific organization, we need the guid of the organization and of the service plan. The plan guid can be obtained with the same command as for [Make Plans Public](#make-plans-public).

To get the organization guid run the following curl.

<pre class="terminal">
$ cf curl /v2/organizations
{
  "metadata": {
    "guid": "c54bf317-d791-4d12-89f0-b56d0936cfdc",
    "url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc",
    "created_at": "2013-05-06T16:34:56+00:00",
    "updated_at": "2013-09-25T18:44:35+00:00"
  },
  "entity": {
    "name": "my-org",
    "billing_enabled": true,
    "quota_definition_guid": "52c5413c-869f-455a-8873-7972ecb85ca8",
    "status": "active",
    "quota_definition_url": "/v2/quota_definitions/52c5413c-869f-455a-8873-7972ecb85ca8",
    "spaces_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/spaces",
    "domains_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/domains",
    "private_domains_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/private_domains",
    "users_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/users",
    "managers_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/managers",
    "billing_managers_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/billing_managers",
    "auditors_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/auditors",
    "app_events_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc/app_events"
  }
}
</pre>

Now we'll put the two pieces together.

<pre class="terminal">
$ cf curl /v2/service_plan_visibilities -X POST -d '{"service_plan_guid":"1afd5050-664e-4be2-9389-6bf0c967c0c6","organization_guid":"c54bf317-d791-4d12-89f0-b56d0936cfdc"}'
{
  "metadata": {
    "guid": "286c3789-a368-483e-ae7c-ebe79e17130a",
    "url": "/v2/service_plan_visibilities/286c3789-a368-483e-ae7c-ebe79e17130a",
    "created_at": "2014-02-12T21:03:42+00:00",
    "updated_at": null
  },
  "entity": {
    "service_plan_guid": "1afd5050-664e-4be2-9389-6bf0c967c0c6",
    "organization_guid": "c54bf317-d791-4d12-89f0-b56d0936cfdc",
    "service_plan_url": "/v2/service_plans/1afd5050-664e-4be2-9389-6bf0c967c0c6",
    "organization_url": "/v2/organizations/c54bf317-d791-4d12-89f0-b56d0936cfdc"
  }
}
</pre>

Members of the specified organization should now see the service plan in the list of available services when the organization is targeted. While another organization is targeted, the service plan will not be available. Users who are not members of the organization will never see the plan. See [Managing Services](../../../using/services/managing-services.html).

### <a id='delete-plan-visibility'></a>Disable Plan Visibility ###

To remove access to a private service plan from an organization.

<pre class="terminal">
$ cf curl /v2/service_plan_visibilities/286c3789-a368-483e-ae7c-ebe79e17130a -X DELETE
</pre>
