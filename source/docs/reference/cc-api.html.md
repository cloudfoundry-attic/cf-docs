---
title: Cloud Foundry API
---

_This documents the v2 version of the API._

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
| created\_at | Date/Timestamp the resource was created, e.g. "2012-01-01 13:42:00 -0700"           |
| updated\_at | Date/Timestamp the resource was updated.  null if the resource has not been updated |


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
| total\_results | Total number of results in the entire data set.                                                   |
| total\_pages   | Total number of pages in the entire dataset.                                                      |
| prev\_url      | URL used to fetch the previous set of results in the paginated response.  null on the first call. |
| next\_url      | URL used to fetch the next set of results in the paginated response.  null on the last call.     |
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

Searching and Filtering are performed via the `q` query parameter.
The value of the `q` parameter is a key value pair containing the resource
attribute name and the query value, e.g: `GET /v2/foo_bars?q=name:some*` would
return both records shown in the pagination example above.

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

`PUT` differs from standard convention.
In order to avoid a read-modify-write cycle when updating a single attribute,
`PUT` is handled as if the `PATCH` verb were used.
Specifically, if a resource with URL `/v2/foo_bars/99` has attributes

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
concurrency.  This is not required.
If there is an opportunistic concurrency failure, the API endpoint should return HTTP 412.

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

N-to-Many relationships are indicated by a url attribute for the other
collection of resources.
For example, if a FooBaz has multiple Bars, a `GET /v2/FooBaz/:id` will return
the following attribute (other attributes omitted)

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
an array of ids.
For example, in the FooBaz has multiple Bars example above, a caller could
issue a `POST /v2/foo_baz` with a body of `{ "bar_guid": [1, 5, 10]}` to make
an initial association of the new FooBaz with Bars with ids 1, 5, and 10
(other attributes omitted).
Similarly, a `PUT` will update the associations between the resources to only
those provided in the list.

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
parameter for a `GET` request.  A value of 0 results in the default behavior of
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

Specifying `inline-relations-depth` > 1 should not result in an circular
expansion of resources.  For example, if there is a bidirectional relationship
between two resources, e.g. an Organization has many Users and a User is a
member of many Organizations, then the response to `GET
/v2/organizations/:id?inline-relations-depth=10`
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
* space\_guid
* user\_guid
* manager\_guid
* billing\_manager\_guid
* auditor\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing\_enabled       | bool                                                         |
| quota\_definition\_guid | String                                                       |
| quota\_definition\_url  | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url            | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| users\_url             | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managers\_url  | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |



### CREATE Organization

Resource URL: `POST /v2/organizations`

Creates a Organization.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| name                  | required | String                                             |
| billing\_enabled       | optional | bool                                               |
| quota\_definition\_guid | optional | String                                             |
| domain\_guids          | optional | [String]                                           |
| user\_guids            | optional | [String]                                           |
| manager\_guids         | optional | [String]                                           |
| billing\_manager\_guids | optional | [String]                                           |
| auditor\_guids         | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing\_enabled       | bool                                                         |
| quota\_definition\_guid | String                                                       |
| quota\_definition\_url  | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url            | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| users\_url             | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managers\_url  | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |




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
| billing\_enabled       | optional | bool                                               |
| quota\_definition\_guid | optional | String                                             |
| space\_guids           | optional | [String]                                           |
| domain\_guids          | optional | [String]                                           |
| user\_guids            | optional | [String]                                           |
| manager\_guids         | optional | [String]                                           |
| billing\_manager\_guids | optional | [String]                                           |
| auditor\_guids         | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing\_enabled       | bool                                                         |
| quota\_definition\_guid | String                                                       |
| quota\_definition\_url  | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url            | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| users\_url             | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managers\_url  | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Organization is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| billing\_enabled       | bool                                                         |
| quota\_definition\_guid | String                                                       |
| quota\_definition\_url  | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url            | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| users\_url             | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managers\_url  | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |




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
* space\_guid
* organization\_guid
* managed\_organization\_guid
* billing\_managed\_organization\_guid
* audited\_organization\_guid
* managed\_space\_guid
* audited\_space\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default\_space\_guid                | String                                                       |
| default\_space\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url                        | String /HTTPS\_URL\_REGEX/                                     |
| organizations\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| managed\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managed\_organizations\_url | String /HTTPS\_URL\_REGEX/                                     |
| audited\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| managed\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |
| audited\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |



### CREATE User

Resource URL: `POST /v2/users`

Creates a User.

#### Request Format:

