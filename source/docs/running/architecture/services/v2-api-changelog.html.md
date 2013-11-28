---
title: v2 API Change Log
---

## 2013-11-26 ##
Bug found in [the v2.0 doc](writing-service.html). It was indicated that a 404 returned for a unbind or delete would be interpreted by cloud controller as a success. This was incorrect. Cloud controller accepts 200 and 410 as successes and 404 as a failure. Doc has been updated and API version remains at 2.0. 
