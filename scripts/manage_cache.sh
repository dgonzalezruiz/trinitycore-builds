#!/bin/bash
set -e

log() {
    echo "$@" >&2
}

tcd() {
  cd $TRAVIS_BUILD_DIR/$1
}

if [ -z $CASHER_TIME_OUT ] ; then
  log "Either timeout seems to be disabled or the variable was renamed"
  log "Proceeding to work without cache..."
  exit 0
fi

API_RESPONSE=$(curl -X GET \
                    -H "Content-Type: application/json" \
                    -H "Travis-API-Version: 3" \
                    -H "Accept: application/json" \
                    -H "Authorization: token $TRAVIS_API_TOKEN" \
                    'https://api.travis-ci.org/repo/dgonzalezruiz%2Ftrinitycore-builds/caches')

# We calculate how old the cache is by comparing its timestamp
# with the current time
TRAVIS_TIME=$(echo $API_RESPONSE | grep -o "last_modified\": \".*Z\"" | cut -d\" -f3)

if [ ! -z TRAVIS_TIME ] ; then
  # In case there was more than one cache, we only need to know the date of the first
  TRAVIS_TIME=$(echo $TRAVIS_TIME | cut -d" " -f1)  
  TRAVIS_TIMESTAMP=$(date +%s -d $CACHE_TIMER)
  CURRENT_TIMESTAMP=$(date +%s)
  TIME_DIFFERENCE=$(( $CURRENT_TIMESTAMP - $TRAVIS_TIMESTAMP ))
  if [ $TIME_DIFFERENCE -gt $CASHER_TIME_OUT ] ; then
    # Cache must be invalidated
    curl -X DELETE \
         -H "Content-Type: application/json" \
         -H "Travis-API-Version: 3" \
         -H "Accept: application/json" \
         -H "Authorization: token $TRAVIS_API_TOKEN" \
         'https://api.travis-ci.org/repo/dgonzalezruiz%2Ftrinitycore-builds/caches'
  else 
    log "Cache is too young to be executed. Using it..."
  fi
else 
  log "There was no cache found! Proceeding with the execution"
fi


