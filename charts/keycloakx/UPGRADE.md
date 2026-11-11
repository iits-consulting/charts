# Upgrade description

Descriptions on actions needed, when upgrading within our chart defaults to the mentioned verions

## 7.4.0

- `allowAdminRoleMapping` on IdP must be explicitly set to `true` so that their mappers can still assign groups that grant administrative roles

## 7.3.0-add-dashboard

- No changes needed

## to 7.3.0

- Deprecation warnings about `WebAuthn policy option 'requireResidentKey'` and `identity-brokering-api:v1, twitter-broker:v1` (coming from 7.1.8, can be ignored in our standard setups)
