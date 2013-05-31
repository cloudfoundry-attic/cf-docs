---
title: Cloud Foundry API
---

_This documents the v2 version of the API.  v1 is unofficially documented at http://apidocs.cloudfoundry.com/_

## <a id='overview'></a> Overview ##

The Cloud Foundry V2 family of APIs follow RESTful principles.
The primary goal of the V2 API is to support the new entities in
the Team Edition release, and to address the shortcomings of V1 in terms of features and consistency.

The goals are as follows:

* **Consistency** across all resource URLs, parameters, request/response
  bodies, and error responses.

* **Partial updates** of a resource can be performed by providing a subset of the resources' attributes.  This is in contrast to the V1 API which required a read-modify-write cycle to update an attribute.

* **Pagination** support for each of the collections.

* **Filtering** support for each of the collections.

## <a id='authentication'></a> Authentication ##

Authentication is performed by providing a UAA Token in the _Authorization_ HTTP header.

**TBD:** insert snippet from Dale about the responses if the Token isn't provided, or if is invalid, expired, etc.

## <a id='versioning'></a> Versioning ##

The API version is specified in the URL, e.g. `POST /v2/foo_bars` to
create a new FooBar using version 2 of the API.

## <a id='debugging'></a> Debugging ##

The V2 API endpoints may optionally return a GUID in the `X-VCAP-Request-ID`
HTTP header.  The API endpoint will ideally log this GUID on all log lines and pass it to associated systems to assist with cross component log collation.

## <a id='basic-operations'></a> Basic Operations ##

Operations on resources follow standard REST conventions.  Requests and
responses for resources are JSON-encoded.  Error responses are also JSON
encoded.

### Common Attributes in Response Bodies

Response bodies have 2 components, `metadata` and `entity` sections.

The following attributes are contained in the `metadata` section:

| Attribute  | Description                                                                         |
| :---------  | :-----------                                                                         |
| guid       | Stable id for the resource.                                                         |
| url        | URL for the resource.                                                               |
| created_at | Date/Timestamp the resource was created, e.g. "2012-01-01 13:42:00 -0700"           |
| updated_at | Date/Timestamp the resource was updated.  null if the resource has not been updated |


### Creating Resources

`POST /v2/foo_bars` creates a FooBar.

The attributes for new FooBar are specified in a JSON-encoded request body.

A successful `POST` results in HTTP 201 with the `Location`
header set to the URL of the newly created resource.  The API endpoint should
return the Etag HTTP header for later use by the client
in support of opportunistic concurrency.

The attributes for the FooBar are returned in a JSON-encoded response body.

### Reading Resources

`GET /v2/foo_bars/:guid` returns the attributes for a specific
FooBar.

A successful `GET` results in HTTP 200.  The API endpoint should set the
Etag HTTP header for later use in opportunistic concurrency.

The attributes for the FooBar are returned in a JSON-encoded response body.

### Listing Resources

`GET /v2/foo_bars` lists the FooBars.

Successful `GET` requests return HTTP 200.

The attributes for the FooBar are returned in a JSON-encoded response body.

#### Pagination

All `GET` requests to collections are implicitly paginated, i.e. `GET
/v2/foo_bars` initiates a paginated request/response across all FooBars.

##### Pagination Response Attributes

A paginated response contains the following attributes:

| Attribute     | Description                                                                                       |
| :---------     | :-----------                                                                                       |
| total_results | Total number of results in the entire data set.                                                   |
| total_pages   | Total number of pages in the entire dataset.                                                      |
| prev_url      | URL used to fetch the previous set of results in the paginated response.  null on the first call. |
| next_url      | URL used to fetch the next set of ressults in the paginated response.  null on the last call.     |
| resources     | Array of resources as returned by a GET on the resource id.                                       |

The resources are expanded by default because in that is what is desired in the
common use cases.

##### Pagination Parameters

The following optional parameters may be specified in the initial GET, or
included in the query string to `prev_url` or `next_url`.

| Parameter        | Description                                                                      |
| ---------        | -----------                                                                      |
| page             | Page from which to start iteration                                               |
| results-per-page | Results to return per page                                                       |
| urls-only        | If 1, only return a list of urls; do not expand metadata or resource attributes |

