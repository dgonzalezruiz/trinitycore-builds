#!/bin/bash

set -e

tcd() {
  cd "$TRAVIS_BUILD_DIR"/"$1"
}

tcd

git config --global user.email "builds@travis-ci.com"
git config --global user.name "Travis CI"

git fetch --tags
git checkout $TRAVIS_BRANCH

CURRENT_TAG="$(git tag | tail -n1)"
if [ -z $CURRENT_TAG ] ; then
  # We set the current tag to 0 if it does not exist
  CURRENT_TAG="3.3.5-r0"
fi 

TRINITYCORE_NEW_REVISION=$(($(echo $CURRENT_TAG | cut -d'r' -f2) + 1))
TRINITYCORE_VERSION=$(echo $CURRENT_TAG | cut -d'-' -f1)

GIT_TAG=$TRINITYCORE_VERSION-r$TRINITYCORE_NEW_REVISION

if [ -z $TRAVIS_TAG ] ; then
  # If this is a tagged build, then the tarball tag is that tag
  # If it is not, them we tag the tarball the same way we will tag the repo
  TARBALL_TAG=$CURRENT_TAG
else 
  TARBALL_TAG=$GIT_TAG
fi

tar czf trinitycore-"$TARBALL_TAG".tar.gz trinitycore

if [ -z $TRAVIS_TAG ] ; then
  # Only tag if this is an untagged commit 
  git tag "$GIT_TAG" -a -m "Tag Generated from TravisCI for build $TRAVIS_BUILD_NUMBER ; Changes: 
  $TRAVIS_COMMIT_MESSAGE" 1>/dev/null
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/trinitycore-builds.git --tags 2>&1 1>/dev/null
fi
