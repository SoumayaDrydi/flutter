import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/AdminHomePage.dart';
import 'pages/UserHomePage.dart';
import 'pages/register_page.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/adminHome': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User?;
          if (user != null) {
            return AdminDashboard(user: user);
          } else {
            return LoginPage();
          }
        },
        '/userHome': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User?;
          if (user != null) {
            return UserDashboard(user: user);
          } else {
            return LoginPage();
          }
        },
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
