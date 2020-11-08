#!/bin/bash

sudo apt install -f

sudo apt update

sudo apt upgrade

# Dependencies
sudo apt-get -y install -f \
  build-essential \
  curl \
  ffmpeg \
  git \
  libtinfo5 \
  net-tools \
  nginx \
  ninja-build \
  python \
  python3-pip \
  wget 

# Shaka Packager release version
wget https://github.com/google/shaka-packager/releases/download/v2.4.3/packager-linux
# save the binary file to local bin for global use
sudo install -m 755 ./packager-linux  /usr/local/bin/packager

# Shaka Streamer on master branch
git clone https://github.com/google/shaka-streamer.git
sudo snap install google-cloud-sdk --classic

# install Big Buck Bunny as sample file
wget "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

# Dash JS
wget https://github.com/Dash-Industry-Forum/dash.js/archive/v3.1.3.zip
unzip v3.1.3.zip 
rm -rf v3.1.3.zip

# Video JS
wget https://github.com/videojs/video.js/releases/download/v7.10.1/video-js-7.10.1.zip
mkdir video-js-7.10.1
unzip video-js-7.10.1.zip -d video-js-7.10.1
rm -rf video-js-7.10.1.zip