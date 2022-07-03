#!/bin/bash

# current working directory must be one of jyutping_female or jyutping_male
# All audio files must be normalized in Adobe Audition before getting trimmed

for file in *.mp3
do
        # Trim Silence source: https://stackoverflow.com/a/72426502/6798201
        # Normalization source: https://madskjeldgaard.dk/posts/sox-tutorial-batch-processing/#normalize
        sox "$file" "$file" silence 1 0.1 -55d reverse silence 1 0.1 -55d reverse
        if [[ $file =~ .*[ptk]1.mp3 ]]; then
           sox "$file" "$file" norm -0.1
        fi
        # Add some silence padding after jap6sing1 syllables
        # 0.364s is the "typical" length of a jap6sing1 tone 3 syllable, like jat3
        # It is shorter than an open vowel like aa1 but it aligns well with other
        # jap6sing1 syllables.
        len=$(soxi -D "$file")
        if (( $(echo "$len < 0.364" |bc -l) )); then
          diff=$(echo "0.364 - $len" |bc -l)
          sox "$file" "$file" pad 0 "$diff"
        fi
done
