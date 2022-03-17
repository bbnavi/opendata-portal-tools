#!/bin/sh

set -e
set -o pipefail
cd $(dirname $0)

if [ "$1" == '--help' ]; then
	1>&2 echo 'usage: create-minio-public-bucket.sh <bucket-name>'
	exit
fi
if [ -z "$1" ]; then
	1>&2 echo 'missing/empty bucket-name parameter'
	exit 1
fi
bucket=$1

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

mc mb "bbnavi/$bucket"

mc anonymous set download "bbnavi/$bucket"

