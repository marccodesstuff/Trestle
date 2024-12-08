import 'package:flutter/material.dart';

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
            child: ListTile(
              title: Text(document.name),
              subtitle: Text(document.description),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle button press
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