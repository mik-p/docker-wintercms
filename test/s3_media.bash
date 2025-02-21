#!/bin/bash -e

TEST_ROOT=test
SOURCE_ROOT=..

if [ "$(basename $(pwd))" != "$TEST_ROOT" ]; then
    echo "test run in wrong directory"
    exit 1
fi

TEST_CONTAINER_NAME=test-wn-s3-media
TEST_CONTAINER_TYPE=$SOURCE_ROOT/php8.0/apache
TEST_CONTAINER_DOCKERFILE=Dockerfile

# CREDENTIALS XXXX CHANGE TO TEST
TEST_FILESYSTEM_S3_KEY=nuh
TEST_FILESYSTEM_S3_SECRET=nuh
TEST_FILESYSTEM_S3_REGION=nuh
TEST_FILESYSTEM_S3_BUCKET=nuh
TEST_FILESYSTEM_S3_ENDPOINT=nuh
TEST_FILESYSTEM_S3_URL=nuh
TEST_CMS_MEDIA_DISK=nuh
TEST_CMS_MEDIA_FOLDER=nuh
TEST_CMS_MEDIA_PATH=nuh

echo "build test"
docker build -t $TEST_CONTAINER_NAME $TEST_CONTAINER_TYPE || exit 1

echo "run test container"
docker run \
    -it \
    --rm \
    -p 8888:80 \
    -e INIT_WINTER=true \
    -e CMS_ADMIN_PASSWORD=password \
	-e COMPOSER_UPDATE=true \
	-e ENTRYPOINT_INSTALL_SCRIPT=https://raw.githubusercontent.com/mik-p/docker-wintercms/develop/test/extra_script/entrypoint.sh \
	-e FILESYSTEM_S3_KEY=$TEST_FILESYSTEM_S3_KEY
	-e FILESYSTEM_S3_SECRET=$TEST_FILESYSTEM_S3_SECRET
	-e FILESYSTEM_S3_REGION=$TEST_FILESYSTEM_S3_REGION
	-e FILESYSTEM_S3_BUCKET=$TEST_FILESYSTEM_S3_BUCKET
	-e FILESYSTEM_S3_ENDPOINT=$TEST_FILESYSTEM_S3_ENDPOINT
	-e FILESYSTEM_S3_URL=$TEST_FILESYSTEM_S3_URL
	-e CMS_MEDIA_DISK=$TEST_CMS_MEDIA_DISK
	-e CMS_MEDIA_FOLDER=$TEST_CMS_MEDIA_FOLDER
	-e CMS_MEDIA_PATH=$TEST_CMS_MEDIA_PATH
    $TEST_CONTAINER_NAME || exit 1

echo "test done"

exit 0
