import 'package:charusat_food_for_business/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
