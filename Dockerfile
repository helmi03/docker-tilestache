FROM ubuntu:12.04

#! mapnik2.2 don't like libgeos version from postgis2.1
#! libgeos-c1 (= 3.2.2-3ubuntu1) but 3.3.3-1.1~pgdg12.4+1 is to be installed
#! FROM helmi03/postgis:2.1

MAINTAINER Helmi <helmi03@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y -q python-software-properties python-pip libzmq-dev
RUN add-apt-repository -y ppa:mapnik/v2.2.0
RUN apt-get update
RUN apt-get install -y -q libmapnik libmapnik-dev mapnik-utils python-mapnik
RUN pip install -q https://github.com/helmi03/TileStache/tarball/master
RUN pip install circus chaussette gevent
# when use PIL="decoder zip not available"
# Can use this workaround, but testing Pillow for now
# http://obroll.com/install-python-pil-python-image-library-on-ubuntu-11-10-oneiric/
RUN pip uninstall -y PIL
RUN pip install Pillow

ADD circus.ini /etc/circus.ini
ADD tilestache.cfg /etc/tilestache.cfg
ADD app.py /app.py

EXPOSE 9999

#!-- Docker have problem with upstart
#! ADD circus.cont /etc/init/circus.conf
#! CMD ["start", "circus"]

CMD ["circusd", "/etc/circus.ini"]
