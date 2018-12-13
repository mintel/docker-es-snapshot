#!/bin/sh

set -e

# Remove trailing slash from URL if it has one
CLUSTER_URL=$(echo $CLUSTER_URL | sed "s/\/$//")

echo "Reloading secure settings"
curl -s -X POST ${CLUSTER_URL}/_nodes/reload_secure_settings?pretty

echo
echo "Creating snapshot repository"
curl -s -X PUT ${CLUSTER_URL}/_snapshot/${REPOSITORY_NAME}?pretty -H "Content-Type: application/json" -d'
{
    "type": "'${REPOSITORY_TYPE}'",
    "settings": {
        "bucket": "'$(cat ${BUCKET_NAME_FILE_PATH})'",
        "base_path": "'${BACKUP_PATH}'"
    }
}'

echo
echo "Starting backup"
DATE=$(date +%Y.%m.%d-%H.%M.%S)
curl -s -X PUT "${CLUSTER_URL}/_snapshot/${REPOSITORY_NAME}/${DATE}?wait_for_completion=true&pretty"

echo
echo "Finding snapshots older than the retention threshold (${SNAPSHOT_RETENTION})"
SNAPSHOTS_TO_DELETE=$(curl -s ${CLUSTER_URL}/_snapshot/${REPOSITORY_NAME}/_all | jq -r ".snapshots[:-${SNAPSHOT_RETENTION}][].snapshot")

if [[ ! -z "${SNAPSHOTS_TO_DELETE}" ]]; then
    for snapshot in ${SNAPSHOTS_TO_DELETE}; do
        echo "Deleting snapshot ${snapshot}"
        curl -s -X DELETE ${CLUSTER_URL}/_snapshot/${REPOSITORY_NAME}/${snapshot}?pretty
    done
fi

echo
echo "Complete!"
