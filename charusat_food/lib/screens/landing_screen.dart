import 'package:charusat_food/providers/location_provider.dart';
import 'package:charusat_food/screens/home_screen.dart';
import 'package:charusat_food/screens/map_screen.dart';
import 'package:charusat_food/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  // User user = FirebaseAuth.instance.currentUser;
  // String _location;
  // String _address;

  // @override
  // void initState() {
  //   UserServices _userServices = UserServices();
  //   _userServices.getUserbyId(user.uid).then((result) async {
  //     if (result != null) {
  //       if (result.data()['latitude'] != null) {
  //         getPrefs(result);
  //       } else {
  //         _locationProvider.getCurrentPosition();
  //         if (_locationProvider.permissionAllowed == true) {
  //           Navigator.pushNamed(context, MapScreen.id);
  //         } else {
  //           print('permission not allowd');
  //         }
  //       }
  //     }
  //   });
  //   super.initState();
  // }

  // getPrefs(dbResult) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String location = prefs.getString('location');
  //   if (location == null) {
  //     prefs.setString('address', dbResult.data()['location']);
  //     prefs.setString('location', dbResult.data()['address']);
  //     if (mounted) {
  //       setState(() {
  //         _location = dbResult.data()['location'];
  //         _address = dbResult.data()['address'];
  //         _loading = false;
  //       });
  //     }
  //     Navigator.pushReplacementNamed(context, HomeScreen.id);
  //   }
  //   Navigator.pushReplacementNamed(context, HomeScreen.id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(_location == null ? '' : _location),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delivery Address not set',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please update your delivery loction to find nearest stores for you',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              width: 600,
              child: Image.asset(
                'images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.pushReplacementNamed(context, HomeScreen.id);
            //     },
            //     child: Text('Confirm Location'),
            //     style: ElevatedButton.styleFrom(
            //         primary: Theme.of(context).primaryColor)),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      await _locationProvider.getCurrentPosition();
                      if (_locationProvider.selectedAddress != null) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          if (_locationProvider.permissionAllowed == false) {
                            print('permission not allowed');
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Please allow location permissoin')));
                          }
                        });
                      }
                    },
                    child: Text('Update Location'),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }
}