If the client is going to iterate through the entire dataset, they are
encouraged to follow `next_url` rather than iterating by setting
page and results-per-page.

Example:

Request: `GET /v2/foo_bars?results-per-page=2`

Response:

```json
{
  "total_results": 10029,
  "prev_url": null,
  "next_url": "/v2/an_opaque_url",
  "resources": [
    {
      "metadata": {
        "guid": 5,
        "url": "/v2/foo_bars/5",
        "created_at":"2012-01-01 13:42:00 -0700",
        "updated_at":"2012-01-05 08:31:00 -0700"
      },
      "entity": {
        "name": "some name",
        "instances": 3
      }
    },
    {
      "metadata": {
        "guid": 7,
        "url": "/v2/foo_bars/7",
        "created_at":"2012-01-01 19:45:00 -0700",
        "updated_at":"2012-01-04 20:27:00 -0700"
      },
      "entity": {
        "name": "some other name",
        "instances": 2
      }
    }
  ]
}
```

#### Search/Filtering

Searching and Filtering are peformed via the `q` query parameter.  The value of
the `q` parameter is a key value pair containing the resource attribute name
and the query value, e.g: `GET /v2/foo_bars?q=name:some*` would return
both records shown in the pagination example above.

String query values may contain a `*` which will be treated at a shell style
glob.

Query values may also contain `>` or `<`, e.g. `GET /v2/foo_bars?q=instances:>2`.

The API endpoint may return an error if the resulting query performs an
unindexed search.

### Deleting Resources

`DELETE /v2/foo_bars/:guid` deletes a specific FooBar.

The caller may specify the `If-Match` HTTP header to enable opportunistic
concurrency.  This is not required.  If there is an opportunistic concurrency
failure, the API endpoint should return HTTP 412.

A successful `DELETE` operation results in a 204.

### Updating Resources

`PUT` differs from standard convention.  In order to avoid a read-modify-write
cycle when updating a single attribute, `PUT` is handled as if the `PATCH` verb
were used.  Specifically, if a resource with URL `/v2/foo_bars/99` has attributes

```json
{
  "metadata": {
    "guid": 99,
    "url": "/v2/foo_bars/99",
    "created_at":"2012-01-01 13:42:00 -0700",
    "updated_at":"2012-01-03 09:15:00 -0700"
  },
  "entity": {
    "name": "some foobar",
    "instances": 2,
  }
}
```

then a `PUT /v2/foo_bars/99` with a request body of `{"instances":3}` results
in a resource with the following attributes

```json
{
  "metadata": {
    "guid": 99,
    "url": "/v2/foo_bars/99",
    "created_at":"2012-01-01 13:42:00 -0700",
    "updated_at":"2012-01-05 08:31:00 -0700"
  },
  "entity": {
    "name": "some foobar",
    "instances": 3,
  }
}
```

A successful `PUT` results in HTTP 200.

The caller may specify the `If-Match` HTTP header to enable opportunistic
concurrency.  This is not required.  If there is an opportunistic concurrency
failure, the API endpoint should return HTTP 412.

The attributes for the updated FooBar are returned in a JSON-encoded response body.

Note: version 3 of this API might require `PUT` to contain the full list of required
attributes and such partial updates might only be supported via the HTTP
`PATCH` verb.

## <a id='associations'></a> Associations ##

### N-to-One

#### Reading N-to-One Associations

N-to-one relationships are indicated by an id and url attribute for the other
resource.  For example, if a FooBar has a 1-to-1 relationship with a Baz,
a `GET /v2/FooBar/:guid` will return the following attributes related to
the associated Baz (other attributes omitted)

```json
{
  "baz_guid": 5,
  "baz_url": "/v2/bazs/5"
}
```

#### Setting N-to-One Associations

Setting an n-to-one association is done during the initial `POST` for the
resource or during an update via `PUT`.  The caller only specifies the id,
not the url.  For example, to update change the Baz associated with the FooBar
in the example above, the caller could issue a
`PUT /v2/FooBar/:guid` with a body of `{ "baz_guid": 10 }`.  To disassociate
the resources, set the id to `null`.

### N-to-Many

#### Reading N-to-Many Associations

N-to-many relationships may be
N-to-Many relationships are indicated by a url attribute for the other
collection of resources.  For example, if a FooBaz has multiple Bars, a
`GET /v2/FooBaz/:id` will return the following attribute (other
attributes omitted)

