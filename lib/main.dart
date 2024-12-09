import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/blocks_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/docs.dart';
import 'screens/auth_pages.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await dotenv.load(fileName: ".env"); // Change this if you use a different name

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

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
            home: isLoggedIn ? HomePage() : LoginPage(),
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