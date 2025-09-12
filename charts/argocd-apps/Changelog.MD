# Changelog

## Chart Versions

### 1.0.1

- Fixed a bug that did not allow repositories under ` rojects` in the `values.yaml` to be defined without the key `password`

### 1.0.0

- Moved code base over from [ArgoCD](https://github.com/iits-consulting/charts/tree/main/charts/argocd) to split usage. ArgoCD chart will take care of the setup and this chart will take care of all content objects being used inside of ArgoCd like Applications. Nex to this, there were no changes made to the code base.
