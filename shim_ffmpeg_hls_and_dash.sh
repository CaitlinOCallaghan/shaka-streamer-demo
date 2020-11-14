#!/bin/bash

vid=$(date '+%m-%d-%y-%T')

# generate test pattern
# ffmpeg \
#     -re \
#     -loglevel debug \
#     -f lavfi -i "testsrc2=size=960x540:rate=30" \
#     -pix_fmt yuv420p \
#     -map 0:v \
#     -c:v libx264 \
#     -g 30 \
#     -keyint_min 30 \
#     -b:v 4000k \
#     -sc_threshold 0 \
#     -f dash \
#     -use_timeline 0 \
#     -index_correction 1 \
#     -seg_duration 1 \
#     -method PUT \
#     -http_persistent 1 \
#     -streaming 0 \
#     -remove_at_exit 1 \
#     -window_size 5 \
#     -extra_window_size 10 \
#     -hls_playlist 1 \
#     -master_pl_name dongs.m3u8 \
#     -utc_timing_url "https://time.akamai.com/?iso" \
#     -adaptation_sets "id=0,streams=v" \
#     http://0.0.0.0:8080/${vid}/manifest.mpd

# Buck Bunny
ffmpeg \
    -re \
    -loglevel debug \
    -i "BigBuckBunny.mp4" \
    -pix_fmt yuv420p \
    -map 0:v \
    -c:v libx264 \
    -g 30 \
    -keyint_min 30 \
    -b:v 4000k \
    -sc_threshold 0 \
    -f dash \
    -use_timeline 0 \
    -index_correction 1 \
    -seg_duration 1 \
    -method PUT \
    -http_persistent 1 \
    -streaming 0 \
    -remove_at_exit 1 \
    -window_size 5 \
    -extra_window_size 10 \
    -hls_playlist 1 \
    -master_pl_name dongs.m3u8 \
    -utc_timing_url "https://time.akamai.com/?iso" \
    -adaptation_sets "id=0,streams=v" \
    http://0.0.0.0:8080/${vid}/manifest.mpd

