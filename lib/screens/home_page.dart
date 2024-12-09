import 'package:Trestle/screens/docs.dart';
import 'package:flutter/material.dart';
import '../utils/appwrite_client.dart';

class HomePage extends StatelessWidget {
  final List<Document> documents = [
    Document(name: 'Document 1', description: 'Description 1'),
    Document(name: 'Document 2', description: 'Description 2'),
    // Add more documents here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents'),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return Card(
            child: InkWell(
              onTap: () {
                // Handle the tap event here
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
}

class Document {
  final String name;
  final String description;

  Document({required this.name, required this.description});
}
