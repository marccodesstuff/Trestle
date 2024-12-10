import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'screens/home_page.dart';
import 'services/google_services.dart';
import 'package:googleapis/docs/v1.dart' as docs;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(userName: "Marc Velasquez"),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({super.key, required this.userName});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  GoogleService? googleService;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    final clientId = ClientId('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET');
    final scopes = [docs.DocsApi.documentsScope, 'https://www.googleapis.com/auth/gemini'];

    await clientViaUserConsent(clientId, scopes, (url) {
      // Open the URL in a browser or WebView for the user to authenticate
      print('Please go to the following URL and grant access:');
      print('  => $url');
      // You can use a package like url_launcher to open the URL
    }).then((AuthClient client) {
      setState(() {
        googleService = GoogleService(client);
      });
    }).catchError((error) {
      print('Error authenticating: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.userName}'),
      ),
      body: Center(
        child: googleService == null
            ? CircularProgressIndicator()
            : Text('Authenticated and ready to use Google APIs'),
      ),
    );
  }
}
