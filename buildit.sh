#! /bin/bash

docker build -f Dockerfile --network host --no-cache --tag=rltodd/xcat-centos7-x86_64  .
