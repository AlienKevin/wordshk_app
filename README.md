# wordshk

words.hk dictionary for Android and iOS

<img alt='wordshk app logo' src='assets/icon.png' style='width: 150px'>

# Download

<a href="https://apps.apple.com/us/app/words-hk-%E7%B2%B5%E5%85%B8/id1621976909?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 180px"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1657756800&h=1600d970c262d2b70ad557b308a2154b" alt="Download on the App Store" style="border-radius: 13px; width: 200px; height: 95px;"></a>
<a href='https://play.google.com/store/apps/details?id=hk.words.wordshk&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height="80"/></a>
<a href="https://f-droid.org/repository/browse/?fdid=hk.words.wordshk"><img alt="Get it on F-Droid" height="80" src="https://f-droid.org/badge/get-it-on.png"/></a>

# Generate Rust Bindings
```
# Follow the flutter_rust_bridge version in pubspec.yaml
cargo install 'flutter_rust_bridge_codegen@^2.0.0-dev.11'
flutter_rust_bridge_codegen generate
```

# Normalize jyutping syllable audios

1. Open Adobe Audition, run the "Match Loudness" with these settings:
   
   * ITU-R BS.1770-3 Loudness
   * Target Loudness: -16 LUFS
   * Tolerance: 2 LU
   * Max True Peak Level: -2 dBTP
   * Look-ahead Time: 12ms
   * Release Time: 200ms

2. Export the files with matched loudness
   With export settings as follows:
   
   * Format MP3
   * Sample Type: Same as source
   * Format settings: MP3 24 Kbps CBR (Constant type)

3. Change directory into `assets/jyutping_female` or `assets/jyutping_male`.

4. Run `process_audios.sh`. This script does three things:
   
   1. Trim silence at the beginning and end of all mp3 files
   2. Pad the end of jap6sing1 syllables so they are not too short
   3. Peak normalize jap6sing1 syllables to make they as loud as other syllables

# Legal

Software: Copyright (C) 2022 Xiang Li, licensed under the MIT license.
Dictionary: Copyright (C) 2014-2022 Hong Kong Lexicography Limited.

"*words.hk*", "*wordshk*", "*粵典*" are trade names of Hong Kong Lexicography
Limited. Permission by Hong Kong Lexicography Limited must be obtained to
promote or distribute materials containing these names. In particular,
notwithstanding any permission (if applicable) to redistribute the source code
of this project and/or its derivative works by the copyright owner(s), unless
you obtain explicit permission from Hong Kong Lexicography Limited, you are
required to remove all mentions of "*words.hk*", "*wordshk*", "*粵典*" from
your redistributions.

The dictionary contents published by words.hk is copyrighted by Hong Kong
Lexicography Limited. You may be eligible to obtain a license from
https://words.hk/base/hoifong/