| name                               | notes    | schema                                             |
| ---------------------------------- | -------- | -------------------------------------------------- |
| guid                               | required | String                                             |
| admin                              | optional | bool                                               |
| default\_space\_guid                 | optional | String                                             |
| space\_guids                        | optional | [String]                                           |
| organization\_guids                 | optional | [String]                                           |
| managed\_organization\_guids         | optional | [String]                                           |
| billing\_managed\_organization\_guids | optional | [String]                                           |
| audited\_organization\_guids         | optional | [String]                                           |
| managed\_space\_guids                | optional | [String]                                           |
| audited\_space\_guids                | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default\_space\_guid                | String                                                       |
| default\_space\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url                        | String /HTTPS\_URL\_REGEX/                                     |
| organizations\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| managed\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managed\_organizations\_url | String /HTTPS\_URL\_REGEX/                                     |
| audited\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| managed\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |
| audited\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |




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
| default\_space\_guid                 | optional | String                                             |
| space\_guids                        | optional | [String]                                           |
| organization\_guids                 | optional | [String]                                           |
| managed\_organization\_guids         | optional | [String]                                           |
| billing\_managed\_organization\_guids | optional | [String]                                           |
| audited\_organization\_guids         | optional | [String]                                           |
| managed\_space\_guids                | optional | [String]                                           |
| audited\_space\_guids                | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default\_space\_guid                | String                                                       |
| default\_space\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url                        | String /HTTPS\_URL\_REGEX/                                     |
| organizations\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| managed\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managed\_organizations\_url | String /HTTPS\_URL\_REGEX/                                     |
| audited\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| managed\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |
| audited\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for User is:

| name                              | schema                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| guid                              | String                                                       |
| admin                             | bool                                                         |
| default\_space\_guid                | String                                                       |
| default\_space\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| spaces\_url                        | String /HTTPS\_URL\_REGEX/                                     |
| organizations\_url                 | String /HTTPS\_URL\_REGEX/                                     |
| managed\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| billing\_managed\_organizations\_url | String /HTTPS\_URL\_REGEX/                                     |
| audited\_organizations\_url         | String /HTTPS\_URL\_REGEX/                                     |
| managed\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |
| audited\_spaces\_url                | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* organization\_guid
* developer\_guid
* app\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization\_guid     | String                                                       |
| organization\_url      | String /HTTPS\_URL\_REGEX/                                     |
| developers\_url        | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |
| apps\_url              | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |



### CREATE Space

Resource URL: `POST /v2/spaces`

Creates a Space.

#### Request Format:

| name                   | notes    | schema                                             |
| ---------------------- | -------- | -------------------------------------------------- |
| name                   | required | String                                             |
| organization\_guid      | required | String                                             |
| developer\_guids        | optional | [String]                                           |
| manager\_guids          | optional | [String]                                           |
| auditor\_guids          | optional | [String]                                           |
| app\_guids              | optional | [String]                                           |
| domain\_guids           | optional | [String]                                           |
| service\_instance\_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization\_guid     | String                                                       |
| organization\_url      | String /HTTPS\_URL\_REGEX/                                     |
| developers\_url        | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |
| apps\_url              | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |




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
| organization\_guid      | optional | String                                             |
| developer\_guids        | optional | [String]                                           |
| manager\_guids          | optional | [String]                                           |
| auditor\_guids          | optional | [String]                                           |
| app\_guids              | optional | [String]                                           |
| domain\_guids           | optional | [String]                                           |
| service\_instance\_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization\_guid     | String                                                       |
| organization\_url      | String /HTTPS\_URL\_REGEX/                                     |
| developers\_url        | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |
| apps\_url              | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Space is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| organization\_guid     | String                                                       |
| organization\_url      | String /HTTPS\_URL\_REGEX/                                     |
| developers\_url        | String /HTTPS\_URL\_REGEX/                                     |
| managers\_url          | String /HTTPS\_URL\_REGEX/                                     |
| auditors\_url          | String /HTTPS\_URL\_REGEX/                                     |
| apps\_url              | String /HTTPS\_URL\_REGEX/                                     |
| domains\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* space\_guid
* organization\_guid
* framework\_guid
* runtime\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment\_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file\_descriptors     | Integer                                                      |
| disk\_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| runtime\_guid         | String                                                       |
| runtime\_url          | String /HTTPS\_URL\_REGEX/                                     |
| framework\_guid       | String                                                       |
| framework\_url        | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |
| routes\_url           | String /HTTPS\_URL\_REGEX/                                     |



### CREATE App

Resource URL: `POST /v2/apps`

