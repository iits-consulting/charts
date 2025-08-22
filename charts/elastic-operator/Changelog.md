# Changelog

## Chart Versions

### BREAKING CHANGE 9.1.0

- app version update to 9.1.0

> Important: Starting with this version we prefix all logs gathered by filebeat with `logs-` to adhere to recommended elastic index pattern.
> We recommend that you also rename old indexes, so that they are also picked up by our ilm policies.
> Any manually created dashboards and data-views will likely not show new data until you update the index-patterns

### BREAKING CHANGE 9.0.1

- app version update to 9.0.1

> Important: The upgrade to version 9.x requires a specific upgrade path (the latest upgrade path can be found [here](https://www.elastic.co/docs/deploy-manage/upgrade/prepare-to-upgrade#prepare-upgrade-from-8.x)). Before installing version 9.0.0, a version update to 8.18.1 must be made, otherwise the upgrade will fail. Use version "8.18.1-fb-migr-filestream" from our stack for easy upgrading.

### 8.18.1-fb-migr-filestream

> Important: In preparation for the upgrade to version 9.0.0, this update must be installed as part of the upgrade path. Otherwise Filebeat will not be functional after upgrading to v9.0.0.

The `container` input for Filebeat was deprecated in version `7.16` and is completely disabled by version `9.0.0` (see [#42295](https://github.com/elastic/beats/pull/42295)).
Following the official [migration guide](https://www.elastic.co/docs/reference/beats/filebeat/migrate-to-filestream), in preparation for the migration from `container` input to `filestream`, a specific tag `take_over` must be set, so Filebeat can separate logs created by the container input from the filestream input. Otherwise an error is thrown and data may be duplicated.

- this Helm chart version adds the `filestream` input and sets the `take_over` tag as part of the migration
- in version `9.0.0` the `take_over` tag will be removed to complete the migration

### 8.18.1-fb-tolerations

- fixed a bug in the Helm chart that caused tolerations rendering to fail for Filebeat

### 8.18.1

- app version update to 8.18.1
- elastic operator update to 3.0.0 in preparation for app version upgrade to 9.0.0
