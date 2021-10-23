import 'dart:io';

import 'package:charusat_food_for_business/providers/auth_provider.dart';
import 'package:charusat_food_for_business/screens/home_screen.dart';
import 'package:charusat_food_for_business/screens/verify_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formkey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordController = TextEditingController();
  var _cpasswordController = TextEditingController();
  var _addressController = TextEditingController();
  var _nameController = TextEditingController();
  var _subTextController = TextEditingController();

  String email;
  String password;
  String mobile;
  String shopName;
  String subtext;

  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('uploads/shopProfilePic/${_nameController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }

    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_nameController.text}')
        .getDownloadURL();
    return downloadURL;

    // Within your widgets:
    // Image.network(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      //controller: _nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Shop Name';
                        }
                        setState(() {
                          _nameController.text = value;
                        });
                        setState(() {
                          shopName = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add_business),
                          labelText: 'Business Name',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Mobile Number';
                        }
                        setState(() {
                          mobile = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixText: '+91',
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Mobile Number',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      controller: _emailTextController,
                      keyboardType: TextInputType.emailAddress,
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
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        if (value.length < 6) {
                          return 'Min 6 characters required';
                        }
                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      controller: _cpasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Confirm Password';
                        }
                        // if (value.length < 6) {
                        //   return 'Min 6 characters required';
                        // }
                        if (_passwordController.text !=
                            _cpasswordController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_clock),
                          labelText: 'Confirm PassWord',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      maxLines: 6,
                      controller: _addressController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Click on navigator';
                        }
                        if (_authData.shopLatitude == null) {
                          return 'Click on navigator..';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.contact_mail_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.location_searching),
                            onPressed: () {
                              _addressController.text =
                                  'Locating... \n Please wait';
                              _authData.getCurrentAddress().then((address) {
                                if (address != null) {
                                  setState(() {
                                    _addressController.text =
                                        '${_authData.placeName} \n ${_authData.shopAddress}';
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Could not find location please try again')));
                                }
                              });
                            },
                          ),
                          labelText: 'Business Location',
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      onChanged: (value) {
                        _subTextController.text = value;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.comment),
                          labelText: 'Shop Subtext',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (_authData.isPicAvail == true) {
                                if (_formkey.currentState.validate()) {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(content: Text('Processing...')));
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _authData
                                      .registerShop(email, password)
                                      .then((credencial) {
                                    if (credencial.user.uid != null) {
                                      uploadFile(_authData.image.path)
                                          .then((url) {
                                        if (url != null) {
                                          _authData.saveShopDatatoDb(
                                              url: url,
                                              mobile: mobile,
                                              shopName: shopName,
                                              subtext: _subTextController.text);

                                          setState(() {
                                            //_formkey.currentState.reset();
                                            _isLoading = false;
                                          });
                                          Navigator.pushReplacementNamed(
                                              context, VerifyScreen.id);
                                        } else {
                                          scaffoldMessage(
                                              'failed to upload profile pic');
                                        }
                                      });
                                    } else {
                                      scaffoldMessage(_authData.error);
                                    }
                                  });
                                }
                              } else {
                                scaffoldMessage('Please upload profile pic');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            child: Text('Register')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
