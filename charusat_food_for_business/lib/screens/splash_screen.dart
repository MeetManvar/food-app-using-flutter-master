import 'dart:async';

import 'package:charusat_food_for_business/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('images/chef.png'),
          Text(
            'Charusat Food for Business',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          )
        ],
      )
          //Hero(tag: 'logo', child: Image.asset('images/chef.png')),
          ),
    );
  }
}
