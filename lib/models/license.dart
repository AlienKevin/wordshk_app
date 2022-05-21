class License {
  final String title;
  final String text;

  const License(this.title, this.text);

  License.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        text = json['text'];
}
