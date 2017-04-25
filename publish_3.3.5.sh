#!/bin/bash

set -e

tcd() {
  cd "$TRAVIS_BUILD_DIR"/"$1"
}

NEW_TRINITYCORE_REVISION=$((`cat $TRAVIS_BUILD_DIR/TRINITYCORE_NAMI_REVISION` + 1))
echo "$NEW_TRINITYCORE_REVISION" > "$TRAVIS_BUILD_DIR"/TRINITYCORE_NAMI_REVISION

export GIT_TAG=`cat $TRAVIS_BUILD_DIR/TRINITYCORE_NAMI_VERSION`-r`cat $TRAVIS_BUILD_DIR/TRINITYCORE_NAMI_REVISION`

tcd "TrinityCore/bin"
tar vczf trinitycore-"$GIT_TAG".tar.gz trinitycore
mv trinitycore-*.tar.gz "$TRAVIS_BUILD_DIR"

git config --global user.email "builds@travis-ci.com"
git config --global user.name "Travis CI"
git fetch --tags

cd "$TRAVIS_BUILD_DIR"

git checkout $TRAVIS_BRANCH

if git tag "$GIT_TAG" -a -m "Tag Generated from TravisCI for build $TRAVIS_BUILD_NUMBER" 2>/dev/null ; then 
  git add TRINITYCORE_NAMI_REVISION
  git commit -m "[TravisCI] Increase Revision file [ci skip]" 
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/trinitycore-builds.git --follow-tags 1> /dev/null
else 
  echo "Tag already exists!"
fi
