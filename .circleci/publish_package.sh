#!/bin/sh
set -ex

# HOST="https://wework.jfrog.io/artifactory/api/composer/php-local"
HOST="https://rafapaz.jfrog.io/artifactory/composer-php-local"
# Determine the version from the tag; remove the leading v "v3.3.0" -> "3.3.0"
LATEST_TAG=$(git describe --tags --abbrev=0)
VERSION=8.0.0

FILE_NAME="rafapaz-test-$VERSION.zip"
git archive -o "$FILE_NAME" HEAD

# curl al rest api
 curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_APIKEY" -X PUT "$HOST/circleci/welkio-error/$FILE_NAME" -T "$FILE_NAME"
