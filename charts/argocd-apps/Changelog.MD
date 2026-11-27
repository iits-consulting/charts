# Changelog

## Chart Versions

### 2.2.0
- Add optional per project `valuesSource` to load value files from a second git repository (renders `sources` instead of `source` only when set)
- Add optional per project `ignoreMissingValueFiles` (default false)
- Add optional per project `clusterResourceWhitelist` override (default stays group `*` and kind `*`)
- Set `conversionStrategy`, `decodingStrategy` and `metadataPolicy` explicitly in the repo ExternalSecret to avoid permanent ArgoCD diffs against the ESO defaults

### 2.1.0
- Add possibility to limit a project to specific namespaces

### 2.0.4
- default targetRevision to refs/heads/main in application.yaml

### 2.0.3
- Fix missing template separator in repo-config-plain.yaml

### 2.0.2
- Adds a missing check regarding the stage variable and reformats the application.yaml

### 2.0.1
- Moved the stage variable for extra value files back into projectValues to prevent duplicate entries

### 2.0.0
- **Breaking:** Adjusted the projectValues section to a more general approach for setting additional values
- Updated repo-config for plain text credentials and renamed it to repo-config-plain.yaml. Added error handling
- Added possibility to add externalSecrets object instead of plaintext repo-config

### 1.0.1

- Fixed a bug that did not allow repositories under `projects` in the `values.yaml` to be defined without the key `password`

### 1.0.0

- Moved code base over from [ArgoCD](https://github.com/iits-consulting/charts/tree/main/charts/argocd) to split usage. ArgoCD chart will take care of the setup and this chart will take care of all content objects being used inside of ArgoCd like Applications. Nex to this, there were no changes made to the code base.
