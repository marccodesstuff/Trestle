import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Trestle',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'A block-based word processor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}