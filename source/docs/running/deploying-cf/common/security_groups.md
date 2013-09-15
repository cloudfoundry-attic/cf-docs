---
title: Security Groups for Cloud Foundry and BOSH
---

AWS and OpenStack offer Security Groups as a mechanism to restrict inbound traffic to servers.

The Security Groups referenced in other sections of the documentation are described below. Please create all of them with the name given as the header.

NOTE: in the OpenStack examples below, port UDP 68 was automatically added to all security groups.

NOTE: In OpenStack Grizzly, there is now a setting for both INGRESS and EGRESS control.  These settings target INGRESS configuration.

## <a id="security-group-bosh"></a> "ssh"

All servers deployed by bosh, including bosh itself, need to expose TCP port 22 for ssh and IMCP -1 to allow ping.

![ssh ports](https://www.evernote.com/shard/s3/sh/8200eb5c-4d36-40f9-b9c4-c9ad76e3a12c/35022d3f4a233c2322c0a8604662248c/deep/0/Access%20&%20Security%20-%20OpenStack%20Dashboard.png)

## <a id="security-group-bosh"></a> "bosh"

![bosh ports](https://www.evernote.com/shard/s3/sh/955f3ea6-963f-4b34-af3d-1ccfbb43dec0/3fa0e2ffe9e04b75151d201afe2c4fe1/deep/0/Access%20&%20Security%20-%20OpenStack%20Dashboard.png)

## <a id="security-group-bosh"></a> "cf-public"

![cf-public](https://www.evernote.com/shard/s3/sh/3d9778a4-2c4f-4f12-8f3f-fbb8c6f29882/b43f3c6973d2948cb6f7b56f518e748f/deep/0/Access%20&%20Security%20-%20OpenStack%20Dashboard.png)

## <a id="security-group-bosh"></a> "cf-private"

![cf-private](https://www.evernote.com/shard/s3/sh/c6c8718f-e910-4bce-994e-a07b8ba6ad0e/b62905e5d9764e1ecb80066a94069813/deep/0/Access%20&%20Security%20-%20OpenStack%20Dashboard.png)
