
## 1.7.x -> 1.8.0

💥 **Breaking changes** 💥

None

🎉 **New functionality** 🎉

- Also include traefik crds for `traefik.io`
  - ⚠️ You should migrate all your resources from `traefik.containo.us` to `traefik.io`
    - traefik will drop all support/implementations for resources of the group `traefik.containo.us` in version 3

**Other changes**

- Updated the cert-manager crds

***