# To version 1.9.1

The Helm chart itself has no breaking changes. Yet the update includes a new major app version rising from 3.3 to 5.0. Check the release notes for details.

One breaking change includes the default setting change of "--enabled-default-deny-strict=true". This denies even valid tokens, when the resource is not specified. So check the resources in your configuration and ensure, that every needed URL is specified.
