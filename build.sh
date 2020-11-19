#!/bin/bash

sudo apt-get -y update

sudo apt-get -y upgrade

# Dependencies
sudo apt-get -y install \
  awscli \
  build-essential \
  curl \
  ffmpeg \
  git \
  libncurses5 \
  libnginx-mod-http-dav-ext \
  libtinfo5 \
  net-tools \
  nginx \
  nginx-extras \
  ninja-build \
  openssh-server \
  python \
  python3-pip \
  wget 

# Shaka Packager with HTTP upload
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:$PWD/depot_tools"
mkdir shaka_packager
cd shaka_packager
# grab the repo containing the HTTP upload branch
gclient config https://github.com/joeyparrish/shaka-packager.git --name=src --unmanaged
gclient sync
cd src
# build shaka player
ninja -C out/Release
# verify the build
./out/Release/packager --version
# save the binary file to local bin for global use
sudo install -m 755 ./out/Release/packager  /usr/local/bin/packager
cd ../..

# Shaka Streamer with HTTP upload
git clone https://github.com/joeyparrish/shaka-streamer.git
sudo snap install google-cloud-sdk --classic

# install s3-upload-proxy
git clone https://github.com/fsouza/s3-upload-proxy.git
# install go
wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
sudo install -m 755 /usr/local/go/bin/go  /usr/local/bin/go
go version

# install Big Buck Bunny as sample file
wget "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
