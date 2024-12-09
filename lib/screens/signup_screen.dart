import 'package:final_trestle/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../utils/appwrite.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                final appwriteService = AppwriteService();

                if (passwordController.text == confirmPasswordController.text) {
                  appwriteService
                      .createAccount(
                    emailController.text,
                    passwordController.text,
                    nameController.text,
                  )
                      .then((_) {
                    // Save credentials and navigate to home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }).catchError((error) {
                    // Handle account creation error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Account creation failed: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
