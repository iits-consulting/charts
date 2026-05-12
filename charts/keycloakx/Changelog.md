# Changelog

## Chart Versions

### 7.1.11
 - Add optional Postgres + PostgresUser CRs (`postgresOperator.databases`) for movetokube/postgres-operator integration.
 - Add `postgresOperator.annotations` (global) plus per-database and per-user `annotations` overrides on the Postgres / PostgresUser CRs. Enables pinning CRs to a specific operator instance via `postgres-operator/instance: <name>`.
 - Update underlying chart to 7.1.11 (appVersion 26.5.6) 

### 7.1.8
 - Initial release
