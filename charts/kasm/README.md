# kasm

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

# Description

This is just a Proof of Concept for KASM. Don't use it for production.

## Installing the Chart with iits ArgoCD
```yaml
kasm:
  namespace: kasm
  repoURL: "https://charts.iits.tech"
  targetRevision: "0.5.0"


#value-files/kasm/values.yaml
services:
  firstuser:
    ingressRoute:
      domain: firstuser.playground.iits.tech
      certificate:
        name: "traefik-default-cert"
    extraEnv:
      VNC_PW: 12345
  seconduser:
    ingressRoute:
      domain: seconduser.playground.com
      certificate:
        name: "traefik-default-cert"
    extraEnv:
      VNC_PW: 12345
```

## Dependencies

This services needs to be installed upfront

- traefik
- cert-manager
- wildcart certificate