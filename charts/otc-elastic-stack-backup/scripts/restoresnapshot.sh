#!/bin/bash

NAMESPACE="monitoring"
SERVICE="elasticsearch-master"
PORT="9200"
LOCAL_PORT="9200"
SNAPSHOT_REPOSITORY="backup_repository"
KIBANA_NAME="elastic-stack-kibana"
KIBANA_APPNAME="kibana"
KIBANA_REPLICAS="2"
FILEBEAT_NAME="elastic-stack-filebeat"
FILEBEAT_APPNAME="elastic-stack-filebeat"

function _kubectl_port_forward() {
  lsof -ti tcp:$LOCAL_PORT | xargs kill 2>/dev/null
  kubectl port-forward -n $NAMESPACE svc/$SERVICE $LOCAL_PORT:$PORT >/dev/null &
  sleep 2
}

function _create_backup_repository() {
  echo Creating and checking backup_repository...
  curl -s -o /dev/null -X PUT "localhost:$LOCAL_PORT/_snapshot/$SNAPSHOT_REPOSITORY?pretty" -H 'Content-Type: application/json' -d'
  {
    "type": "fs",
    "settings": {
      "location": "/opt/backup"
    }
  }
  '
  sleep 1
  curl -s -X GET "localhost:$LOCAL_PORT/_snapshot/_all?pretty"
  sleep 1
}

function _check_snapshot() {
  SNAPSHOT=$(curl -s -X GET "localhost:$LOCAL_PORT/_snapshot/$SNAPSHOT_REPOSITORY/$SNAPSHOT_NAME/?pretty")
  SNAPSHOT_STATUS=$(echo "$SNAPSHOT" | jq .status)
  if [ "$SNAPSHOT_STATUS" != null ]; then
    echo "Snapshot status is invalid: $SNAPSHOT_STATUS"
    _cleanup 1
  fi
  echo "$SNAPSHOT"
}

function _prompt_confirmation() {
  echo "WARNING! This operation will irreversibly modify the existing indices in elasticsearch!"
  read -p "Would you like to restore $SNAPSHOT_NAME? (Only \"yes\" will be accepted as a valid answer) " -r
  if [ ! "$REPLY" = "yes" ]; then
    _cleanup 1
  fi
}

function _restore() {
  echo "Removing dependent pods..."
  kubectl scale --replicas=0 deployment -n $NAMESPACE $KIBANA_NAME
  kubectl get daemonset -n $NAMESPACE $FILEBEAT_NAME -o yaml >daemonset_backup.yaml
  sleep 1
  kubectl delete daemonset -n $NAMESPACE $FILEBEAT_NAME
  sleep 20
  curl -X POST "localhost:$LOCAL_PORT/_all/_close?pretty"
  sleep 1
  echo "Removing existing indices..."
  curl -X DELETE "localhost:9200/_all?pretty" -H 'Content-Type: application/json' -d'
  {
    "expand_wildcards": all
  }
  '
  sleep 5
  curl -X POST "localhost:$LOCAL_PORT/_all/_close?pretty"
  sleep 1
  echo "Restoring snapshot $SNAPSHOT_NAME..."
  curl -X POST "localhost:$LOCAL_PORT/_snapshot/$SNAPSHOT_REPOSITORY/$SNAPSHOT_NAME/_restore?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'
  {
    "indices": "-ilm-*,-elastalert_status*",
    "include_global_state": true
  }
  '
  sleep 1
  kubectl scale --replicas=$KIBANA_REPLICAS deployment -n $NAMESPACE $KIBANA_NAME
  kubectl apply -f daemonset_backup.yaml
  kubectl -n $NAMESPACE wait --for=condition=Ready --timeout=10m pods -l app=$KIBANA_APPNAME
  kubectl -n $NAMESPACE wait --for=condition=Ready --timeout=10m pods -l app=$FILEBEAT_APPNAME
  rm daemonset_backup.yaml
}

function _cleanup() {
  lsof -ti tcp:$LOCAL_PORT | xargs kill 2>/dev/null
  if [ "$1" == "0" ]; then
    echo "$SNAPSHOT_NAME restored."
  else
    echo "Restore cancelled."
  fi
  exit "$1" || return "$1"
}

_kubectl_port_forward
_create_backup_repository
echo "Available snapshots in $SNAPSHOT_REPOSITORY are:"
echo
curl -s -X GET "localhost:$LOCAL_PORT/_cat/snapshots/$SNAPSHOT_REPOSITORY?v&s=id&pretty"
echo
read -p "Please select a snapshot id to restore: " -r
SNAPSHOT_NAME=$REPLY
_check_snapshot
_prompt_confirmation
_restore
_cleanup 0
