#!/bin/bash

# sed extracts the filename at the end of the path
# cut removes the file extension ".mp3" from the filename
syllable_name_list=$(find assets/jyutping_female -depth 1 | sed "s/.*\///" | cut -f 1 -d '.')

delim=""
joined_names=""
for syllable_name in ${syllable_name_list}; do
  joined_names="$joined_names$delim\"$syllable_name\""
  delim=", "
done

# Generate a set literal and append it to constants.dart
echo "const jyutpingFemaleSyllableNames = {$joined_names};" >> lib/constants.dart
