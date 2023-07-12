#!/bin/bash

NAMESPACE="monitoring"
SERVICE="elasticsearch-master"
PORT="9200"
LOCAL_PORT="9200"
SNAPSHOT_REPOSITORY="backup_repository"

function _kubectl_port_forward() {
  lsof -ti tcp:$LOCAL_PORT | xargs kill 2>/dev/null
  kubectl port-forward -n $NAMESPACE svc/$SERVICE $LOCAL_PORT:$PORT 2>/dev/null >/dev/null &
  sleep 5
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

function _check_snapshots() {
  echo "Available snapshots in $SNAPSHOT_REPOSITORY are: "
  echo
  curl -s -X GET "localhost:$LOCAL_PORT/_cat/snapshots/$SNAPSHOT_REPOSITORY?v&s=id&pretty"
  sleep 1
}

function _cleanup() {
  lsof -ti tcp:$LOCAL_PORT | xargs kill 2>/dev/null
  exit 0 || return 0
}

_kubectl_port_forward
_create_backup_repository
echo
_check_snapshots
_cleanup
