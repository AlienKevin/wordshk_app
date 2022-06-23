#!/bin/bash

# working directory is something like: jyutping_female_normalized
# All audio files must be normalized before getting trimmed

outdir="../trimmed_audio"
mkdir -p $outdir
for file in *.mp3
do
        outfile="${outdir}/${file}"
        # Source: https://stackoverflow.com/a/72426502/6798201
        sox $file $outfile silence 1 0.1 -55d reverse silence 1 0.1 -55d reverse
done
