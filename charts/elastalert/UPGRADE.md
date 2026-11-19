# Upgrade description

Descriptions on actions needed, when upgrading within our chart defaults to the mentioned versions

## to 0.6.0

### Pre-flight checklist

- [ ] Note the currently deployed chart version (rollback target, `0.5.1` or older)
- [ ] Test rendering the new version with your own values: `helm template elastalert iits-charts/elastalert --version 0.6.0 -f <your-values>`

### Upgrade

Action: set `targetRevision: "0.6.0"` and sync / run `helm upgrade`. The deployment rolls once (new image).

### Post-upgrade verification

- [ ] Pod runs image `jertel/elastalert2:2.32.0` and is `Ready`
- [ ] Pod log shows all rules loaded and no `Error loading rule` / schema errors
- [ ] `ExternalSecret/elastalert-slack-webhook` is `SecretSynced` (ESO mode only)
- [ ] A test alert reaches the Slack channel

### Rollback

Set `targetRevision` back to the previous version (e.g. `0.5.1`) and sync.

### References

- [ElastAlert 2 changelog](https://github.com/jertel/elastalert2/blob/master/CHANGELOG.md) (sections 2.25.0 – 2.32.0)
- [common chart changelog](../common/Changelog.md)
