# Upgrade description

Descriptions on actions needed, when upgrading within our chart defaults to the mentioned verions

## 7.4.0

- `allowAdminRoleMapping` on IdP must be explicitly set to `true` so that their mappers can still assign groups that grant administrative roles
- Keycloak TF provider above vXXXXX must be used to still access realm-management client

## 7.3.1

 - Restart the Keycloak pods after `helm upgrade` (`kubectl rollout restart statefulset/<name>`). The flag is set via the `-env` ConfigMap, which does not trigger a restart on its own.
 - If you override `keycloakx.configMapEnv.JAVA_OPTS_APPEND`, add `-XX:-UseBASE64Intrinsics` to your own value. Your override replaces the chart default.
 - Verify per pod: `kubectl exec <pod> -- sh -c "tr '\0' ' ' < /proc/1/cmdline" | grep -o -- '-XX:-UseBASE64Intrinsics'`

## 7.3.0-add-dashboard

- No changes needed

## to 7.3.0

- Deprecation warnings about `WebAuthn policy option 'requireResidentKey'` and `identity-brokering-api:v1, twitter-broker:v1` (coming from 7.1.8, can be ignored in our standard setups)