```json
{
  "bars_url": "/v2/foo_baz/bars"
}
```

The URL will initiated a paginated response.

#### Setting N-to-Many Associations

Setting an n-to-many association is done during the initial `POST` for the
resource, during an update via `PUT`.

To create the association during a `POST` or to edit it with a `PUT`, supply a
an array of ids.  For example, in the FooBaz has multiple Bars example
above, a caller could issue a `POST /v2/foo_baz` with a body of `{ "bar_guid": [1,
5, 10]}` to make an initial association of the new FooBaz with Bars with ids 1,
5 and 10 (other attributes omitted).  Similarly, a `PUT` will update the
associations between the resources to only those provided in the list.

Adding and removing elements from a large collection would be onerous if the
entire list had to be provided every time.

A `PUT /v2/foo_baz/1/bars/2` will add bar with id 2 to foobaz with id 1.

A `DELETE /v2/foo_baz/1/bars/2` will remove bar with id 2 to from foobaz with
id 1.

Batching incremental updates may be supported in the future.
To control how the list of ids are added to the collection, supply the
following query parameter `collection-method=add`, `collection-method=replace`, or
`collection-method=delete`.  If the collection-method is not supplied,
it defaults to replace.  NOTE: this is a future design note.
collection-method is not currently supported.


### Inlining Relationships

There are common Cloud Foundry use cases that would require a relatively high
number of API calls if the relation URLs have to be fetched when traversing a
set of resources, e.g. when performing the calls necessary to satisfy a `cf
apps` command line call.  In these cases, the caller intends to walk the entire
tree of relationships.

To inline relationships, the caller may specify a `inline-relations-depth` query
parameter for a `GET` request.  A value of 0 results in the default behaviour of
not inlining any of the relations and only URLs as described above are
returned.  A value of N > 0 results in the direct expansion of relations
inline in the response, but URLs are provided for the next level of relations.

For example, in the request below a FooBar has a to-many relationship to Bars
and Bars has a to-one relationship with a Baz.  Setting the
`inline-relations-depth=1` results in bars being expanded but not baz.

Request: `GET /v2/FooBar/5?inline-relations-depth=1`

Response:

```json
{
  "metadata": {
    "guid": 5,
    "url": "/v2/foo_bars/5",
    "created_at":"2012-01-01 13:42:00 -0700",
    "updated_at":"2012-01-05 08:31:00 -0700"
  },
  "entity": {
    "name": "some foobar",
    "bars": [
      {
        "metadata": {
          "guid": 10,
          "url": "/v2/bar/10",
          "created_at":"2012-01-03 11:22:00 -0700",
          "updated_at":"2012-01-07 09:03:00 -0700"
        },
        "entity": {
          "name": "some bar",
          "baz_guid": 99,
          "baz_url": "/v2/bazs/99"
        }
      },
    ]
  }
}
```

Specifying `inline-releations-depth` > 1 should not result in an circular
expansion of resources.  For example, if there is a bidirectional relationship
between two resources, e.g. an Organization has many Users and a User is a
member of many Organizations, then the response to `GET
/v2/organizations/:id?inline-releations-depth=10`
should not expand the Organizations a User belongs to.  Doing so would result
in an expansion loop.  The User expansion should provide a `organizations_url`
instead.

## <a id='errors'></a> Errors ##

Appropriate HTTP response codes are returned as part of the HTTP response
header, i.e. 400 if the request body can not be parsed, 404 if an operation
is requested on a resource that doesn't exist, etc.

In addition to the HTTP response code, an error response is returned in the
response body.  The error response is JSON-encoded with the following
attributes:

| Attribute    | Description                             |
| ---------    | -----------                             |
| code         | Unique numeric response code            |
| descriptions | Human readable description of the error |

## <a id='actions'></a> Actions ##

Actions are modeled as an update to desired state in the system, i.e.
to start a FooBar resource with id 5 and set the instance count
to 10, the caller would `PUT /v2/foo_bar/5` with a request body of
`{ "state": "STARTED", "instances": 10 }`.

## <a id='organizations'></a> Organizations ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST Organizations

Resource URL: `GET /v2/organizations`

