#!/bin/bash

set -e

tcd() {
  cd "$TRAVIS_BUILD_DIR"/"$1"
}

git fetch --tags
GIT_TAG="$(git tag | tail -n1)"

TRINITYCORE_REVISION_OLD=$(echo $GIT_TAG | cut -d'r' -f2)
TRINITYCORE_REVISION_NEW=$(($(echo $GIT_TAG | cut -d'r' -f2) + 1))
TRINITYCORE_VERSION=$(echo $GIT_TAG | cut -d'-' -f1)

export GIT_TAG=$TRINITYCORE_VERSION-r$TRINITYCORE_REVISION_NEW

tcd
tar vczf trinitycore-"$GIT_TAG".tar.gz trinitycore

git config --global user.email "builds@travis-ci.com"
git config --global user.name "Travis CI"

cd "$TRAVIS_BUILD_DIR"

git checkout $TRAVIS_BRANCH

if [ -z $TRAVIS_TAG ] ; then
  # Only tag if this is an untagged commit 
  git tag "$GIT_TAG" -a -m "Tag Generated from TravisCI for build $TRAVIS_BUILD_NUMBER ; Changes: 
  $TRAVIS_COMMIT_MESSAGE" 1>/dev/null
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/trinitycore-builds.git --tags 2>&1 1>/dev/null
fi
