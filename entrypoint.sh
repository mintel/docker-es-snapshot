#!/bin/sh

set -e

# Remove trailing slash from URL if it has one
CLUSTER_URL=$(echo $CLUSTER_URL | sed "s/\/$//")

# Set bucket name from file if file path is provided
if [[ ! -z "${BUCKET_NAME_FILE_PATH}" ]]; then
    BUCKET_NAME=$(cat $BUCKET_NAME_FILE_PATH)
fi

RESTORE_BYTES_PER_SEC=${RESTORE_BYTES_PER_SEC:-40mb}
SNAPSHOT_BYTES_PER_SEC=${SNAPSHOT_BYTES_PER_SEC:-40mb}
READONLY=${READONLY:-false}

echo "Reloading secure settings"
curl -s -X POST ${CLUSTER_URL}/_nodes/reload_secure_settings?pretty

echo
echo "Creating snapshot repository"
curl -s -X PUT ${CLUSTER_URL}/_snapshot/${REPOSITORY_NAME}?pretty -H "Content-Type: application/json" -d'
{
    "type": "'${REPOSITORY_TYPE}'",
    "settings": {
        "bucket": "'${BUCKET_NAME}'",
        "base_path": "'${SNAPSHOT_PATH}'",
        "max_restore_bytes_per_sec": "'${RESTORE_BYTES_PER_SEC}'",
        "max_snapshot_bytes_per_sec": "'${SNAPSHOT_BYTES_PER_SEC}'",
        "readonly": '${READONLY}'
    }
}'

if [[ -z "${SKIP_ACTIONS}" ]]; then
  echo
  echo "Running actions"
  curator --config /etc/config/config.yml /etc/config/actions.yml
fi

if [[ ! -z "${SNAPSHOT_RETENTION}" ]]; then
  echo
  echo "Deleting old snapshot(s)"
  curator --config /etc/config/config.yml /etc/config/retention.yml
fi

echo
echo "Complete!"
