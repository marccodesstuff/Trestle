import 'package:flutter/material.dart';
import '../models/block_model.dart';
import '../models/document_model.dart';
import 'welcome_screen.dart';
import 'document_page.dart';
import '../utils/appwrite.dart';
import 'package:flutter/services.dart';

class DocumentPage extends StatefulWidget {
  final String documentTitle;

  DocumentPage({required this.documentTitle});

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  bool isBold = false;
  bool isItalic = false;
  TextAlign textAlign = TextAlign.left;
  Document document = Document(title: '', blocks: []);
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    document = Document(title: widget.documentTitle, blocks: [
      Block.textBlock('', 0),
    ]);
    focusNodes = List.generate(document.blocks.length, (index) => FocusNode());
  }

  void _addBlock() {
    setState(() {
      document.addBlock(Block.textBlock('', document.blocks.length));
      focusNodes.add(FocusNode());
    });
  }

  void _onTextChanged(int index, String text) {
    setState(() {
      document.blocks[index].content = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentTitle),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.format_bold,
                  color: isBold ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isBold = !isBold;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_italic,
                  color: isItalic ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isItalic = !isItalic;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_left,
                  color: textAlign == TextAlign.left ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    textAlign = TextAlign.left;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_center,
                  color: textAlign == TextAlign.center ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    textAlign = TextAlign.center;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_right,
                  color: textAlign == TextAlign.right ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    textAlign = TextAlign.right;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: document.blocks.length + 1,
        itemBuilder: (context, index) {
          if (index == document.blocks.length) {
            return Center(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: _addBlock,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawKeyboardListener(
              focusNode: focusNodes[index],
              onKey: (event) {
                if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                  _addBlock();
                  FocusScope.of(context).requestFocus(focusNodes.last);
                }
              },
              child: TextField(
                maxLines: null,
                decoration: InputDecoration.collapsed(hintText: 'Start typing...'),
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                ),
                textAlign: textAlign,
                onChanged: (text) => _onTextChanged(index, text),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
                Navigator.pop(context);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DocumentPage(documentTitle: 'New Document')),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}