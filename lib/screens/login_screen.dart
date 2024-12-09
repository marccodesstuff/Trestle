import 'package:final_trestle/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../utils/appwrite.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AppwriteService appwriteService = AppwriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;

                try {
                  await appwriteService.loginUser(email, password);
                  // Save credentials logic here (e.g., using SharedPreferences)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } catch (e) {
                  print('Login failed: $e');
                  // Show an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}