#!/bin/bash

log() {
    echo "$@" >&2
}

tcd() {
  cd $TRAVIS_BUILD_DIR/$1
}

set -e

if [ ! -f $TRAVIS_BUILD_DIR/trinitycore/bin/worldserver ] ; then 
  ## This folder is created in case it does not exist before. The compilation will be released here
  tcd 
  mkdir -p $TRAVIS_BUILD_DIR/trinitycore
  docker build --tag buildEnvironment . 
  docker run -it -v $TRAVIS_BUILD_DIR/TrinityCore:/TrinityCore -v $TRAVIS_BUILD_DIR/trinitycore:/trinitycore buildEnvironment 
else 
  log "======================================================"
  log "Skipping compilation as a cached compilation was found"
  log "======================================================"
fi

tcd trinitycore/bin
./worldserver --version
./authserver --version
