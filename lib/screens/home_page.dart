import 'package:Trestle/screens/docs.dart';
import 'package:flutter/material.dart';
import '../utils/appwrite_client.dart';
import 'auth_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final List<Document> documents = [
    Document(name: 'Document 1', description: 'Description 1'),
    Document(name: 'Document 2', description: 'Description 2'),
    // Add more documents here
  ];

  Future<String?> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
          Expanded(
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DocsScreen()),
                      );
                    },
                    child: ListTile(
                      title: Text(document.name),
                      subtitle: Text(document.description),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DocsScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Document',
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class Document {
  final String name;
  final String description;

  Document({required this.name, required this.description});
}
