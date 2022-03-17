# bbnavi open data portal

**We run [MinIO](https://min.io) instance under [`opendata.bbnavi.de`](https://opendata.bbnavi.de), which serves files with an [AWS S3](https://aws.amazon.com/s3/)-compatible API.**

This MinIO instance can be managed both the [Web UI at `console.opendata.bbnavi.de`](https://console.opendata.bbnavi.de) and via any S3-compatible command-line tool, e.g. the official [`mc` MinIO Client](https://docs.min.io/minio/baremetal/reference/minio-mc.html) or the [AWS CLI's `s3` subcommand](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/index.html).

*Note:* At least one user's credentials should be stored in our shared password manager; They can be used both via the UI and from the command line.

The MinIO instance itself, as well as its infrastructure, is configured in [our shared infrastructure repo](https://gitlab.tpwd.de/cmmc-systems/docker-quantum/-/tree/release/tpwd-bb-navi).

## Usage

The following sections assume that you have installed the official [`mc` MinIO Client](https://docs.min.io/minio/baremetal/reference/minio-mc.html). Download `mc` [as documented in their "Quickstart" section](https://docs.min.io/minio/baremetal/reference/minio-mc.html#quickstart) and make sure it's in the `$PATH`.

As an example, we're going to set up the Linux 64-bit binary:

```shell
curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o bin/mc
export PATH="$PWD/bin:$PATH"
mc --help
# NAME:
#   mc - MinIO Client for cloud storage and filesystems.
# …
```

They also assume that you have admin access to the MinIO instance. Make sure to set `$MINIO_ACCESS_KEY` and `$MINIO_SECRET_KEY` appropriately:

```shell
read -p 'username/access key of a MinIO user with admin permissions: ' MINIO_ACCESS_KEY
read -p "admin user's password/secret key: " MINIO_SECRET_KEY

# make $MINIO_ACCESS_KEY & $MINIO_SECRET_KEY available to child processes
export MINIO_ACCESS_KEY MINIO_SECRET_KEY
```

### service account for automated publishing

From several data sources' continuous deployment runs, we **publish data onto `opendata.bbnavi.de` in an automated way, using a service account**. This section explains how to set up such a service account *once* on a new MinIO instance.

*Note:* Once set up, the service account's credentials should be stored in our shared password manager as well, so that team members can set up additional publishing processes.

Configure access to the MinIO instance (see above) and run the [`create-minio-service-account.sh` script](create-minio-service-account.sh):

```shell
./create-minio-service-account.sh
```

The script will

1. create a policy `list-read-upload-delete` that allows
	- listing buckets
	- listing & reading all files in *every* bucket
	- uploading new & overwriting existing files in *every* bucket
	- deleting files in *every* bucket
2. create a user `data-uploader` with the `list-read-upload-delete` policy, printing its credentials
3. create a service account for the `data-uploader` user, to be used for scripts, printing its credentials

This means that **the generated service account will have write access to *every* bucket**.
