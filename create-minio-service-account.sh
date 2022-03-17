#!/bin/sh

set -e
set -o pipefail
cd $(dirname $0)

if [ -z "$MINIO_ACCESS_KEY" ]; then
	1>&2 echo 'missing/empty $MINIO_ACCESS_KEY'
	exit 1
fi
if [ -z "$MINIO_SECRET_KEY" ]; then
	1>&2 echo 'missing/empty $MINIO_SECRET_KEY'
	exit 1
fi

set -x

export MC_HOST_bbnavi="https://$MINIO_ACCESS_KEY:$MINIO_SECRET_KEY@opendata.bbnavi.de"

mc ls bbnavi # test access

mc admin policy add bbnavi list-read-upload-delete policy-list-read-upload-delete.json

export MINIO_DATA_UPLOADER_SECRET_KEY="$(head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c 20)"

mc admin user add bbnavi data-uploader "$MINIO_DATA_UPLOADER_SECRET_KEY"
mc admin policy set bbnavi list-read-upload-delete user=data-uploader

mc admin user svcacct add bbnavi data-uploader
