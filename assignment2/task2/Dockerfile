#Download base image ubuntu 18.04
FROM ubuntu:18.04

# LABEL about the custom image
LABEL maintainer="admin@hotmail.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for \
the Hotmail-Com and Figgle Services."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive


# Update Ubuntu Software repository
RUN apt update

#
# for the simplicity and saving time, put figgle package in the local directory
# and install for now.
#
COPY figgle-pkgpath figgle-pkgpath

RUN apt install -y ./figgle-pkgpath/figgle_0.5.1-1_amd64.deb && \
    apt install -y inetutils-ping && \
    apt remove -y vim* babeltrace* ifconfig* && \
    apt clean
