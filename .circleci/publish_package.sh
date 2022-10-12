#!/bin/sh
set -ex

ARTIFACTORY_URL="https://rafapaz.jfrog.io/artifactory"
ARTIFACTORY_PATH="$ARTIFACTORY_URL/composer-php-local"

# Determine the version from the tag;
VERSION=$(git describe --tags --abbrev=0)

FILE_NAME="error-php-$VERSION.zip"
git archive -o "$FILE_NAME" HEAD

# Upload archive to Artifactory
STATUSCODE=$(curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$ARTIFACTORY_USER:$ARTIFACTORY_APIKEY" "$ARTIFACTORY_PATH/circleci/welkio-error/$FILE_NAME" -T "$FILE_NAME")

# Debug Artifactory response
echo "Status code returned by Artifactory package push: ${STATUSCODE}"

if [[ ${STATUSCODE:0:1} =~ ^(4|5)$ ]] ; then
    echo "Could not upload package to Artifactory"
    exit 1
fi

# Set package version in Artifactory
STATUSCODE=$(curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$ARTIFACTORY_USER:$ARTIFACTORY_APIKEY" -X PUT "${ARTIFACTORY_URL}/api/storage/composer-php-local/circleci/welkio-error/${FILE_NAME}?properties=composer.version=${VERSION}")

# Debug Artifactory response
echo "Status code returned by Artifactory package version set: ${STATUSCODE}"

if [[ ${STATUSCODE:0:1} =~ ^(4|5)$ ]] ; then
    echo "Could not set Composer package version"
    exit 1
fi

# Final echo to prove that everything worked
echo "Composer package successfully uploaded to Artifactory"

# curl al rest api
#  curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_APIKEY" -X PUT "$HOST/welkio/error-php/$FILE_NAME" -T "$FILE_NAME"


# curl al rest api
#  curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_APIKEY" -X PUT "$HOST/circleci/welkio-error/$FILE_NAME" -T "$FILE_NAME"
