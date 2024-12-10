// Suggested code may be subject to a license. Learn more: ~LicenseLog:1422427754.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:785353042.
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
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 600
                        ? 3
                        : constraints.maxWidth > 400
                            ? 2
                            : 1;
                    return GridView.count(
                  shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                      crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                  children: const [
                    NoteCard(title: 'Note 1', content: 'Content for Note 1'),
                    NoteCard(title: 'Note 2', content: 'Content for Note 2'),
                    // ... other notes
                  ],
                    );
                  },
                )
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}