Returns a paginated response of Organizations.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* space_guid
* user_guid
* manager_guid
* billing_manager_guid
* auditor_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing_enabled       | bool                                                         |
| quota_definition_guid | String                                                       |
| quota_definition_url  | String /HTTPS_URL_REGEX/                                     |
| spaces_url            | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| users_url             | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| billing_managers_url  | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |



### CREATE Organization

Resource URL: `POST /v2/organizations`

Creates a Organization.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| name                  | required | String                                             |
| billing_enabled       | optional | bool                                               |
| quota_definition_guid | optional | String                                             |
| domain_guids          | optional | [String]                                           |
| user_guids            | optional | [String]                                           |
| manager_guids         | optional | [String]                                           |
| billing_manager_guids | optional | [String]                                           |
| auditor_guids         | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing_enabled       | bool                                                         |
| quota_definition_guid | String                                                       |
| quota_definition_url  | String /HTTPS_URL_REGEX/                                     |
| spaces_url            | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| users_url             | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| billing_managers_url  | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |




### UPDATE Organization

Resource URL: `PUT /v2/organizations`

Updates a Organization.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| name                  | optional | String                                             |
| billing_enabled       | optional | bool                                               |
| quota_definition_guid | optional | String                                             |
| space_guids           | optional | [String]                                           |
| domain_guids          | optional | [String]                                           |
| user_guids            | optional | [String]                                           |
| manager_guids         | optional | [String]                                           |
| billing_manager_guids | optional | [String]                                           |
| auditor_guids         | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing_enabled       | bool                                                         |
| quota_definition_guid | String                                                       |
| quota_definition_url  | String /HTTPS_URL_REGEX/                                     |
| spaces_url            | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| users_url             | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| billing_managers_url  | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |



### READ Organization

Resource URL: `GET /v2/organizations/:guid`

Reads a Organization.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing_enabled       | bool                                                         |
| quota_definition_guid | String                                                       |
| quota_definition_url  | String /HTTPS_URL_REGEX/                                     |
| spaces_url            | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| users_url             | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| billing_managers_url  | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |




### DELETE Organization

Resource URL: `DELETE /v2/organizations/:guid`

Deletes a Organization.

#### Response Format:

None

## <a id='user'></a> Users ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST Users

Resource URL: `GET /v2/users`

Returns a paginated response of Users.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* space_guid
* organization_guid
* managed_organization_guid
* billing_managed_organization_guid
* audited_organization_guid
* managed_space_guid
* audited_space_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default_space_guid                | String                                                       |
| default_space_url                 | String /HTTPS_URL_REGEX/                                     |
| spaces_url                        | String /HTTPS_URL_REGEX/                                     |
| organizations_url                 | String /HTTPS_URL_REGEX/                                     |
| managed_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| billing_managed_organizations_url | String /HTTPS_URL_REGEX/                                     |
| audited_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| managed_spaces_url                | String /HTTPS_URL_REGEX/                                     |
| audited_spaces_url                | String /HTTPS_URL_REGEX/                                     |



### CREATE User

Resource URL: `POST /v2/users`

Creates a User.

#### Request Format:

| name                               | notes    | schema                                             |
| ---------------------------------- | -------- | -------------------------------------------------- |
| guid                               | required | String                                             |
| admin                              | optional | bool                                               |
| default_space_guid                 | optional | String                                             |
| space_guids                        | optional | [String]                                           |
| organization_guids                 | optional | [String]                                           |
| managed_organization_guids         | optional | [String]                                           |
| billing_managed_organization_guids | optional | [String]                                           |
| audited_organization_guids         | optional | [String]                                           |
| managed_space_guids                | optional | [String]                                           |
| audited_space_guids                | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default_space_guid                | String                                                       |
| default_space_url                 | String /HTTPS_URL_REGEX/                                     |
| spaces_url                        | String /HTTPS_URL_REGEX/                                     |
| organizations_url                 | String /HTTPS_URL_REGEX/                                     |
| managed_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| billing_managed_organizations_url | String /HTTPS_URL_REGEX/                                     |
| audited_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| managed_spaces_url                | String /HTTPS_URL_REGEX/                                     |
| audited_spaces_url                | String /HTTPS_URL_REGEX/                                     |




### UPDATE User

