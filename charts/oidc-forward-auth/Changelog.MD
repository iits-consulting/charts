# Changelog

## Changelog Versions

### 1.8.0
- Update gogatekeeper helm chart version to 0.1.54
- Update AppVersion to 3.3.0

### 1.7.1

- Drop the authResponseHeaders from the middleware
  - gogatekeeper will no longer Override the `Authentication` header a client might send.
- Disable encryption of the access-token cookie.
  - this way automated clients can still interact with protected domains.

### 1.7.0

- AppVersion update to 3.0.2
- encryption-key is now required by default
- Gatekeeper will now refresh the cookie in the browser and also encrypt the token.

### 1.6.2

- Security settings for pod
- AppVersion update to 2.14.3
- No migrations necessary
