import 'package:charusat_food/providers/auth_provider.dart';
import 'package:charusat_food/providers/location_provider.dart';
import 'package:charusat_food/providers/store_provider.dart';
import 'package:charusat_food/screens/home_screen.dart';
import 'package:charusat_food/screens/landing_screen.dart';
import 'package:charusat_food/screens/login_screen.dart';
import 'package:charusat_food/screens/main_screen.dart';
import 'package:charusat_food/screens/map_screen.dart';
import 'package:charusat_food/screens/product_details_screen.dart';
import 'package:charusat_food/screens/profile_update_screen.dart';
import 'package:charusat_food/screens/seller_home_screen.dart';
import 'package:charusat_food/screens/splash_screen.dart';
import 'package:charusat_food/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:charusat_food/screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => StoreProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF84c225), fontFamily: 'Lato'),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        SellerHomeScreen.id: (context) => SellerHomeScreen(),
        // ignore: equal_keys_in_map
        ProductListScreen.id: (context) => ProductListScreen(),
        ProductDetailScreen.id: (context) => ProductDetailScreen(),
        UpdateProfile.id: (context) => UpdateProfile(),
      },
    );
  }
}
