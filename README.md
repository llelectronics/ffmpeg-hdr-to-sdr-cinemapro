# Description

A small script that uses ffmpeg to convert CinemaPro video material produced by the Sony Xperia 1 & 5 aswell as 1 II & 5 II from HDR to SDR. It also stabilises the video material as CinemaPro only has a very weak electronic image stabilisation.  

# Usage
Execute in a terminal (bash) 
./sony-hdr-hlg-to-sdr.sh <sourcefile> <targetfile> [-yt] [-ns]

sourcefile path to the cinemapro video file (e.g. /home/leszek/MOV_CINEMA_CLIP_002_20210209200355935.mp4)
targetfile path to the targetfile (it will create 2 files by default a color graded file and a color graded and stabilised file)
-yt option is for 16:9 cropped youtube ready video (creates a 3 file)
-ns don't create stabilisation video file

## For Linux

I recommend static ffmpeg builds that feature libzimg (zscale filter) support.
https://johnvansickle.com/ffmpeg/


