import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Client client = Client();
Account account = Account(client);
Databases databases = Databases(client);

void initAppWrite() {
  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '');
}