const sensitiveWords = [
  ["文革"],
  ["文化大革命"],
  ["批鬥", "批斗"],
  ["六四"],
  ["雨傘", "雨伞"],
  ["支那"],
  ["中華民國", "中华民国"],
  ["國軍", "国军"],
  ["台灣", "台湾"],
  ["港獨", "港独"],
  ["中港"],
  ["武肺"],
  ["武漢肺炎", "武汉肺炎"],
  ["舐共", "奶共"],
  ["反共"],
  ["媚共"],
  ["強國", "强国"],
];

bool containsSensitiveContent(String text) {
  for (var group in sensitiveWords) {
    for (var word in group) {
      if (text.contains(word)) {
        return true;
      }
    }
  }
  return false;
}