Resource URL: `PUT /v2/users`

Updates a User.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                               | notes    | schema                                             |
| ---------------------------------- | -------- | -------------------------------------------------- |
| guid                               | optional | String                                             |
| admin                              | optional | bool                                               |
| default_space_guid                 | optional | String                                             |
| space_guids                        | optional | [String]                                           |
| organization_guids                 | optional | [String]                                           |
| managed_organization_guids         | optional | [String]                                           |
| billing_managed_organization_guids | optional | [String]                                           |
| audited_organization_guids         | optional | [String]                                           |
| managed_space_guids                | optional | [String]                                           |
| audited_space_guids                | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default_space_guid                | String                                                       |
| default_space_url                 | String /HTTPS_URL_REGEX/                                     |
| spaces_url                        | String /HTTPS_URL_REGEX/                                     |
| organizations_url                 | String /HTTPS_URL_REGEX/                                     |
| managed_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| billing_managed_organizations_url | String /HTTPS_URL_REGEX/                                     |
| audited_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| managed_spaces_url                | String /HTTPS_URL_REGEX/                                     |
| audited_spaces_url                | String /HTTPS_URL_REGEX/                                     |



### READ User

Resource URL: `GET /v2/users/:guid`

Reads a User.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default_space_guid                | String                                                       |
| default_space_url                 | String /HTTPS_URL_REGEX/                                     |
| spaces_url                        | String /HTTPS_URL_REGEX/                                     |
| organizations_url                 | String /HTTPS_URL_REGEX/                                     |
| managed_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| billing_managed_organizations_url | String /HTTPS_URL_REGEX/                                     |
| audited_organizations_url         | String /HTTPS_URL_REGEX/                                     |
| managed_spaces_url                | String /HTTPS_URL_REGEX/                                     |
| audited_spaces_url                | String /HTTPS_URL_REGEX/                                     |




### DELETE User

Resource URL: `DELETE /v2/users/:guid`

Deletes a User.

#### Response Format:

None


## <a id='spaces'></a> Spaces ##


## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST Spaces

Resource URL: `GET /v2/spaces`

Returns a paginated response of Spaces.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* organization_guid
* developer_guid
* app_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization_guid     | String                                                       |
| organization_url      | String /HTTPS_URL_REGEX/                                     |
| developers_url        | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |
| apps_url              | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |



### CREATE Space

Resource URL: `POST /v2/spaces`

Creates a Space.

#### Request Format:

| name                   | notes    | schema                                             |
| ---------------------- | -------- | -------------------------------------------------- |
| name                   | required | String                                             |
| organization_guid      | required | String                                             |
| developer_guids        | optional | [String]                                           |
| manager_guids          | optional | [String]                                           |
| auditor_guids          | optional | [String]                                           |
| app_guids              | optional | [String]                                           |
| domain_guids           | optional | [String]                                           |
| service_instance_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization_guid     | String                                                       |
| organization_url      | String /HTTPS_URL_REGEX/                                     |
| developers_url        | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |
| apps_url              | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |




### UPDATE Space

Resource URL: `PUT /v2/spaces`

Updates a Space.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                   | notes    | schema                                             |
| ---------------------- | -------- | -------------------------------------------------- |
| name                   | optional | String                                             |
| organization_guid      | optional | String                                             |
| developer_guids        | optional | [String]                                           |
| manager_guids          | optional | [String]                                           |
| auditor_guids          | optional | [String]                                           |
| app_guids              | optional | [String]                                           |
| domain_guids           | optional | [String]                                           |
| service_instance_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization_guid     | String                                                       |
| organization_url      | String /HTTPS_URL_REGEX/                                     |
| developers_url        | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |
| apps_url              | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |



### READ Space

Resource URL: `GET /v2/spaces/:guid`

Reads a Space.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization_guid     | String                                                       |
| organization_url      | String /HTTPS_URL_REGEX/                                     |
| developers_url        | String /HTTPS_URL_REGEX/                                     |
| managers_url          | String /HTTPS_URL_REGEX/                                     |
| auditors_url          | String /HTTPS_URL_REGEX/                                     |
| apps_url              | String /HTTPS_URL_REGEX/                                     |
| domains_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |




### DELETE Space

Resource URL: `DELETE /v2/spaces/:guid`

