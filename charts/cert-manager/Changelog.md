# Changelog

## Chart Versions

### 1.16.1

- Updated Chart & App Version to 1.16.1
- As indicated per [documentation](https://cert-manager.io/docs/releases/release-notes/release-notes-1.16/#helm) the base chart now includes a Helm schema, so unrecognised fields will make the templating fail.

### 1.1.0

#### 💥 Breaking changes 💥

- New flag `clusterIssuer.useStaging` (default `true`)
  - Reason: Prevent hitting the ratelimit on letsencrypt prod environment.
  - Action: Set to `false` after verifying the content of the test-certificate.
- Moved field `clusterIssuer.http.email` to `clusterIssuer.email`
  - Reason: Added a new clusterIssuer for DNS01 challenges, prevent field duplication.
  - Action: Move existing config to `clusterIssuer.email`
- Moved field: `clusterIssuer.http.name` to `clusterIssuer.http01.name`
  - Reason: Adding a new clusterIssuer for DNS01 challenges
  - Action: If overriden, move existing config to `clusterIssuer.http01.name`
- Moved field `ingressClass` to `clusterIssuer.http01.ingressClass`
  - Reason: As this only applies to the http-issuer, it is moved to better reflect it's context
  - Action: If overriden, move existing config to `clusterIssuer.http01.ingressClass`

#### 🎉 New functionality 🎉

- ClusterIssuer for DNS01 Challenges on OTC
  - Set `clusterIssuer.dns01.enabled` to `true` to enable
  - ⚠️ Only configured for OTC
  - ⚠️ Requires the chart [cert-manager-webhook-opentelekomcloud](https://github.com/akyriako/cert-manager-webhook-opentelekomcloud)
    - Use the projectfactory-terraform module `cert-manager` for autoconfiguration

#### Other changes

- Dropped the deployment count of `cert-manager` back to its default value (1)
  - Reason: cert-manager requires a lease against `kube-system/cert-manager-controller` so only single Pod can function at a time anyway
