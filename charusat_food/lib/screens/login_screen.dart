import 'package:charusat_food/providers/auth_provider.dart';
import 'package:charusat_food/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validphonenumber = false;
  var _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Visibility(
                    visible: auth.error == 'Invalid  OTP' ? true : false,
                    child: Container(
                      child: Text(auth.error),
                    )),
                // SizedBox(
                //   height: 5,
                // ),
                Text(
                  'Log In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      setState(() {
                        _validphonenumber = true;
                      });
                    } else {
                      setState(() {
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
                              print(locationData.longitude);
                              setState(() {
                                auth.loading = true;
                                auth.screen = 'MapScreen';
                                auth.latitude = locationData.latitude;
                                auth.longitude = locationData.longitude;
                                auth.address =
                                    locationData.selectedAddress.addressLine;
                              });
                              String number =
                                  '+91${_phoneNumberController.text}';
                              auth
                                  .verifyPhone(
                                context: context,
                                number: number,
                                // latitude: locationData.latitude,
                                // longitude: locationData.longitude,
                                // address: locationData.selectedAddress.addressLine
                              )
                                  .then((value) {
                                _phoneNumberController.clear();
                                setState(() {
                                  auth.loading = false;
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            child: auth.loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    _validphonenumber
                                        ? 'Continue'
                                        : 'Enter Phone number',
                                    style: TextStyle(color: Colors.white),
                                  )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
