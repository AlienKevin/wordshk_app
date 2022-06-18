#!/bin/bash

for gender in "male" "female"; do
  # sed extracts the filename at the end of the path
  # cut removes the file extension ".mp3" from the filename
  syllable_name_list=$(find "assets/jyutping_$gender" -depth 1 | sed "s/.*\///" | cut -f 1 -d '.')

  delim=""
  joined_names=""
  for syllable_name in ${syllable_name_list}; do
    joined_names="$joined_names$delim\"$syllable_name\""
    delim=", "
  done

  # source: https://stackoverflow.com/a/12487465/6798201
  genderCapitalized="$(tr '[:lower:]' '[:upper:]' <<< "${gender:0:1}")${gender:1}"

  # Generate a set literal and append it to constants.dart
  echo "const jyutping${genderCapitalized}SyllableNames = {$joined_names};" >> lib/constants.dart
done
