# Changelog

## Chart Versions

### 3.0.0

- **Breaking** Set default of `autoInjectDockerPullSecrets.enabled` to false
- Added feature to use existing imagePullSecrets in release namespace

### 2.5.0

- Simplified mutating policy for security context enforcement

### 2.4.0

- Update kyverno Chart to 3.4.0
- Update kyverno-policies to 3.4.0
- Update policy-reported to 3.1.3

### 2.3.0

- fixed a bug that caused jobs to not count as completed even if the underlying pod finished successfully
- reworked the internal structure of our custom policies, some parameters change please check if you have overriden some
- Updated kyverno to Chart 3.3.7 / AppVersion 1.13.4
- Updated kyverno-policies to 3.3.4
- Updated policy-reported to 3.0.7

### 2.2.2

- PolicyExceptions are now toggled on by default

### 2.2.1

- Fixed an issue with missing rbac parameter for the admission controller

### 2.2.0

- Update kyverno Chart to 3.3.4 & AppVersion to 1.13.2
- Update kyverno-policies to 3.3.2
- Update policy-reported to 3.0.0

Note:

- There were changes in the CRDs, you have to update them **before** updating.
- Rolling Updates do not work if you come from 2.1.x.
- It is recommended to completely uninstall the old version first, then update the CRDs and then install the new version.

### 2.1.1

- Update kyverno Chart to 3.2.7 & AppVersion to 1.12.6
- Update kyverno-policies to 3.2.6
- Update policy-reported to 2.24.2
- No migrations necessary.
