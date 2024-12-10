import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../models/note.dart';

class AppWriteService {
  late Client client;
  late Databases databases;

  AppWriteService() {
    client = Client()
      ..setEndpoint('https://[YOUR_APPWRITE_ENDPOINT]')
      ..setProject('675448ef003e37a9488a');

    databases = Databases(client);
  }

  Future<Note> createNote(String title, String content) async {
    final response = await databases.createDocument(
      databaseId: 'trestle_notes',
      collectionId: 'trestle_docs',
      documentId: 'unique()',
      data: {
        'title': title,
        'content': content,
        'date_created': DateTime.now().toIso8601String(),
        'date_updated': DateTime.now().toIso8601String(),
      },
    );

    return Note.fromMap(response.data);
  }

  Future<List<Note>> getNotes() async {
    final response = await databases.listDocuments(
      databaseId: 'trestle_notes',
      collectionId: 'trestle_docs',
    );

    return response.documents.map((doc) => Note.fromMap(doc.data)).toList();
  }

  Future<Note> updateNote(String id, String title, String content) async {
    final response = await databases.updateDocument(
      databaseId: 'trestle_notes',
      collectionId: 'trestle_docs',
      documentId: id,
      data: {
        'title': title,
        'content': content,
        'date_updated': DateTime.now().toIso8601String(),
      },
    );

    return Note.fromMap(response.data);
  }

  Future<void> deleteNote(String id) async {
    await databases.deleteDocument(
      databaseId: 'trestle_notes',
      collectionId: 'trestle_docs',
      documentId: id,
    );
  }
}