Deletes a Space.

#### Response Format:

None

## <a id='apps'></a> Apps ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST Apps

Resource URL: `GET /v2/apps`

Returns a paginated response of Apps.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* space_guid
* organization_guid
* framework_guid
* runtime_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file_descriptors     | Integer                                                      |
| disk_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| runtime_guid         | String                                                       |
| runtime_url          | String /HTTPS_URL_REGEX/                                     |
| framework_guid       | String                                                       |
| framework_url        | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |
| routes_url           | String /HTTPS_URL_REGEX/                                     |



### CREATE App

Resource URL: `POST /v2/apps`

Creates a App.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | required | String                                             |
| production           | optional | bool                                               |
| environment_json     | optional | Hash                                               |
| memory               | optional | Integer                                            |
| instances            | optional | Integer                                            |
| file_descriptors     | optional | Integer                                            |
| disk_quota           | optional | Integer                                            |
| state                | optional | String                                             |
| command              | optional | String                                             |
| console              | optional | bool                                               |
| space_guid           | required | String                                             |
| runtime_guid         | required | String                                             |
| framework_guid       | required | String                                             |
| route_guids          | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file_descriptors     | Integer                                                      |
| disk_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| runtime_guid         | String                                                       |
| runtime_url          | String /HTTPS_URL_REGEX/                                     |
| framework_guid       | String                                                       |
| framework_url        | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |
| routes_url           | String /HTTPS_URL_REGEX/                                     |




### UPDATE App

Resource URL: `PUT /v2/apps`

Updates a App.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| name                  | optional | String                                             |
| production            | optional | bool                                               |
| environment_json      | optional | Hash                                               |
| memory                | optional | Integer                                            |
| instances             | optional | Integer                                            |
| file_descriptors      | optional | Integer                                            |
| disk_quota            | optional | Integer                                            |
| state                 | optional | String                                             |
| command               | optional | String                                             |
| console               | optional | bool                                               |
| space_guid            | optional | String                                             |
| runtime_guid          | optional | String                                             |
| framework_guid        | optional | String                                             |
| service_binding_guids | optional | [String]                                           |
| route_guids           | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file_descriptors     | Integer                                                      |
| disk_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| runtime_guid         | String                                                       |
| runtime_url          | String /HTTPS_URL_REGEX/                                     |
| framework_guid       | String                                                       |
| framework_url        | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |
| routes_url           | String /HTTPS_URL_REGEX/                                     |



### READ App

Resource URL: `GET /v2/apps/:guid`

Reads a App.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file_descriptors     | Integer                                                      |
| disk_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| runtime_guid         | String                                                       |
| runtime_url          | String /HTTPS_URL_REGEX/                                     |
| framework_guid       | String                                                       |
| framework_url        | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |
| routes_url           | String /HTTPS_URL_REGEX/                                     |




### DELETE App

Resource URL: `DELETE /v2/apps/:guid`

Deletes a App.

#### Response Format:

None


## <a id='runtimes'></a> Runtimes ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST Runtimes

Resource URL: `GET /v2/runtimes`

Returns a paginated response of Runtimes.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* app_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |



### CREATE Runtime

Resource URL: `POST /v2/runtimes`

Creates a Runtime.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | required | String                                             |
| description          | required | String                                             |
| app_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |




### UPDATE Runtime

Resource URL: `PUT /v2/runtimes`

Updates a Runtime.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | optional | String                                             |
| description          | optional | String                                             |
| app_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |



### READ Runtime

Resource URL: `GET /v2/runtimes/:guid`

Reads a Runtime.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |




### DELETE Runtime

Resource URL: `DELETE /v2/runtimes/:guid`

Deletes a Runtime.

#### Response Format:

None


## <a id='frameworks'></a> Frameworks ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST Frameworks

Resource URL: `GET /v2/frameworks`

Returns a paginated response of Frameworks.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* app_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |



### CREATE Framework

Resource URL: `POST /v2/frameworks`

Creates a Framework.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | required | String                                             |
| description          | required | String                                             |
| app_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |




### UPDATE Framework

Resource URL: `PUT /v2/frameworks`

Updates a Framework.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | optional | String                                             |
| description          | optional | String                                             |
| app_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |



### READ Framework

