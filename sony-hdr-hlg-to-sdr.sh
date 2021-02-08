#!/bin/bash

# Get the static ffmpeg build for linux that supports libzimg (zscale filter)

FFMPEGBIN="/home/leszek/Downloads/ffmpeg-git-20200617-amd64-static/ffmpeg"
VFPARAM="zscale=t=linear:npl=111,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,eq=gamma=0.7"
VFPARAMORIG="zscale=t=linear:npl=250,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p" 
VFPARAM2084="zscale=t=linear,format=gbrpf32le,zscale=t=smpte2084:p=bt709:m=bt709,format=yuv420p10le"
$FFMPEGBIN -i "$1" -vf $VFPARAM -c:v libx264 -crf 10 -preset ultrafast "$2" 

# Stabilisation for CinemaPro shaky footage

$FFMPEGBIN -i "$2" -vf vidstabdetect=stepsize=32:shakiness=10:accuracy=10 -f null -
$FFMPEGBIN -i "$2" -vf vidstabtransform=input=transforms.trf:zoom=0:smoothing=10,unsharp=5:5:0.8:3:3:0.4 -vcodec libx264 -tune film -acodec copy -preset ultrafast "${2::-4}-stabilized.mp4"

