#!/bin/bash

set -e

tcd() {
  cd "$TRAVIS_BUILD_DIR"/"$1"
}

tcd

git config --global user.email "builds@travis-ci.com"
git config --global user.name "Travis CI"
git fetch --tags

CURRENT_TAG="$(git tag | tail -n1)"

TRINITYCORE_VERSION=$(echo $CURRENT_TAG | cut -d'-' -f1)
TRINITYCORE_NEW_REVISION=$(($(echo $CURRENT_TAG | cut -d'r' -f2) + 1))

GIT_TAG=$TRINITYCORE_VERSION-r$TRINITYCORE_NEW_REVISION

git clone -b $TRINITYCORE_VERSION --single-branch https://github.com/dgonzalezruiz/nami-trinitycore

tcd nami-trinitycore

git fetch --tags
git checkout $TRAVIS_BRANCH

# The above pushes a tag to the following repo in the pipeline, triggering a build consequently.

if [ ! -z $TRAVIS_TAG ] ; then
  # Only tag if this is a tagged commit 
  git tag "$GIT_TAG" -a -m "Tag Generated from TravisCI for build $TRAVIS_BUILD_NUMBER in trinitycore-builds; Changes: 
  $TRAVIS_COMMIT_MESSAGE" 1>/dev/null
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/nami-trinitycore.git --tags 2>&1 1>/dev/null
fi
