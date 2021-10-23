import 'package:charusat_food_for_business/providers/auth_provider.dart';
import 'package:charusat_food_for_business/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-screen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  bool _loading = false;
  String email;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Reset Password',
                  style: TextStyle(fontFamily: 'Anton', fontSize: 30),
                ),
                Text(
                  '(you will receive reset link on your verified email)',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter E-mail';
                    }
                    final bool _isValid =
                        EmailValidator.validate(_emailTextController.text);
                    if (!_isValid) {
                      return 'Invalid E-mail';
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'E-mail',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              _authData.resetPassword(email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'We have sent a link on your email')));
                            }

                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          child: _loading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text('Reset Password')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
