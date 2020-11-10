#!/bin/bash

sudo apt -y install

sudo apt -y update

sudo apt -y upgrade

# Dependencies
sudo apt-get -y install -f \
  awscli \ 
  build-essential \
  curl \
  ffmpeg \
  git \
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
gclient config https://github.com/termoose/shaka-packager.git --name=src --unmanaged
# checkout the most recent commit from the "http-upload" branch
gclient sync -r 526bb8857781a361865e4dbf1a39853cf47fa1cd
cd src
# build shaka player
ninja -C out/Release
# verify the build
./packager --version
# save the binary file to local bin for global use
sudo install -m 755 ./out/Release/packager  /usr/local/bin/packager
cd ../..

# Shaka Streamer with HTTP upload on master branch
git clone https://github.com/joeyparrish/shaka-streamer.git
sudo snap install google-cloud-sdk --classic

# install Big Buck Bunny as sample file
# wget "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

# Dash JS
# wget https://github.com/Dash-Industry-Forum/dash.js/archive/v3.1.3.zip
# unzip v3.1.3.zip 
# rm -rf v3.1.3.zip

# Video JS
# wget https://github.com/videojs/video.js/releases/download/v7.10.1/video-js-7.10.1.zip
# mkdir video-js-7.10.1
# unzip video-js-7.10.1.zip -d video-js-7.10.1
# rm -rf video-js-7.10.1.zip