Creates a App.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | required | String                                             |
| production           | optional | bool                                               |
| environment\_json     | optional | Hash                                               |
| memory               | optional | Integer                                            |
| instances            | optional | Integer                                            |
| file\_descriptors     | optional | Integer                                            |
| disk\_quota           | optional | Integer                                            |
| state                | optional | String                                             |
| command              | optional | String                                             |
| console              | optional | bool                                               |
| space\_guid           | required | String                                             |
| runtime\_guid         | required | String                                             |
| framework\_guid       | required | String                                             |
| route\_guids          | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment\_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file\_descriptors     | Integer                                                      |
| disk\_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| runtime\_guid         | String                                                       |
| runtime\_url          | String /HTTPS\_URL\_REGEX/                                     |
| framework\_guid       | String                                                       |
| framework\_url        | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |
| routes\_url           | String /HTTPS\_URL\_REGEX/                                     |




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
| environment\_json      | optional | Hash                                               |
| memory                | optional | Integer                                            |
| instances             | optional | Integer                                            |
| file\_descriptors      | optional | Integer                                            |
| disk\_quota            | optional | Integer                                            |
| state                 | optional | String                                             |
| command               | optional | String                                             |
| console               | optional | bool                                               |
| space\_guid            | optional | String                                             |
| runtime\_guid          | optional | String                                             |
| framework\_guid        | optional | String                                             |
| service\_binding\_guids | optional | [String]                                           |
| route\_guids           | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment\_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file\_descriptors     | Integer                                                      |
| disk\_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| runtime\_guid         | String                                                       |
| runtime\_url          | String /HTTPS\_URL\_REGEX/                                     |
| framework\_guid       | String                                                       |
| framework\_url        | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |
| routes\_url           | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for App is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| production           | bool                                                         |
| environment\_json     | Hash                                                         |
| memory               | Integer                                                      |
| instances            | Integer                                                      |
| file\_descriptors     | Integer                                                      |
| disk\_quota           | Integer                                                      |
| state                | String                                                       |
| command              | String                                                       |
| console              | bool                                                         |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| runtime\_guid         | String                                                       |
| runtime\_url          | String /HTTPS\_URL\_REGEX/                                     |
| framework\_guid       | String                                                       |
| framework\_url        | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |
| routes\_url           | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* app\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |



### CREATE Runtime

Resource URL: `POST /v2/runtimes`

Creates a Runtime.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | required | String                                             |
| description          | required | String                                             |
| app\_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |




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
| app\_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Runtime is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| version              | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* app\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |



### CREATE Framework

Resource URL: `POST /v2/frameworks`

Creates a Framework.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| name                 | required | String                                             |
| description          | required | String                                             |
| app\_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |




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
| app\_guids            | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Framework is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| description          | String                                                       |
| apps\_url             | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* service\_plan\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL\_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info\_url             | String /URL\_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service\_plans\_url    | String /HTTPS\_URL\_REGEX/                                     |



### CREATE Service

Resource URL: `POST /v2/services`

Creates a Service.

#### Request Format:

| name                 | notes    | schema                                             |
| -------------------- | -------- | -------------------------------------------------- |
| label                | required | String                                             |
| provider             | required | String                                             |
| url                  | required | String /URL\_REGEX/                                 |
| description          | required | String                                             |
| version              | required | String                                             |
| info\_url             | optional | String /URL\_REGEX/                                 |
| acls                 | optional | {"users" => [String],"wildcards" => [String],}     |
| timeout              | optional | Integer                                            |
| active               | optional | bool                                               |
| service\_plan\_guids   | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL\_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info\_url             | String /URL\_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service\_plans\_url    | String /HTTPS\_URL\_REGEX/                                     |




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
| url                  | optional | String /URL\_REGEX/                                 |
| description          | optional | String                                             |
| version              | optional | String                                             |
| info\_url             | optional | String /URL\_REGEX/                                 |
| acls                 | optional | {"users" => [String],"wildcards" => [String],}     |
| timeout              | optional | Integer                                            |
| active               | optional | bool                                               |
| service\_plan\_guids   | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL\_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info\_url             | String /URL\_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service\_plans\_url    | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for Service is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| label                | String                                                       |
| provider             | String                                                       |
| url                  | String /URL\_REGEX/                                           |
| description          | String                                                       |
| version              | String                                                       |
| info\_url             | String /URL\_REGEX/                                           |
| acls                 | {"users" => [String],"wildcards" => [String],}               |
| timeout              | Integer                                                      |
| active               | bool                                                         |
| service\_plans\_url    | String /HTTPS\_URL\_REGEX/                                     |




### DELETE Service

Resource URL: `DELETE /v2/services/:guid`

Deletes a Service.

#### Response Format:

None


## <a id='serviceplans'></a> Service Plans ##

## CC Specific API

NOTE: Like the migrations and the models this is being fleshed out and should be reviewed for hierarchy and relationships only.

### LIST ServicePlans

Resource URL: `GET /v2/service\_plans`

Returns a paginated response of ServicePlans.

#### Query Parameters

