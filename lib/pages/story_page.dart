import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordshk/models/entry.dart';
import 'package:wordshk/widgets/entry/entry_ruby_line.dart';

class StoryPage extends StatefulWidget {
  final int storyId;
  const StoryPage({Key? key, required this.storyId}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late Future<(String, List<dynamic>)> _content;

  @override
  void initState() {
    super.initState();
    _content = _loadStoryContent(widget.storyId);
  }

  Future<(String, List<dynamic>)> _loadStoryContent(int storyId) async {
    final String response = await rootBundle.loadString('assets/hbl.json');
    final data = await json.decode(response);
    List<dynamic> sentences = [];
    late String title;
    data.forEach((book_id, book) {
      if (int.parse(book_id) == storyId) {
        title = book['title_C_s'];
        for (var page in book['pages']) {
          for (var sentence in page['sentences']) {
            sentences.add(sentence);
          }
        }
      }
    });
    return (title, sentences);
  }

  EntryRubyLine glossesToRubyLine(glosses) {
    return EntryRubyLine(
      line: RubyLine(glosses
          .map<RubySegment>((gloss) => RubySegment(
              RubySegmentType.word,
              RubySegmentWord(
                  EntryWord(gloss['chars']
                      .map<EntryText>((char) => EntryText(
                          EntryTextStyle.normal, char['C_s'] as String))
                      .toList()),
                  (gloss['chars'] as List<dynamic>)
                      .map((char) => char['pr'] as String)
                      .toList(),
                  (gloss['chars'] as List<dynamic>)
                      .map((char) => char['pr'].length > 0
                          ? int.parse(
                              char['pr'][char['pr'].length - 1] as String)
                          : 6)
                      .toList())))
          .toList()),
      textColor: Theme.of(context).textTheme.bodyLarge!.color!,
      linkColor: Theme.of(context).textTheme.bodyLarge!.color!,
      rubyFontSize: Theme.of(context).textTheme.bodyLarge!.fontSize! * 1.5,
      onTapLink: null,
      showPrsButton: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(String, List<dynamic>)>(
        future: _content,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Scaffold(
                appBar: AppBar(
                  title: Text(snapshot.data!.$1),
                ),
                body: ListView.builder(
                    itemCount: snapshot.data?.$2.length ?? 0,
                    itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .fontSize!,
                            horizontal: 10),
                        child: glossesToRubyLine(
                            snapshot.data!.$2[index]['glosses']))));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
