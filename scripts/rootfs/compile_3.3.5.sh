#!/bin/bash


log() {
    echo "$@" >&2
}

mysql -uroot -e 'create database test_mysql;'

## A DB is created for Travis testing purposes
mkdir -p /TrinityCore/bin && cd /TrinityCore/bin

log "=============================="
log "Configuring the compilation..."
cmake ../ -DWITH_WARNINGS=1 -DWITH_COREDEBUG=0 -DUSE_COREPCH=1 -DUSE_SCRIPTPCH=1 -DTOOLS=1 -DSERVERS=1 -DNOJEM=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-Werror" -DCMAKE_CXX_FLAGS="-Werror" -DCMAKE_INSTALL_PREFIX=/trinitycore
log "=============================="

cd /TrinityCore && chmod +x contrib/check_updates.sh

## Checking CXX version
log "$CXX --version"

## Perforning full set up of databases for testing purposes
mysql -uroot < sql/create/create_mysql.sql
mysql -utrinity -ptrinity auth < sql/base/auth_database.sql
./contrib/check_updates.sh auth 3.3.5 auth
mysql -utrinity -ptrinity characters < sql/base/characters_database.sql
./contrib/check_updates.sh characters 3.3.5 characters
mysql -utrinity -ptrinity world < sql/base/dev/world_database.sql
cat sql/updates/world/3.3.5/*.sql | mysql -utrinity -ptrinity world
mysql -uroot < sql/create/drop_mysql.sql

cd /TrinityCore/bin
log "========================="
log "Performing compilation..."
make -j 8 -k && make install
log "========================="