import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'documents_page.dart';
import 'settings_screen.dart';
import '../models/document_model.dart';
import '../utils/appwrite.dart';
import '../models/block_model.dart'; // Adjust the path as necessary

class HomeScreen extends StatelessWidget {
  final AppwriteService appwriteService = AppwriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () async {
                try {
                  await appwriteService.logOutUser();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  print('Logout failed: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Home Screen Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final sampleDocument = Document(
            title: 'Sample Document',
            blocks: [
              Block.textBlock('Sample Text Block', 0),
              Block.imageBlock('https://via.placeholder.com/150', 1),
            ],
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentPage(document: sampleDocument),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}