Resource URL: `GET /v2/frameworks/:guid`

Reads a Framework.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps_url             | String /HTTPS_URL_REGEX/                                     |




### DELETE Framework

Resource URL: `DELETE /v2/frameworks/:guid`

Deletes a Framework.

#### Response Format:

None

## <a id='services'></a> Services ##


## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST Services

Resource URL: `GET /v2/services`

Returns a paginated response of Services.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* service_plan_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info_url             | String /URL_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service_plans_url    | String /HTTPS_URL_REGEX/                                     |



### CREATE Service

Resource URL: `POST /v2/services`

Creates a Service.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| label                | required | String                                             |
| provider             | required | String                                             |
| url                  | required | String /URL_REGEX/                                 |
| description          | required | String                                             |
| version              | required | String                                             |
| info_url             | optional | String /URL_REGEX/                                 |
| acls                 | optional | {"users" => [String],"wildcards" => [String],}     |
| timeout              | optional | Integer                                            |
| active               | optional | bool                                               |
| service_plan_guids   | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info_url             | String /URL_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service_plans_url    | String /HTTPS_URL_REGEX/                                     |




### UPDATE Service

Resource URL: `PUT /v2/services`

Updates a Service.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| label                | optional | String                                             |
| provider             | optional | String                                             |
| url                  | optional | String /URL_REGEX/                                 |
| description          | optional | String                                             |
| version              | optional | String                                             |
| info_url             | optional | String /URL_REGEX/                                 |
| acls                 | optional | {"users" => [String],"wildcards" => [String],}     |
| timeout              | optional | Integer                                            |
| active               | optional | bool                                               |
| service_plan_guids   | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info_url             | String /URL_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service_plans_url    | String /HTTPS_URL_REGEX/                                     |



### READ Service

Resource URL: `GET /v2/services/:guid`

Reads a Service.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info_url             | String /URL_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service_plans_url    | String /HTTPS_URL_REGEX/                                     |




### DELETE Service

Resource URL: `DELETE /v2/services/:guid`

Deletes a Service.

#### Response Format:

None


## <a id='serviceplans'></a> Service Plans ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST ServicePlans

Resource URL: `GET /v2/service_plans`

Returns a paginated response of ServicePlans.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* service_guid
* service_instance_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service_guid          | String                                                       |
| service_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |



### CREATE ServicePlan

Resource URL: `POST /v2/service_plans`

Creates a ServicePlan.

#### Request Format:

| name                   | notes    | schema                                             |
| ---------------------- | -------- | -------------------------------------------------- |
| name                   | required | String                                             |
| free                   | required | bool                                               |
| description            | required | String                                             |
| service_guid           | required | String                                             |
| service_instance_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service_guid          | String                                                       |
| service_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |




### UPDATE ServicePlan

Resource URL: `PUT /v2/service_plans`

Updates a ServicePlan.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                   | notes    | schema                                             |
| ---------------------- | -------- | -------------------------------------------------- |
| name                   | optional | String                                             |
| free                   | optional | bool                                               |
| description            | optional | String                                             |
| service_guid           | optional | String                                             |
| service_instance_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service_guid          | String                                                       |
| service_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |



### READ ServicePlan

Resource URL: `GET /v2/service_plans/:guid`

Reads a ServicePlan.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service_guid          | String                                                       |
| service_url           | String /HTTPS_URL_REGEX/                                     |
| service_instances_url | String /HTTPS_URL_REGEX/                                     |




### DELETE ServicePlan

Resource URL: `DELETE /v2/service_plans/:guid`

Deletes a ServicePlan.

#### Response Format:

None

## <a id='service-instances'></a> Service Instances ##


## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST ServiceInstances

Resource URL: `GET /v2/service_instances`

Returns a paginated response of ServiceInstances.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* space_guid
* service_plan_guid
* service_binding_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| service_plan_guid    | String                                                       |
| service_plan_url     | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |



### CREATE ServiceInstance

Resource URL: `POST /v2/service_instances`

Creates a ServiceInstance.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| name                  | required | String                                             |
| space_guid            | required | String                                             |
| service_plan_guid     | required | String                                             |
| service_binding_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| service_plan_guid    | String                                                       |
| service_plan_url     | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |




### UPDATE ServiceInstance

