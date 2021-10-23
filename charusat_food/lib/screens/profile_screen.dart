import 'package:charusat_food/screens/main_screen.dart';
import 'package:charusat_food/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();

            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: WelcomeScreen.id),
              screen: WelcomeScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
