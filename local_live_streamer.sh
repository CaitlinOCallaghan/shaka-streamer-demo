#!/bin/bash
./shaka-streamer/shaka-streamer \
    --skip_deps_check \
    -i input_looped_file_config.yaml \
    -p pipeline_live_config.yaml \
    -o local_playout_output 