Resource URL: `PUT /v2/service_instances`

Updates a ServiceInstance.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| name                  | optional | String                                             |
| space_guid            | optional | String                                             |
| service_plan_guid     | optional | String                                             |
| service_binding_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| service_plan_guid    | String                                                       |
| service_plan_url     | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |



### READ ServiceInstance

Resource URL: `GET /v2/service_instances/:guid`

Reads a ServiceInstance.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space_guid           | String                                                       |
| space_url            | String /HTTPS_URL_REGEX/                                     |
| service_plan_guid    | String                                                       |
| service_plan_url     | String /HTTPS_URL_REGEX/                                     |
| service_bindings_url | String /HTTPS_URL_REGEX/                                     |




### DELETE ServiceInstance

Resource URL: `DELETE /v2/service_instances/:guid`

Deletes a ServiceInstance.

#### Response Format:

None

## <a id='service-bindings'></a> Service Bindings ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST ServiceBindings

Resource URL: `GET /v2/service_bindings`

Returns a paginated response of ServiceBindings.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* app_guid
* service_instance_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app_guid              | String                                                       |
| app_url               | String /HTTPS_URL_REGEX/                                     |
| service_instance_guid | String                                                       |
| service_instance_url  | String /HTTPS_URL_REGEX/                                     |



### CREATE ServiceBinding

Resource URL: `POST /v2/service_bindings`

Creates a ServiceBinding.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| app_guid              | required | String                                             |
| service_instance_guid | required | String                                             |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app_guid              | String                                                       |
| app_url               | String /HTTPS_URL_REGEX/                                     |
| service_instance_guid | String                                                       |
| service_instance_url  | String /HTTPS_URL_REGEX/                                     |




### UPDATE ServiceBinding

Resource URL: `PUT /v2/service_bindings`

Updates a ServiceBinding.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| app_guid              | optional | String                                             |
| service_instance_guid | optional | String                                             |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app_guid              | String                                                       |
| app_url               | String /HTTPS_URL_REGEX/                                     |
| service_instance_guid | String                                                       |
| service_instance_url  | String /HTTPS_URL_REGEX/                                     |



### READ ServiceBinding

Resource URL: `GET /v2/service_bindings/:guid`

Reads a ServiceBinding.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app_guid              | String                                                       |
| app_url               | String /HTTPS_URL_REGEX/                                     |
| service_instance_guid | String                                                       |
| service_instance_url  | String /HTTPS_URL_REGEX/                                     |




### DELETE ServiceBinding

Resource URL: `DELETE /v2/service_bindings/:guid`

Deletes a ServiceBinding.

#### Response Format:

None

## <a id='service-auth-tokens'></a> Service Auth Tokens ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST ServiceAuthTokens

Resource URL: `GET /v2/service_auth_tokens`

Returns a paginated response of ServiceAuthTokens.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributues |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
*

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev_url             | String /HTTPS_URL_REGEX/                                     |
| next_url             | String /HTTPS_URL_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceAuthToken is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |



### CREATE ServiceAuthToken

Resource URL: `POST /v2/service_auth_tokens`

Creates a ServiceAuthToken.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| label                | required | String                                             |
| provider             | required | String                                             |
| token                | required | String                                             |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceAuthToken is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |




### UPDATE ServiceAuthToken

Resource URL: `PUT /v2/service_auth_tokens`

Updates a ServiceAuthToken.

#### Query Parameters

| Parameter         | Description |
| ---------         | ----------- |
| collection-method | See below.  |

`collection-method` may take on the following values:
* `add` = merge any supplied ids with the relations that already exist.
* `replace` = any supplied ids replace their corresponding relations.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| label                | optional | String                                             |
| provider             | optional | String                                             |
| token                | optional | String                                             |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceAuthToken is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |



### READ ServiceAuthToken

Resource URL: `GET /v2/service_auth_tokens/:guid`

Reads a ServiceAuthToken.

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS_URL_REGEX/                                     |
| created_at           | Date                                                         |
| updated_at           | Date                                                         |

The schema for the `:entity` hash for ServiceAuthToken is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |




### DELETE ServiceAuthToken

Resource URL: `DELETE /v2/service_auth_tokens/:guid`

Deletes a ServiceAuthToken.

#### Response Format:

None
