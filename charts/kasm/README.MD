# Description

This is just a Proof of Concept for KASM. Don't use it for production.

## Usage inside infrastructure-charts
```yaml
kasm:
  namespace: kasm
  repoURL: "https://charts.iits.tech"
  targetRevision: "0.1.1"
  parameters:
    services.firstuser.extraEnv.VNC_PW: "REPLACE_ME"
    services.firstuser.ingressRoute.domain: "REPLACE_ME"
```

## Dependencies

This services needs to be installed upfront

- traefik
- cert-manager


## How to add a new instance

Just duplicate the firstuser part inside values.yaml and rename it