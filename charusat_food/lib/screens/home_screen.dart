import 'package:charusat_food/providers/auth_provider.dart';
import 'package:charusat_food/screens/welcome_screen.dart';
import 'package:charusat_food/widgets/all_nearby_stores.dart';
import 'package:charusat_food/widgets/top_pick_store.dart';
import 'package:charusat_food/widgets/image_slider.dart';
import 'package:charusat_food/widgets/my_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [MyAppBar()];
      },
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageSlider(),
          // Container(
          //  // height: 200,
          //   child: TopPicksStore(),
          //   //color: Colors.red,
          // ),
          TopPicksStore(),
          AllNearByStores(),
        ],
      ),
    ));
  }
}
// ElevatedButton(
//   onPressed: () {
//     auth.error = "";
//     FirebaseAuth.instance.signOut().then((value) {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => WelcomeScreen()));
//     });
//   },
//   child: Text('SignOUT'),
// ),
// ElevatedButton(
//   onPressed: () {
//     Navigator.pushNamed(context, WelcomeScreen.id);
//   },
//   child: Text('Home Screen'),
// ),
