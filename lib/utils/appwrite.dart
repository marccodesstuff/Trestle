import 'package:appwrite/appwrite.dart';

class AppwriteService {
  late Client client;
  late Account account;
  late Databases databases;

  AppwriteService() {
    client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('675448ef003e37a9488a');

    account = Account(client);
    databases = Databases(client);
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      print('Login successful');
    } catch (e) {
      print('Login failed: $e');
      throw e; // Rethrow the exception to be caught in the LoginScreen
    }
  }

  Future<void> createAccount(String email, String password, String name) async {
    try {
      await account.create(
        userId: 'unique()',
        email: email,
        password: password,
        name: name,
      );
      print('Account created successfully');
    } catch (e) {
      print('Account creation failed: $e');
      throw e; // Rethrow the exception to be caught in the calling code
    }
  }

  Future<void> logOutUser() async {
    try {
      await account.deleteSession(sessionId: 'current');
      print('Logout successful');
    } catch (e) {
      print('Logout failed: $e');
      throw e; // Rethrow the exception to be caught in the calling code
    }
  }
}