#!/bin/sh
YOUTUBE_LINK=$1
CLIP_START=$2
CLIP_END=$3

rm -rf clip.mp4
youtube-dl -f 'bestvideo[ext=mp4]' --output 'clip.mp4' $YOUTUBE_LINK

# cut the first n seconds
ffmpeg -y -loglevel info -i clip.mp4 -ss $CLIP_START -to $CLIP_END -async 1 -strict -2 video.mp4
# detect poses on the these n seconds
rm openpose.avi
cd openpose && ./build/examples/openpose/openpose.bin --video ../video.mp4 --write_json ./output/ --display 0  --write_video ../openpose.avi
# convert the result into MP4
ffmpeg -y -loglevel info -i ../openpose.avi output.mp4

echo "OpenPose video processing complete."