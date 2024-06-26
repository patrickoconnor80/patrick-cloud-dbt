#!/usr/bin/env bash

cat > patrick_cloud/profiles.yml <<EOF
patrick_cloud:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: snowplow
      schema: atomic
      host: $DATABRICKS_HOST
      http_path: $DATABRICKS_SQL_ENDPOINT
      token: $DATABRICKS_TOKEN
      threads: 1
EOF

cd patrick_cloud
dbt deps
dbt docs generate --target dev --profiles-dir .
dbt docs serve --profiles-dir .
