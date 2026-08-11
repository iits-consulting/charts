# Upgrade to Version 9.3.7
from 9.3.5

Nothing to do before, can be upgraded in place.

Things found after updating:

- [xpack.monitoring.collection.enabled] setting was deprecated in Elasticsearch and will be removed in a future release

  Result: Can be ignored. This is the stack self-monitoring on Kibana, which is currently not activated by default.

- Behavioral Analytics is deprecated and will be removed in a future release.

  Result: Can be ignored, not used in our default setup

- the index privilege [create_doc] allowed the update mapping action [indices:admin/mapping/auto_put] on index [monitoring-elastic-operator-9.3.7-2026.08], this privilege will not permit mapping updates in the next major release

  Result: Can be ignored in the default setup, as the update mapping isn't used
