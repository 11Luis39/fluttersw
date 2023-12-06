import 'package:flutter/material.dart';
import 'package:chattrac/Screens/LoginPage.dart';
import 'package:chattrac/Screens/Homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getString('phone') != null; 

  runApp(MyApp(isLoggedIn: isLoggedIn)); 
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; 

 
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF075E54),
          secondary: Color(0xFF128C7E),
        ),
      ),
      home: isLoggedIn ? const Homescreen() : const LoginScreen(),
    );
  }
}

