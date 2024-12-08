import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/blocks_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/docs.dart';
import 'screens/auth_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BlocksProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'AppWrite Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            home: LoginPage(),
            routes: {
              '/login': (context) => LoginPage(),
              '/signup': (context) => SignUpPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}