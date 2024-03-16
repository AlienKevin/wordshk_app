import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class StoriesCatalogPage extends StatefulWidget {
  const StoriesCatalogPage({Key? key}) : super(key: key);

  @override
  StoriesCatalogPageState createState() => StoriesCatalogPageState();
}

class StoriesCatalogPageState extends State<StoriesCatalogPage> {
  late Future<List<(int, String)>> _storyTitles;

  @override
  void initState() {
    super.initState();
    _storyTitles = _loadStoryTitles();
  }

  Future<List<(int, String)>> _loadStoryTitles() async {
    final String response = await rootBundle.loadString('assets/hbl.json');
    final data = await json.decode(response);
    List<(int, String)> titles = [];
    data.forEach(
        (book_id, book) => titles.add((int.parse(book_id), book['title_C_s'])));
    return titles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Titles'),
      ),
      body: FutureBuilder<List<(int, String)>>(
        future: _storyTitles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  title: Text(item.$2),
                  onTap: () => context.push('/exercise/stories/${item.$1}'),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
