import 'package:flutter/material.dart';
import '../widgets/note_card.dart';
import '../widgets/main_sidenav.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Favorites',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  // Replace with your actual favorites data
                  NoteCard(
                    title: 'Favorite Document 1',
                    content: 'Brief description of the document',
                  ),
                  NoteCard(
                    title: 'Favorite Document 2',
                    content: 'Brief description of the document',
                  ),
                  // ... more DocumentCard widgets
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}