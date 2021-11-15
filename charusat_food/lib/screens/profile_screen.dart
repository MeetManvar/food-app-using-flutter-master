import 'package:flutter/material.dart';
import 'package:charusat_food/providers/auth_provider.dart';
import 'package:charusat_food/providers/location_provider.dart';
import 'package:charusat_food/screens/home_screen.dart';
import 'package:charusat_food/screens/main_screen.dart';
import 'package:charusat_food/screens/map_screen.dart';
import 'package:charusat_food/screens/profile_update_screen.dart';
import 'package:charusat_food/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Color primaryColor = Color(0xFF84c225);
Color scaffoldBackgroundColor = Colors.white;
Color textColor = Colors.black;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userdetails = Provider.of<AuthProvider>(context);
    var locationdata = Provider.of<LocationProvider>(context);

    User user = FirebaseAuth.instance.currentUser;
    userdetails.getUserDetails();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                color: primaryColor,
              ),
              Container(
                height: 548,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 350,
                          height: 180,
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        userdetails.snapshot
                                                    .data()['firstName'] !=
                                                null
                                            ? '${userdetails.snapshot.data()['firstName']} ${userdetails.snapshot.data()['lastName']}'
                                            : "Update Your Name",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                      if (userdetails.snapshot
                                              .data()['email'] !=
                                          null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      Text(
                                        "${userdetails.snapshot.data()['email']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            //fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        user.phoneNumber,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      pushNewScreenWithRouteSettings(
                                        context,
                                        screen: UpdateProfile(),
                                        settings: RouteSettings(
                                            name: UpdateProfile.id),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Divider(),
                              if (userdetails.snapshot != null)
                                ListTile(
                                  tileColor: Colors.white,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: Colors.redAccent,
                                  ),
                                  title: Text(
                                      userdetails.snapshot.data()['location']),
                                  subtitle: Text(
                                    userdetails.snapshot.data()['address'],
                                    maxLines: 1,
                                  ),
                                  trailing: SizedBox(
                                    width: 80,
                                    child: OutlinedButton(
                                      child: Text(
                                        "Change",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        EasyLoading.show(
                                            status: "Please Wait...");
                                        locationdata
                                            .getCurrentPosition()
                                            .then((value) {
                                          //  if(value!=null){}
                                          EasyLoading.dismiss();
                                          pushNewScreenWithRouteSettings(
                                            context,
                                            screen: MapScreen(),
                                            settings: RouteSettings(
                                                name: MapScreen.id),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.shop_outlined),
                        title: Text("My Orders")),
                    ListTile(
                        leading: Icon(Icons.location_on_outlined),
                        title: Text("My Rattings & Reviews")),
                    ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text("Notifications")),
                    ListTile(
                        onTap: () {
                          FirebaseAuth.instance.signOut();

                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: WelcomeScreen.id),
                            screen: WelcomeScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        leading: Icon(Icons.exit_to_app_outlined),
                        title: Text("LogOut")),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/charusat-food-app.appspot.com/o/bannerImage%2Flogo.png?alt=media&token=37e60bde-0c98-4710-923f-47087680b89f",
                  ),
                  radius: 45,
                  backgroundColor: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
