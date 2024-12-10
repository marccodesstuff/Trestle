import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/docs/v1.dart' as docs;

class GoogleService {
  final String googleDocsApiUrl = '493968100466-ju7t8snhrokt37hmkb4jqqu3rg9a60q2.apps.googleusercontent.com';
  final String googleGeminiApiUrl = 'AIzaSyCWzeEfO-fuvtztENzUM-P__D3bvlX9Qzo';

  final AuthClient authClient;

  GoogleService(this.authClient);

  Future<String?> createGoogleDoc(String title, String content) async {
    final url = Uri.parse(googleDocsApiUrl);
    final headers = {
      'Authorization': 'Bearer ${authClient.credentials.accessToken.data}',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'title': title,
      'body': {
        'content': [
          {
            'paragraph': {
              'elements': [
                {
                  'textRun': {
                    'content': content,
                  },
                },
              ],
            },
          },
        ],
      },
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['documentId'];
    } else {
      print('Error creating Google Doc: ${response.body}');
      return null;
    }
  }

  Future<String?> optimizeLayout(String content, String prompt) async {
    final url = Uri.parse(googleGeminiApiUrl);
    final headers = {
      'Authorization': 'Bearer ${authClient.credentials.accessToken.data}',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'content': content,
      'prompt': prompt,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['optimizedContent'];
    } else {
      print('Error optimizing layout: ${response.body}');
      return null;
    }
  }
}