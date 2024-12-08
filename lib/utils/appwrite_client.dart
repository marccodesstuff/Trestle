import 'package:appwrite/appwrite.dart';

Client client = Client();
Account account = Account(client);

void initAppWrite() {
  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('675448ef003e37a9488a');
}