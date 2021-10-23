import 'package:charusat_food_for_business/screens/login_screen.dart';
import 'package:charusat_food_for_business/widgets/image_picker.dart';
import 'package:charusat_food_for_business/widgets/register_form.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ShopPicCard(),
                  RegisterForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                        },
                        child: Text(
                          'Already Account, Login',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
