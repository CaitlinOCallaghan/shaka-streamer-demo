#!/bin/bash
./shaka-streamer/shaka-streamer -i input_looped_file_config.yaml -p pipeline_live_config.yaml -o s3_output -c s3://shaka-streamer