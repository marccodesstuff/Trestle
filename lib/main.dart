import 'package:flutter/material.dart';
import 'edit_document_page.dart';
import 'document_model.dart'; // Updated import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trestle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Document> documents = [
    Document(title: 'Document 1', blocks: ['Content of Document 1']),
    Document(title: 'Document 2', blocks: ['Content of Document 2']),
    Document(title: 'Document 3', blocks: ['Content of Document 3']),
    Document(title: 'Document 4', blocks: ['Content of Document 4']),
  ];

  void _addNewDocument() async {
    final newDocument = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDocumentPage(
          document: Document(title: 'New Document', blocks: ['']),
        ),
      ),
    );
    if (newDocument != null) {
      setState(() {
        documents.add(newDocument);
      });
    }
  }

  void _editDocument(int index, Document editedDocument) {
    setState(() {
      documents[index] = editedDocument;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notion Clone'),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(documents[index].title),
            onTap: () async {
              final editedDocument = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDocumentPage(
                    document: documents[index],
                  ),
                ),
              );
              if (editedDocument != null) {
                _editDocument(index, editedDocument);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDocument,
        child: Icon(Icons.add),
        tooltip: 'New Document',
      ),
    );
  }
}