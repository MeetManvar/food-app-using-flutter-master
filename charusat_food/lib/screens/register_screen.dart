import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Hero(tag: 'logo', child: Image.asset('images/chef.png')),
            TextField(),
            TextField(),
            Text('data')
          ],
        ),
      ),
    );
  }
}
