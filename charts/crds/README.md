# Description

This chart deploys common crds for iits-consulting only projects.
Like this we avoid the _hen and egg_ problem. For example, you can not use traefik
IngressRoute before you deploy traefik.

For sure, you can also use sync-waves and other mechanism, but it creates a lot of complexity
and a huge dependency graph.
