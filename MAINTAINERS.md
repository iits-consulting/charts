# Maintainers

Every chart in [`charts/`](charts) has a responsible squad. The responsible squad:

- reviews and approves pull requests for its charts
- keeps its charts and their dependencies up to date
- decides on breaking changes and major version bumps of its charts
- is the first point of contact for issues concerning its charts

The squads are not yet modelled as GitHub teams, so there is no `CODEOWNERS` file and squads cannot be
mentioned or requested as reviewers directly. Until then, name the responsible squad in the description of
your pull request or issue and reach out to its members directly.

| Chart                                                      | Responsible squad |
|------------------------------------------------------------|-------------------|
| [akhq](charts/akhq)                                        | _unassigned_      |
| [argocd](charts/argocd)                                    | Squad 3           |
| [argocd-apps](charts/argocd-apps)                          | Squad 3           |
| [argocd-oidc](charts/argocd-oidc)                          | Squad 3           |
| [cce-storage-classes](charts/cce-storage-classes)          | Squad 3           |
| [cert-manager](charts/cert-manager)                        | Squad 1           |
| [common](charts/common)                                    | Squad 2           |
| [elastalert](charts/elastalert)                            | Squad 2           |
| [elastic-operator](charts/elastic-operator)                | Squad 2           |
| [ext-postgres-operator](charts/ext-postgres-operator)      | _unassigned_      |
| [iits-admin-dashboard](charts/iits-admin-dashboard)        | Squad 2           |
| [kafka](charts/kafka)                                      | _unassigned_      |
| [kasm](charts/kasm)                                        | _unassigned_      |
| [keycloakx](charts/keycloakx)                              | Squad 2           |
| [kumoops-admin-dashboard](charts/kumoops-admin-dashboard)  | _unassigned_      |
| [kyverno](charts/kyverno)                                  | Squad 3           |
| [oidc-forward-auth](charts/oidc-forward-auth)              | Squad 1           |
| [prometheus-stack](charts/prometheus-stack)                | Squad 1           |
| [tcp-proxy](charts/tcp-proxy)                              | _unassigned_      |
| [traefik](charts/traefik)                                  | Squad 1           |
| [vulnerability-checks](charts/vulnerability-checks)        | Squad 2           |
| vault-stack                                                | Squad 3           |

Charts marked _unassigned_ have no responsible squad. Changes to them are welcome, but expect slower reviews.
If your squad relies on one of them, consider taking over ownership.

When you add a new chart, add it to this table together with its responsible squad.
