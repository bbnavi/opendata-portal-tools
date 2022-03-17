# bbnavi open data portal

**We run [MinIO](https://min.io) instance under [`opendata.bbnavi.de`](https://opendata.bbnavi.de), which serves files with an [AWS S3](https://aws.amazon.com/s3/)-compatible API.**

This MinIO instance can be managed both the [Web UI at `console.opendata.bbnavi.de`](https://console.opendata.bbnavi.de) and via any S3-compatible command-line tool, e.g. the official [`mc` MinIO Client](https://docs.min.io/minio/baremetal/reference/minio-mc.html) or the [AWS CLI's `s3` subcommand](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/index.html).

*Note:* At least one user's credentials should be stored in our shared password manager; They can be used both via the UI and from the command line.

The MinIO instance itself, as well as its infrastructure, is configured in [our shared infrastructure repo](https://gitlab.tpwd.de/cmmc-systems/docker-quantum/-/tree/release/tpwd-bb-navi).
