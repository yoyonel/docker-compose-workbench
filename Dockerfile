FROM ubuntu:latest

# initial idea from https://github.com/jdecool/dockerfiles/blob/master/mysql-workbench/Dockerfile
MAINTAINER Guillem Lefait <guillem.lefait@datamq.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get install -qqy \
		x11-apps \
		gnome-keyring \
		mysql-workbench \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# <value type="string" key="dumpdirectory">/data/dumps</value>
# <value type="int" key="DbSqlEditor:SafeUpdates">0</value>

# handle keyring

CMD mysql-workbench