# ElasticSearch snapshot container
Docker container to trigger and cleanup ElasticSearch snapshots using the Elastic Curator, curl and jq.

## Usage
This image uses the following config files which need to be mounted in `/etc/config`:
* `actions.yml`: the [actionfile](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/actionfile.html) used to [create](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/snapshot.html) or [restore](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/restore.html) your snapshot
* `config.yml`: the curator's ElasticSearch [client config](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/configfile.html)
* `retention.yml`: (optional) - the action file used to [delete old snapshots](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/delete_snapshots.html)

You need to provide the following environment variables:
* `CLUSTER_URL`: the URL of your ElasticSearch cluster
* `REPOSITORY_NAME`: the name of your snapshot repository (see [ES documentation](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/modules-snapshots.html#_repositories) for more information)
* `REPOSITORY_TYPE`: the type of your respository (at the moment, only bucket-based repositories are supported, i.e. S3 and GCS. See TODOs)
* `BUCKET_NAME`: the name of your bucket (alternatively, specify `BUCKET_NAME_FILE_PATH` as the path to a file containing the bucket name)
* `SNAPSHOT_PATH`: the path that you want your snapshots to live within your repository

Optional environment variables:
* `SNAPSHOT_RETENTION`: the number of past snapshots you want to keep (if this is set, previous snapshots will be deleted) (note that the `retention.yml` file mentioned above is required if this is set)

## TODO
* Add support for non-bucket-based snapshots
* Maybe make some values optional, with sensible defaults?
* Error out if required env vars not specified
