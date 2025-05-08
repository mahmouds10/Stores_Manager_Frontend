import 'package:flutter/material.dart';
import 'package:mobile_frontend/screens/stores_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        "/" : (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/stores': (context) => StoresScreen(),
      },
    );
  }
}
