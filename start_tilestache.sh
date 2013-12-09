#!/bin/sh
cp -rf /etc/tilestache_default/tilestache.cfg /etc/tilestache/tilestache.cfg
cp -rf /etc/tilestache_default/mapnik /etc/mapnik
sed -s -i -e "s/localhost/${DB_PORT_5432_TCP_ADDR}/g" /etc/mapnik/*.xml
sed -s -i -e "s/numprocesses = 4/numprocesses = `nproc`/g" /etc/circus.ini
circusd /etc/circus.ini
