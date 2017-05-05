#!/bin/bash

set -e

tcd() {
  cd "$TRAVIS_BUILD_DIR"/"$1"
}

git fetch --tags
GIT_TAG="$(git tag | tail -n1)"


TRINITYCORE_REVISION=$(($(echo $GIT_TAG | cut -d'r' -f2) + 1))
TRINITYCORE_VERSION=$(echo $GIT_TAG | cut -d'-' -f1)

export GIT_TAG=$TRINITYCORE_VERSION-r$TRINITYCORE_REVISION

tcd
tar vczf trinitycore-"$GIT_TAG".tar.gz trinitycore

git config --global user.email "builds@travis-ci.com"
git config --global user.name "Travis CI"

cd "$TRAVIS_BUILD_DIR"

git checkout $TRAVIS_BRANCH

if git tag "$GIT_TAG" -a -m "Checking if the tag already exists..." 2>/dev/null ; then
  ## The tag is deleted (locally), so that the latest commit for the revision file is included in the tag
  ## When retagging now.
  git tag -d "$GIT_TAG"
  git tag "$GIT_TAG" -a -m "Tag Generated from TravisCI for build $TRAVIS_BUILD_NUMBER" 1>/dev/null
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/trinitycore-builds.git --tags
else 
  echo "Tag already exists!"
fi
