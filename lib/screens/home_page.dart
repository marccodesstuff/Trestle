import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';
import '../widgets/note_card.dart';
import '../widgets/main_sidenav.dart';
import 'edit_document_page.dart';

class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({super.key, required this.userName});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AppWriteService _appWriteService = AppWriteService();
  List<Map<String, dynamic>> _recentDocuments = [];

  @override
  void initState() {
    super.initState();
    _fetchRecentDocuments();
  }

  Future<void> _fetchRecentDocuments() async {
    final documents = await _appWriteService.fetchRecentDocuments();
    setState(() {
      _recentDocuments = documents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trestle'),
      ),
      drawer: const SideNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Welcome to Trestle, ${widget.userName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Recents', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _recentDocuments.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recentDocuments.length,
                      itemBuilder: (context, index) {
                        final document = _recentDocuments[index];
                        return NoteCard(
                          title: document['title'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDocumentPage(documentId: document['\$id']),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
