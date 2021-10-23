import 'package:charusat_food/providers/auth_provider.dart';
import 'package:charusat_food/providers/location_provider.dart';
import 'package:charusat_food/screens/home_screen.dart';
import 'package:charusat_food/screens/landing_screen.dart';
import 'package:charusat_food/screens/login_screen.dart';
import 'package:charusat_food/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation = LatLng(37.421632, 122.084664);
  GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User user;

  @override
  void initState() {
    // check user logged in or not
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentLocation, zoom: 14.4746),
            zoomControlsEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onCameraMove: (CameraPosition position) {
              locationData.onCameraMove(position);
              setState(() {
                _locating = true;
              });
            },
            onMapCreated: onCreated,
            onCameraIdle: () {
              locationData.getMoveCamera();
              setState(() {
                _locating = false;
              });
            },
          ),
          Center(
            child: Container(
                margin: EdgeInsets.only(bottom: 40),
                height: 50,
                child: Image.asset(
                  'images/marker.png',
                  color: Colors.black,
                )),
            //chang
          ),
          Center(
            child: SpinKitPulse(color: Colors.black, size: 100),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
                height: 300,
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _locating
                        ? LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.transparent,
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_searching,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Flexible(
                          child: Text(
                            _locating
                                ? 'Locating'
                                : locationData.selectedAddress == null
                                    ? 'Locating'
                                    : locationData.selectedAddress.featureName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        _locating
                            ? ''
                            : locationData.selectedAddress == null
                                ? ''
                                : locationData.selectedAddress.addressLine,
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: AbsorbPointer(
                          absorbing: _locating ? true : false,
                          child: TextButton(
                            onPressed: () {
                              locationData.savePrefs();
                              if (_loggedIn == false) {
                                Navigator.pushNamed(context, LoginScreen.id);
                              } else {
                                print(user.uid);
                                setState(() {
                                  _auth.latitude = locationData.latitude;
                                  _auth.longitude = locationData.longitude;
                                  _auth.address =
                                      locationData.selectedAddress.addressLine;
                                  _auth.location =
                                      locationData.selectedAddress.featureName;
                                });
                                _auth
                                    .updateUser(
                                  id: user.uid,
                                  number: user.phoneNumber,
                                )
                                    .then((value) {
                                  if (value == true) {
                                    Navigator.pushNamed(context, MainScreen.id);
                                  }
                                });
                              }
                            },
                            child: Text(
                              'CONFIRM LOCATION',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: _locating
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    ));
  }
}
