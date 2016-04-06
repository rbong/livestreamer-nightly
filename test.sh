#!/usr/bin/env bash
echo "starting ffmpeg in background..."
(ffmpeg -loglevel warning -f lavfi -i nullsrc=s=1280x720 -framerate 25 -t 60 -f flv "rtmp://broadcast.castamp.com/live/livestreamer_yp5bta" 2>&1 | while read line; do echo "[FFMPEG]" $line; done) && echo "...ffmpeg exited with code $?." &
echo "starting livestreamer..."
ret=$(livestreamer "http://www.castamp.com/embed.php?c=livestreamer" best -QO)
stat=$?
echo "...livestreamer exited with code $?."
if (( $stat )); then exit $stat; fi
echo "counting bytes..."
bytes=$(echo "$ret" | wc -c | sed 's/^ *//g')
echo "...$bytes bytes read from stream."
if (( "$bytes" < 1000 )); then exit 1; fi
exit 0