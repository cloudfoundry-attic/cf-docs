---
title: v2 API Change Log
---

## 2014-01-27 ##
Removed example request bodies for Unbind and Delete, as DELETE requests do not include a body. Clarified that documented request fields are query parameters, not body fields. Updated example cUrl to remove body and add query parameters.

## 2013-12-27 ##
Added field, bumped version to 2.1, included in cf-release final build 152.

## 2013-12-12 ##
Renamed 'writing-service' document to 'api'. Updated [the api document](api.html) to reflect the v2.1 api.  Moved [the v2.0 doc](api-v2.0.html) to a separate page for archival purposes.

## 2013-12-11 ##
Bug found in [the v2.0 doc](api-v2.0.html). It was indicated that the credentials field returned by the broker after binding a service to an app is required, but it is actually optional.

## 2013-12-09 ##
Bug found in [the v2.0 doc](api-v2.0.html). We discovered another place in the docs that indicated that a 404 returned for a unbind or delete would be interpreted by cloud controller as a success. This was incorrect. Cloud controller accepts 200 and 410 as successes and 404 as a failure. We have updated the documentation again and the API version remains at 2.0.

## 2013-11-26 ##
Bug found in [the v2.0 doc](api-v2.0.html). It was indicated that a 404 returned for a unbind or delete would be interpreted by cloud controller as a success. This was incorrect. Cloud controller accepts 200 and 410 as successes and 404 as a failure. Doc has been updated and API version remains at 2.0.

