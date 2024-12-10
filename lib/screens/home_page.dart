import 'package:flutter/material.dart';
import '../widgets/note_card.dart';
import '../widgets/main_sidenav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Static list of notes for demonstration purposes
    final List<Map<String, String>> notes = [
      {'title': 'Note 1', 'content': 'Content for Note 1'},
      {'title': 'Note 2', 'content': 'Content for Note 2'},
      {'title': 'Note 3', 'content': 'Content for Note 3'},
      {'title': 'Note 4', 'content': 'Content for Note 4'},
      {'title': 'Note 5', 'content': 'Content for Note 5'},
      {'title': 'Note 6', 'content': 'Content for Note 6'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trestle'),
      ),
      drawer: const SideNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recents',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.5,
                children: notes.map((note) {
                  return NoteCard(
                    title: note['title']!,
                    content: note['content']!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
