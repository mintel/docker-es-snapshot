# ElasticSearch snapshot container
Docker container to trigger and cleanup ElasticSearch snapshots using curl and jq.

## Usage
You need to provide the following environment variables:
* `CLUSTER_URL`: the URL of your ElasticSearch cluster
* `REPOSITORY_NAME`: the name of your backup repository (see [ES documentation](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/modules-snapshots.html#_repositories) for more information)
* `REPOSITORY_TYPE`: the type of your respository (at the moment, only bucket-based repositories are supported, i.e. S3 and GCS. See TODOs)
* `BUCKET_NAME_FILE_PATH`: the path to the file in which your bucket name can be found
* `BACKUP_PATH`: the path that you want your snapshots to live within your repository

Optional environment variables:
* `SNAPSHOT_RETENTION`: the number of past snapshots you want to keep (any previous snapshots will be deleted)

## TODO
* Add support for non-bucket-based snapshots
* Maybe make some values optional, with sensible defaults?
* Support bucket name in environment rather than forcing the use of a file
