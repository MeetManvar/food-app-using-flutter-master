import 'package:charusat_food/providers/location_provider.dart';
import 'package:charusat_food/screens/home_screen.dart';
import 'package:charusat_food/screens/landing_screen.dart';
import 'package:charusat_food/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String screen;
  double latitude;
  double longitude;
  String address;
  String location;

  Future<void> verifyPhone({
    BuildContext context,
    String number,
  }) async {
    this.loading = true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      this.verificationId = verId;

      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          });
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 digit OTP received by SMS',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);
                      final User user = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user;
                      if (user != null) {
                        this.loading = false;
                        notifyListeners();

                        _userServices.getUserbyId(user.uid).then((snapShot) {
                          if (snapShot.exists) {
                            if (this.screen == 'Login') {
                              if (snapShot.data()['address'] != null) {
                                Navigator.pushReplacementNamed(
                                    context, MainScreen.id);
                              }
                              Navigator.pushReplacementNamed(
                                  context, LandingScreen.id);
                            } else {
                              print('${locationData.latitude}');
                              updateUser(
                                  id: user.uid, number: user.phoneNumber);
                              Navigator.pushReplacementNamed(
                                  context, MainScreen.id);
                            }
                          } else {
                            _createUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(
                                context, LandingScreen.id);
                          }
                        });
                      } else {
                        print('login failed');
                      }
                    } catch (e) {
                      this.error = 'Invalid  OTP';
                      this.loading = false;
                      notifyListeners();
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Done',
                  ))
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({
    String id,
    String number,
    // double latitude,
    // double longitude,
    // String address
  }) {
    _userServices.createUserData({
      'id': id,
      'number': number,

      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      // 'location': GeoPoint(latitude, longitude),
      // 'latitude': latitude,
      // 'longitude': longitude,
      // 'address': address
      'location': this.location
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({
    String id,
    String number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        // 'location': GeoPoint(latitude, longitude),
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error $e');
      return false;
    }
  }
}
