import 'package:flutter/material.dart';

class EntryNotPublishedPage extends StatelessWidget {
  String entryVariant;

  EntryNotPublishedPage({Key? key, required this.entryVariant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Not Published'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                  'The entry "$entryVariant" is not yet published. Our volunteers are improving and reviewing this entry to ensure its integrity.'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to first route when tapped.
                  Navigator.pop(context);
                },
                child: const Text('Go back'),
              ),
            ],
          )),
    );
  }
}