| Parameter              | Description                                                                      |
| ---------              | -----------                                                                      |
| limit                  | Maximum number of results to return.                                             |
| offset                 | Offset from which to start iteration.                                            |
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* service\_guid
* service\_instance\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service\_guid          | String                                                       |
| service\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |



### CREATE ServicePlan

Resource URL: `POST /v2/service_plans`

Creates a ServicePlan.

#### Request Format:

| name                   | notes    | schema                                             |
| ---------------------- | -------- | -------------------------------------------------- |
| name                   | required | String                                             |
| free                   | required | bool                                               |
| description            | required | String                                             |
| service\_guid           | required | String                                             |
| service\_instance\_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service\_guid          | String                                                       |
| service\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |




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
| service\_guid           | optional | String                                             |
| service\_instance\_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service\_guid          | String                                                       |
| service\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServicePlan is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| name                  | String                                                       |
| free                  | bool                                                         |
| description           | String                                                       |
| service\_guid          | String                                                       |
| service\_url           | String /HTTPS\_URL\_REGEX/                                     |
| service\_instances\_url | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* name
* space\_guid
* service\_plan\_guid
* service\_binding\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| service\_plan\_guid    | String                                                       |
| service\_plan\_url     | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |



### CREATE ServiceInstance

Resource URL: `POST /v2/service_instances`

Creates a ServiceInstance.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| name                  | required | String                                             |
| space\_guid            | required | String                                             |
| service\_plan\_guid     | required | String                                             |
| service\_binding\_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| service\_plan\_guid    | String                                                       |
| service\_plan\_url     | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |




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
| space\_guid            | optional | String                                             |
| service\_plan\_guid     | optional | String                                             |
| service\_binding\_guids | optional | [String]                                           |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| service\_plan\_guid    | String                                                       |
| service\_plan\_url     | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceInstance is:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| name                 | String                                                       |
| space\_guid           | String                                                       |
| space\_url            | String /HTTPS\_URL\_REGEX/                                     |
| service\_plan\_guid    | String                                                       |
| service\_plan\_url     | String /HTTPS\_URL\_REGEX/                                     |
| service\_bindings\_url | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
* app\_guid
* service\_instance\_guid

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app\_guid              | String                                                       |
| app\_url               | String /HTTPS\_URL\_REGEX/                                     |
| service\_instance\_guid | String                                                       |
| service\_instance\_url  | String /HTTPS\_URL\_REGEX/                                     |



### CREATE ServiceBinding

Resource URL: `POST /v2/service_bindings`

Creates a ServiceBinding.

#### Request Format:

| name                  | notes    | schema                                             |
| --------------------- | -------- | -------------------------------------------------- |
| app\_guid              | required | String                                             |
| service\_instance\_guid | required | String                                             |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app\_guid              | String                                                       |
| app\_url               | String /HTTPS\_URL\_REGEX/                                     |
| service\_instance\_guid | String                                                       |
| service\_instance\_url  | String /HTTPS\_URL\_REGEX/                                     |




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
| app\_guid              | optional | String                                             |
| service\_instance\_guid | optional | String                                             |

#### Response Format:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| metadata             | Hash                                                         |
| entity               | Hash                                                         |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app\_guid              | String                                                       |
| app\_url               | String /HTTPS\_URL\_REGEX/                                     |
| service\_instance\_guid | String                                                       |
| service\_instance\_url  | String /HTTPS\_URL\_REGEX/                                     |



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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

The schema for the `:entity` hash for ServiceBinding is:

| name                  | schema                                                       |
| --------------------- | ------------------------------------------------------------ |
| app\_guid              | String                                                       |
| app\_url               | String /HTTPS\_URL\_REGEX/                                     |
| service\_instance\_guid | String                                                       |
| service\_instance\_url  | String /HTTPS\_URL\_REGEX/                                     |




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
| urls-only              | If 1, only return a list of urls; do not expand metadata or resource attributes |
| inline-relations-depth | 0 - don't inline any relations and return URLs.  Otherwise, inline to depth N.   |
| q                      | Search/filter string of the form `<attribute-name>:<value>` |

The `q` query parameter may include the following `attribute-names`:
*

See the API Overview for a more detailed description of these parameters.

#### Response Format:

The response is in the standard v2 paginated response format, i.e.:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| total\_results        | Integer                                                      |
| prev\_url             | String /HTTPS\_URL\_REGEX/                                     |
| next\_url             | String /HTTPS\_URL\_REGEX/                                     |
| resources            | [{:metadata => Hash,:entity => Hash,}]                       |

The schema for `:metadata` follows the v2 standard:

| name                 | schema                                                       |
| -------------------- | ------------------------------------------------------------ |
| guid                 | String                                                       |
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

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
| url                  | String /HTTPS\_URL\_REGEX/                                     |
| created\_at           | Date                                                         |
| updated\_at           | Date                                                         |

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
