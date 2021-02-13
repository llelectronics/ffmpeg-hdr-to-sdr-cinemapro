#!/bin/bash

# Get the static ffmpeg build for linux that supports libzimg (zscale filter)
# https://johnvansickle.com/ffmpeg/

FFMPEGBIN="/home/leszek/Downloads/ffmpeg-git-20200617-amd64-static/ffmpeg"
VFPARAM="zscale=t=linear:npl=111,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=4,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,eq=gamma=0.8"
VFPARAMORIG="zscale=t=linear:npl=250,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p" 
VFPARAM2084="zscale=t=linear,format=gbrpf32le,zscale=t=smpte2084:p=bt709:m=bt709,format=yuv420p10le"
VFPARAMMPV="zscale=transfer=linear:npl=768,format=gbrpf32le,tonemap=reinhard,zscale=transfer=bt709,format=yuv420p"
VFPARAMIMP="zscale=t=linear:npl=256,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=1,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,eq=gamma=0.9"
$FFMPEGBIN -i "$1" -vf $VFPARAMIMP -c:v libx264 -crf 7 -preset ultrafast "$2" 

# Stabilisation for CinemaPro shaky footage
if [ "$3" == "-ns" || "$4" == "-ns" ]; then
   exit 0;
else
  $FFMPEGBIN -i "$2" -vf vidstabdetect=stepsize=32:shakiness=10:accuracy=10 -f null -
  $FFMPEGBIN -i "$2" -vf vidstabtransform=input=transforms.trf:zoom=0:smoothing=10,unsharp=5:5:0.8:3:3:0.4 -vcodec libx264 -tune film -crf 7 -acodec copy -preset ultrafast "${2::-4}-stabilized.mp4"
fi

# For Youtube Export (16:9 crop and crf 18 [recommended by youtube])
if [ "$3" == "-yt" || "$4" == "-yt" ]; then
  $FFMPEGBIN -i "${2::-4}-stabilized.mp4" -filter:v "crop=ih/9*16:ih" -crf 18 -c:a copy "${2::-4}-stabilized-16-9.mp4"
fi
