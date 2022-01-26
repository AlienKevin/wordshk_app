class Entry {
  final int id;
  final List<Variant> variants;

  Entry.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        variants = List.from(json['variants']).map((variant) {
          return Variant.fromJson(variant);
        }).toList();
}

class Variant {
  final String word;
  final String prs;

  Variant.fromJson(Map<String, dynamic> json)
    : word = json['word'],
    prs = json['prs'];
}
