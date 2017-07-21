#!/bin/bash
set -e

# Activate Holy Build Box environment.
source /hbb_exe_gc_hardened/activate

set -x

export REDIS_VER=4.0.0
export REDIS_TAR=redis-${REDIS_VER}.tar.gz

curl -fsSLO http://download.redis.io/releases/${REDIS_TAR}
tar xzf ${REDIS_TAR}

cd redis-${REDIS_VER}

make

cd ..

# for cli

mkdir cli
cd cli

mkdir -p usr/local/bin
cp ../redis-${REDIS_VER}/src/redis-cli usr/local/bin/

cd ..

tar czf cli.tar.gz -C cli .

# for server

curl -fsSLO https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64
chmod +x gosu-amd64
chmod +x docker-entrypoint.sh

mkdir rootfs
cd rootfs

mkdir -p usr/local/bin
cp ../redis-${REDIS_VER}/src/redis-cli usr/local/bin/
cp ../redis-${REDIS_VER}/src/redis-server usr/local/bin/
mv ../gosu-amd64 usr/local/bin/gosu
mv ../docker-entrypoint.sh .

cd ..

tar czf rootfs.tar.gz -C rootfs .

