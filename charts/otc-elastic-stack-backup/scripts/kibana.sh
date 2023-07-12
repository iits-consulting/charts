#!/bin/bash

NAMESPACE="monitoring"
SERVICE="elastic-stack-kibana"
PORT="5601"
LOCAL_PORT="5601"

CI_ENVIRONMENT=false
TEMP_FILE="export.ndjson"
SOURCE_STAGE="dev"
TARGET_STAGES=("infrastructure" "qa")
SAVED_OBJECTS=("dashboard" "visualization")


function _kubectl_port_forward() {
  lsof -ti tcp:$LOCAL_PORT | xargs kill 2>/dev/null
  kubectl port-forward -n $NAMESPACE svc/$SERVICE $LOCAL_PORT:$PORT 2>/dev/null >/dev/null &
  sleep 5
}

function _select_environment(){
  if $CI_ENVIRONMENT ; then
    #  FOR CI ENVIRONMENTS
    VAULT_TOKEN=$(vault write -field=token auth/gitlab/login role_id="$VAULT_ROLE_ID" secret_id="$VAULT_SECRET_ID") || true
    export VAULT_TOKEN=$VAULT_TOKEN
    vault kv get -field kubectl_config secret/"$1"/kubectl | base64 -d > /root/.kube/config || true
  else
    # FOR LOCAL EXECUTION
    vault kv get -field=kubectl_config secret/"$1"/kubectl | base64 -d > ~/.kube/config || true
  fi
  _kubectl_port_forward
}

function _export_kibana_saved_objects(){
  echo "Exporting saved objects from stage $1..."
  saved_objects_json=$(printf '%s\n' "${SAVED_OBJECTS[@]}" | jq -R . | jq -s .)
  _select_environment "$1"
  request_body=$(cat <<-EOF
    {
      "includeReferencesDeep": true,
      "type": $saved_objects_json
    }
EOF
    )
    curl -X POST localhost:5601/api/saved_objects/_export -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d "$request_body" >> $TEMP_FILE
    echo >> $TEMP_FILE
    echo
}

function _import_kibana_saved_objects(){
  echo "Importing saved objects into stage $1..."
  _select_environment "$1"
  curl -X POST localhost:5601/api/saved_objects/_import?overwrite=true -H "kbn-xsrf: true" --form file=@$TEMP_FILE
  echo && echo
}

function _cleanup() {
  lsof -ti tcp:$LOCAL_PORT | xargs kill 2>/dev/null
  rm -f $TEMP_FILE
  exit 0 || return 0
}


_export_kibana_saved_objects $SOURCE_STAGE
for stage in "${TARGET_STAGES[@]}"; do
  _import_kibana_saved_objects "$stage"
done
_cleanup




