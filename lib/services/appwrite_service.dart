import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Import for JSON encoding

class ImageBlockWut extends StatelessWidget {
  final String imageUrl;

  ImageBlockWut({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl);
  }
}

class AppWriteService {
  Future<void> saveNewDocument(String documentTitle, List<Widget> blocks) async {
    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject('675448ef003e37a9488a');
    final _databases = Databases(client);
    try {
      print('Starting to save document: $documentTitle');

      // Convert blocks to a format suitable for storage
      List<Map<String, dynamic>> blockData = blocks.map<Map<String, dynamic>>((block) {
        if (block is TextField) {
          return {
            'type': 'text',
            'content': (block.controller as TextEditingController).text,
          };
        } else if (block is ImageBlockWut) {
          return {
            'type': 'image',
            'url': (block as ImageBlockWut).imageUrl,
          };
        }
        return {};
      }).toList();

      // Convert block data to JSON string
      String blockDataJson = jsonEncode(blockData);
      print('Block data JSON: $blockDataJson');

      try {
        await _databases.createDocument(
          databaseId: 'trestle_notes',
          collectionId: 'trestle_docs',
          documentId: ID.unique(), // Generate a unique ID
          data: {
            'id': ID.unique().toString(),
            'title': documentTitle,
            'content': blockDataJson,
            'date_created': DateTime.now().toIso8601String(),
            'date_updated': DateTime.now().toIso8601String(),
          },
        );
      } catch (e) {
        print('Error creating document: $e');
      }

      print('Document saved successfully: $documentTitle');
    } catch (e) {
      print('Error saving document: $e');
    }
  }

  // I'll figure out how to implement this later
  Future<void> saveOldDocument(String documentTitle, List<Widget> blocks) async {
    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject('675448ef003e37a9488a');
    final _databases = Databases(client);
    try {
      print('Starting to save document: $documentTitle');

      // Convert blocks to a format suitable for storage
      List<Map<String, dynamic>> blockData = blocks.map<Map<String, dynamic>>((block) {
        if (block is TextField) {
          return {
            'type': 'text',
            'content': (block.controller as TextEditingController).text,
          };
        } else if (block is ImageBlockWut) {
          return {
            'type': 'image',
            'url': (block as ImageBlockWut).imageUrl,
          };
        }
        return {};
      }).toList();

      // Convert block data to JSON string
      String blockDataJson = jsonEncode(blockData);
      print('Block data JSON: $blockDataJson');

      try {
        await _databases.createDocument(
          databaseId: 'trestle_notes',
          collectionId: 'trestle_docs',
          documentId: ID.unique(), // You must have the document ID for this one
          data: {
            'id': ID.unique().toString(),
            'title': documentTitle,
            'content': blockDataJson,
            'date_created': DateTime.now().toIso8601String(), // This one is not needed since it's an old document
            'date_updated': DateTime.now().toIso8601String(),
          },
        );
      } catch (e) {
        print('Error creating document: $e');
      }

      print('Document saved successfully: $documentTitle');
    } catch (e) {
      print('Error saving document: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecentDocuments() async {
    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject('675448ef003e37a9488a');
    final _databases = Databases(client);
    try {
      final response = await _databases.listDocuments(
        databaseId: 'trestle_notes',
        collectionId: 'trestle_docs',
        queries: [Query.orderDesc('date_updated'), Query.limit(10)], // Fetch the 10 most recently updated documents
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error fetching recent documents: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchDocumentById(String documentId) async {
    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject('675448ef003e37a9488a');
    final _databases = Databases(client);
    try {
      final response = await _databases.getDocument(
        databaseId: 'trestle_notes',
        collectionId: 'trestle_docs',
        documentId: documentId,
      );
      return response.data;
    } catch (e) {
      print('Error fetching document: $e');
      return null;
    }
  }
}
