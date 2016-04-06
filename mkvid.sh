#!/usr/bin/env bash
ffmpeg -f lavfi -i nullsrc=s=1280x720 -framerate 25 -t 60 testvid.flv
