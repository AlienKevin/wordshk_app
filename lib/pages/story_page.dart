import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.$2[index]['C']),
                      subtitle: Text(snapshot.data!.$2[index]['E']),
                    );
                  },
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
