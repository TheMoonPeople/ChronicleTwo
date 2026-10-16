# Standard movie fixtures

These small fixtures are generated test patterns and sine waves; they contain no game data. They exercise self-contained MP4 playback and replacement through datapacks.

Both files contain three 16×16 pictures at 25 fps and 0.12 seconds of mono 48 kHz audio. `movie.mp4` uses MPEG-2 video and lossless ALAC audio; `movie_h264_aac.mp4` uses H.264 and AAC to exercise common replacement codecs.

Generate with a full FFmpeg build:

```sh
ffmpeg -f lavfi -i 'testsrc2=size=16x16:rate=25:duration=0.12' \
  -f lavfi -i 'sine=frequency=1000:sample_rate=48000:duration=0.12' \
  -c:v mpeg2video -bf 0 -c:a alac -fflags +bitexact -flags +bitexact \
  -map_metadata -1 -movflags +faststart movie.mp4
ffmpeg -f lavfi -i 'testsrc2=size=16x16:rate=25:duration=0.12' \
  -f lavfi -i 'sine=frequency=1000:sample_rate=48000:duration=0.12' \
  -c:v libopenh264 -c:a aac -fflags +bitexact \
  -map_metadata -1 -movflags +faststart movie_h264_aac.mp4
```
