#!/bin/bash

set -e

## Mirrors for CLANG 3.9 enforcement are added
wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
echo "yes" | sudo add-apt-repository 'deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.9 main'

sudo apt-get -qq update

sudo apt-get install clang-3.9

sudo apt-get -qq install build-essential libtool make cmake cmake-data openssl
sudo apt-get  install libssl-dev libmysqlclient-dev libmysql++-dev libreadline6-dev zlib1g-dev libbz2-dev
sudo apt-get -qq install libboost1.55-dev libboost-thread1.55-dev libboost-filesystem1.55-dev libboost-system1.55-dev libboost-program-options1.55-dev libboost-iostreams1.55-dev

## The repository with the source to compile is cloned 
git clone -b 3.3.5 --single-branch https://github.com/TrinityCore/TrinityCore 
