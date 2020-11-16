#!/bin/bash

export UPLOAD_DRIVER=s3 BUCKET_NAME=dopebears REGION_NAME=us-west-2 HTTP_PORT=8080
cd s3-upload-proxy
go build -o s3-upload-proxy
cd ..
./s3-upload-proxy/s3-upload-proxy


