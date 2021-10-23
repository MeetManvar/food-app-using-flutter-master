import 'package:charusat_food_for_business/providers/auth_provider.dart';
import 'package:charusat_food_for_business/screens/home_screen.dart';
import 'package:charusat_food_for_business/screens/register_screen.dart';
import 'package:charusat_food_for_business/screens/reset_password_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Icon icon;
  bool _visible = false;
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  String email;
  String password;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _authdata = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(fontFamily: 'Anton', fontSize: 30),
                          ),
                          Image.asset(
                            'images/chef.png',
                            height: 60,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter E-mail';
                          }
                          final bool _isValid = EmailValidator.validate(
                              _emailTextController.text);
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
                                    width: 2,
                                    color: Theme.of(context).primaryColor)),
                            focusColor: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordTextController,
                        obscureText: _visible == false ? true : false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Password';
                          }
                          if (value.length < 6) {
                            return 'minimum 6 char req';
                          }
                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                                icon: _visible
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                }),
                            labelText: 'Password',
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).primaryColor)),
                            focusColor: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ResetPassword.id);
                            },
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
                                    _authdata
                                        .loginShop(email, password)
                                        .then((credential) {
                                      if (credential != null) {
                                        setState(() {
                                          _loading = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      } else {
                                        setState(() {
                                          _loading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(_authdata.error)));
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor),
                                child: _loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text('Login')),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, RegisterScreen.id);
                            },
                            child: Text(
                              'New User?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
