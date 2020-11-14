#!/bin/bash

# set arguments
driverType="mediastore" # specify "mediastore" or "s3"
bucketName="dropbears"
awsEndpoint="https://jzw2ldnc6rzikp.data.mediastore.us-west-2.amazonaws.com"
vid=$(date '+%M%S')

rm pipe0
mkfifo pipe0

# start shim
sudo pkill s3-upload-proxy
export LOG_LEVEL=debug UPLOAD_DRIVER=${driverType} REGION_NAME=us-west-2  BUCKET_NAME=${bucketName} HTTP_PORT=8080
go build -o s3-upload-proxy
./s3-upload-proxy &

# generate player
cat > /tmp/${vid}.html <<_PAGE_
<!doctype html>
<html>
   <head>
   <body>
      <style>
         body {
         background-color : black;
         margin : 0;
         }
         video {
         left: 50%;
         position: absolute;
         top: 50%;
         transform: translate(-50%, -50%);
         width: 100%;
         max-height: 100%;
         }
      </style>
  </head>
    <!-- Shaka Player compiled library: -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/shaka-player/3.0.5/shaka-player.compiled.js"></script>
    <!-- Your application source: -->
    <script src="${vid}.js"></script>
  </head>
  <body>
    <video id="video"
           width="640"
           controls autoplay></video>
   </body>
</html>
_PAGE_

cat > /tmp/${vid}.js <<_JS_
const manifestUri =
    '${vid}.mpd';

function initApp() {
  // Install built-in polyfills to patch browser incompatibilities.
  shaka.polyfill.installAll();

  // Check to see if the browser supports the basic APIs Shaka needs.
  if (shaka.Player.isBrowserSupported()) {
    // Everything looks good!
    initPlayer();
  } else {
    // This browser does not have the minimum set of APIs we need.
    console.error('Browser not supported!');
  }
}

async function initPlayer() {
  // Create a Player instance.
  const video = document.getElementById('video');
  const player = new shaka.Player(video);

  // Attach player to the window to make it easy to access in the JS console.
  window.player = player;

  // Listen for error events.
  player.addEventListener('error', onErrorEvent);

  // Try to load a manifest.
  // This is an asynchronous process.
  try {
    await player.load(manifestUri);
    // This runs if the asynchronous load is successful.
    console.log('The video has now been loaded!');
  } catch (e) {
    // onError is executed if the asynchronous load fails.
    onError(e);
  }
}

function onErrorEvent(event) {
  // Extract the shaka.util.Error object from the event.
  onError(event.detail);
}

function onError(error) {
  // Log the error.
  console.error('Error code', error.code, 'object', error);
}

document.addEventListener('DOMContentLoaded', initApp);
_JS_

# Upload the player over HTTP PUT to the origin server
# NOTE: ensure that the endpoint is to your specific bucket/container
aws mediastore-data put-object --endpoint ${awsEndpoint} --body /tmp/${vid}.html --path ${vid}.html --cache-control "max-age=6, public" --content-type text/html --region us-west-2
aws mediastore-data put-object --endpoint ${awsEndpoint} --body /tmp/${vid}.js --path ${vid}.js --cache-control "max-age=6, public" --content-type text/javascript --region us-west-2


# encode with ffmpeg
x264enc='libx264 -tune zerolatency -profile:v high -preset ultrafast -bf 0 -refs 3 -sc_threshold 0'

ffmpeg \
    -hide_banner \
    -re \
    -i "../shaka-streamer-demo/BigBuckBunny.mp4" \
    -pix_fmt yuv420p \
    -map 0:v \
    -c:v ${x264enc} \
    -g 30 \
    -keyint_min 30 \
    -b:v 4000k \
    -f mpegts \
    pipe: > pipe0 &

# package as dash
packager \
   --io_block_size 65536 \
   in=pipe0,stream=video,init_segment='http://0.0.0.0:8080/'${vid}'_live_video_init.mp4',segment_template='http://0.0.0.0:8080/'${vid}'_live_video_$Number$.m4s' \
   --mpd_output "http://0.0.0.0:8080/${vid}.mpd"

rm pipe0