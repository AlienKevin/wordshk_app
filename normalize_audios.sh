#!/bin/bash

# working directory is something like: jyutping_female_normalized
# All audio files must be normalized before getting trimmed

outdir="../jyutping_female_normalized_trimmed"
mkdir -p $outdir
for file in *.mp3
do
        outfile="${outdir}/${file}"
        sox $file $outfile silence 1 0.1 -55d reverse silence 1 0.1 -55d reverse
done
