import 'package:charusat_food/providers/auth_provider.dart';
import 'package:charusat_food/providers/location_provider.dart';
import 'package:charusat_food/screens/home_screen.dart';
import 'package:charusat_food/screens/main_screen.dart';
import 'package:charusat_food/screens/map_screen.dart';
import 'package:charusat_food/screens/profile_update_screen.dart';
import 'package:charusat_food/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userdetails = Provider.of<AuthProvider>(context);
    var locationdata = Provider.of<LocationProvider>(context);

    User user = FirebaseAuth.instance.currentUser;
    userdetails.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Grocery Store",
          style: TextStyle(color: Colors.white),
        ),
        // leading: IconButton(onPressed: (){
        //  pushNewScreenWithRouteSettings(
        //                                 context,
        //                                 screen: HomeScreen(),
        //                                 settings:
        //                                     RouteSettings(name: HomeScreen.id),
        //                                 withNavBar: true,   
        //                                 pageTransitionAnimation:
        //                                     PageTransitionAnimation.cupertino,
        //                               );
        // }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
      ),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    "My Account ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.redAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'J',
                                  style: TextStyle(
                                      fontSize: 50, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userdetails.snapshot.data()['firstName'] != null
                                          ? '${userdetails.snapshot.data()['firstName']} ${userdetails.snapshot.data()['lastName']}'
                                          : "Update Your Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                    if(userdetails.snapshot.data()['email']!=null)
                                    Text(
                                      "${userdetails.snapshot.data()['email']}",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      user.phoneNumber,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          if (userdetails.snapshot != null)
                            ListTile(
                              tileColor: Colors.white,
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                              ),
                              title:
                                  Text(userdetails.snapshot.data()['location']),
                              subtitle: Text(
                                userdetails.snapshot.data()['address'],
                                maxLines: 1,
                              ),
                              trailing: SizedBox(
                                width: 80,
                                child: OutlinedButton(
                                  child: Text(
                                    "Change",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    EasyLoading.show(status: "Please Wait...");
                                    locationdata
                                        .getCurrentPosition()
                                        .then((value) {
                                      //  if(value!=null){}
                                      EasyLoading.dismiss();
                                      pushNewScreenWithRouteSettings(
                                        context,
                                        screen: MapScreen(),
                                        settings:
                                            RouteSettings(name: MapScreen.id),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    });
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.0,
                    child: IconButton(
                      onPressed: () {
                        pushNewScreenWithRouteSettings(
                          context,
                          screen: UpdateProfile(),
                          settings: RouteSettings(name: UpdateProfile.id),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("My Orders"),
                horizontalTitleGap: 2,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.comment_outlined),
                title: Text("My Rattings & Reviews"),
                horizontalTitleGap: 2,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.notifications_none),
                title: Text("Notifications"),
                horizontalTitleGap: 2,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text("LogOut"),
                horizontalTitleGap: 2,
                onTap: () {
                  FirebaseAuth.instance.signOut();

                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: WelcomeScreen.id),
                    screen: WelcomeScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
            ],
          )),
    );
  }
}