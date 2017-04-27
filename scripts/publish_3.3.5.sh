#!/bin/bash

set -e

tcd() {
  cd "$TRAVIS_BUILD_DIR"/"$1"
}

NEW_TRINITYCORE_REVISION=$((`cat $TRAVIS_BUILD_DIR/TRINITYCORE_NAMI_REVISION` + 1))
echo "$NEW_TRINITYCORE_REVISION" > "$TRAVIS_BUILD_DIR"/TRINITYCORE_NAMI_REVISION

export GIT_TAG=`cat $TRAVIS_BUILD_DIR/TRINITYCORE_NAMI_VERSION`-r`cat $TRAVIS_BUILD_DIR/TRINITYCORE_NAMI_REVISION`

tcd
tar vczf trinitycore-"$GIT_TAG".tar.gz trinitycore

git config --global user.email "builds@travis-ci.com"
git config --global user.name "Travis CI"
git fetch --tags

cd "$TRAVIS_BUILD_DIR"

git checkout $TRAVIS_BRANCH

if git tag "$GIT_TAG" -a -m "Checking if the tag already exists..." 2>/dev/null ; then
  git add TRINITYCORE_NAMI_REVISION
  git commit -m "[TravisCI] Increase Revision file [ci skip]"
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/trinitycore-builds.git 1> /dev/null
  ## The tag is deleted (locally), so that the latest commit for the revision file is included in the tag
  ## When retagging now.
  git tag -d "$GIT_TAG"
  git tag "$GIT_TAG" -a -m "Tag Generated from TravisCI for build $TRAVIS_BUILD_NUMBER" 1>/dev/null
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/trinitycore-builds.git --tags
else 
  echo "Tag already exists!"
fi
