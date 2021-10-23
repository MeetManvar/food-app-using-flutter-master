//import 'dart:js';

import 'package:charusat_food/providers/auth_provider.dart';
import 'package:charusat_food/providers/location_provider.dart';
import 'package:charusat_food/screens/map_screen.dart';
import 'package:charusat_food/screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'map_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validphonenumber = false;
    var _phoneNumberController = TextEditingController();
    void showBottomSheet(context) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) =>
              StatefulBuilder(builder: (context, StateSetter myState) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Visibility(
                            visible:
                                auth.error == 'Invalid  OTP' ? true : false,
                            child: Container(
                              child: Text(auth.error),
                            )),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // Text(
                        //   'Enter Mobile No.',
                        //   style: TextStyle(fontSize: 12),
                        // ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        TextField(
                          decoration: InputDecoration(
                              prefixText: '+91',
                              labelText: '10 digit mobile number',
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          maxLength: 10,
                          controller: _phoneNumberController,
                          onChanged: (value) {
                            if (value.length == 10) {
                              myState(() {
                                _validphonenumber = true;
                              });
                            } else {
                              myState(() {
                                _validphonenumber = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // TextButton(
                        //   child: Text(
                        //     auth.loading
                        //         ? CircularProgressIndicator(
                        //             valueColor: AlwaysStoppedAnimation<Color>(
                        //                 Colors.white),
                        //           )
                        //         : _validphonenumber
                        //             ? 'Continue'
                        //             : 'Enter Phone number',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   style: TextButton.styleFrom(
                        //     primary: Colors.white,
                        //     backgroundColor: Colors.teal,
                        //     onSurface: Colors.grey,
                        //   ),
                        //   onPressed: () {
                        //     myState(() {
                        //       auth.loading = true;
                        //     });
                        //     String number = '+91${_phoneNumberController.text}';
                        //     auth.verifyPhone(context, number).then((value) {
                        //       _phoneNumberController.clear();
                        //       auth.loading = false;
                        //     });
                        //     auth.loading = false;
                        //   },
                        // ),
                        Row(
                          children: [
                            // TextButton(
                            //     onPressed: () {},
                            //     child: CircularProgressIndicator()),
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: _validphonenumber ? false : true,
                                child: TextButton(
                                    // focusColor: _validphonenumber
                                    //     ? Theme.of(context).primaryColor
                                    //     : Colors.grey,
                                    onPressed: () {
                                      myState(() {
                                        auth.loading = true;
                                      });
                                      String number =
                                          '+91${_phoneNumberController.text}';
                                      auth
                                          .verifyPhone(
                                        context: context,
                                        number: number,
                                      )
                                          .then((value) {
                                        _phoneNumberController.clear();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                    child: auth.loading
                                        ? CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        : Text(
                                            _validphonenumber
                                                ? 'Continue'
                                                : 'Enter Phone number',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              })).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationdata = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            // Positioned(
            //   right: 0,
            //   top: 10,
            //   child: TextButton(
            //     child: Text(
            //       'SKIP',
            //       style: TextStyle(color: Theme.of(context).primaryColor),
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            Column(
              children: [
                Expanded(child: OnBoardScreen()),
                //Text('Ready to Order?'),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    setState(() {
                      locationdata.loading = true;
                    });
                    await locationdata.getCurrentPosition();
                    if (locationdata.permissionAllowed == true) {
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationdata.loading = false;
                      });
                    } else {
                      print('PErmission not allowed');
                      setState(() {
                        locationdata.loading = false;
                      });
                    }
                  },
                  child: locationdata.loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'SET DELIVERY LOCATION',
                          style: TextStyle(color: Colors.white),
                        ),
                  //color: Colors.deepOrangeAccent,
                ),
                // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //   Text(
                //     'Already a Customer? ',

                //   ),
                //   FlatButton(
                //     onPressed: () {},
                //     child: RichText(
                //         text: TextSpan(
                //             text: 'Login',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.orangeAccent))),
                //   )
                // ]),
                TextButton(
                    onPressed: () {
                      setState(() {
                        auth.screen = 'Login';
                      });
                      showBottomSheet(context);
                    },
                    child: RichText(
                      text: TextSpan(
                          text: 'Already a Customer? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent))
                          ]),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
