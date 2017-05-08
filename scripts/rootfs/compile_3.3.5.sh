#!/bin/bash


log() {
    echo "$@" >&2
}

mkdir -p /TrinityCore/bin && cd /TrinityCore/bin

log "=============================="
log "Configuring the compilation..."
cmake ../ -DWITH_WARNINGS=1 -DWITH_COREDEBUG=0 -DUSE_COREPCH=1 -DUSE_SCRIPTPCH=1 -DTOOLS=1 -DSERVERS=1 -DNOJEM=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-Werror" -DCMAKE_CXX_FLAGS="-Werror" -DCMAKE_INSTALL_PREFIX=/trinitycore
log "=============================="

## Checking CXX version
log "$CXX --version"

cd /TrinityCore/bin
log "========================="
log "Performing compilation..."
make -j 8 -k && make install
log "========================="
