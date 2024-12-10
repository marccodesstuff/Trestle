import 'package:flutter/material.dart';

import '../widgets/note_card.dart';
import '../widgets/main_sidenav.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;

  const WelcomeScreen({super.key, required this.userName});

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
            Center(
              child: Text(
                'Welcome to Trestle, $userName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Recent Notes Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recents',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                  children: const [
                    NoteCard(title: 'Note 1', content: 'Content for Note 1'),
                    NoteCard(title: 'Note 2', content: 'Content for Note 2'),
                    // ... other notes
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
