#!/bin/bash

mkfifo pipe0

x264enc='libx264 -tune zerolatency -profile:v high -preset veryfast -bf 0 -refs 3 -sc_threshold 0'

ffmpeg/ffmpeg \
    -hide_banner \
    -re \
    -f lavfi \
    -i "testsrc2=size=1920x1080:rate=30" \
    -pix_fmt yuv420p \
    -map 0:v \
    -c:v ${x264enc} \
    -g 60 \
    -keyint_min 150 \
    -b:v 4000k \
    -vf "fps=30,drawtext=fontfile=utils/OpenSans-Bold.ttf:box=1:fontcolor=black:boxcolor=white:fontsize=100':x=40:y=400:textfile=utils/text.txt" \
    -f mpegts \

packager \
    "in=pipe0,stream=video,output=http://0.0.0.0/dongs_1080p.mp4" \
    --mpd_output "http://0.0.0.0/dongofest.mpd"

rm pip0
