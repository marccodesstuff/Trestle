import 'package:flutter/material.dart';
import 'edit_document_page.dart';
import 'document_model.dart';
import 'document_storage.dart';
import 'block_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trestle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Document> documents = [];

  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    final document = await loadDocument();
    setState(() {
      documents.add(document);
    });
  }

  void _addNewDocument() async {
    final newDocument = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDocumentPage(
          document: Document(title: 'New Document', blocks: [Block(type: 'text', content: '')], fonts: ['Roboto']),
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
        title: const Text('Notion Clone'),
      ),
      body: documents.isEmpty
          ? Center(child: Text('No documents available'))
          : ListView.builder(
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
                setState(() {
                  documents[index] = editedDocument;
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDocument = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditDocumentPage(
                document: Document(title: 'New Document', blocks: [Block(type: 'text', content: '')], fonts: ['Roboto']),
              ),
            ),
          );
          if (newDocument != null) {
            setState(() {
              documents.add(newDocument);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}