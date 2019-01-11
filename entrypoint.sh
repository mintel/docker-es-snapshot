#!/bin/sh

set -e

# Remove trailing slash from URL if it has one
CLUSTER_URL=$(echo $CLUSTER_URL | sed "s/\/$//")

# Set bucket name from file if file path is provided
if [[ ! -z "${BUCKET_NAME_FILE_PATH}" ]]; then
    BUCKET_NAME=$(cat $BUCKET_NAME_FILE_PATH)
fi

echo "Reloading secure settings"
curl -s -X POST ${CLUSTER_URL}/_nodes/reload_secure_settings?pretty

echo
echo "Creating snapshot repository"
curl -s -X PUT ${CLUSTER_URL}/_snapshot/${REPOSITORY_NAME}?pretty -H "Content-Type: application/json" -d'
{
    "type": "'${REPOSITORY_TYPE}'",
    "settings": {
        "bucket": "'${BUCKET_NAME}'",
        "base_path": "'${SNAPSHOT_PATH}'"
    }
}'

echo
echo "Creating snapshot"
curator --config /etc/config/config.yml /etc/config/snapshot.yml

if [[ ! -z "${SNAPSHOT_RETENTION}" ]]; then
  echo
  echo "Deleting old snapshot(s)"
  curator --config /etc/config/config.yml /etc/config/retention.yml
fi

echo
echo "Complete!"
