import 'package:charusat_food_admin/screens/admin_users_screen.dart';
import 'package:charusat_food_admin/screens/banner_screen.dart';
import 'package:charusat_food_admin/screens/category_screen.dart';
import 'package:charusat_food_admin/screens/home_screen.dart';
import 'package:charusat_food_admin/screens/login_page.dart';
import 'package:charusat_food_admin/screens/notification_screen.dart';
import 'package:charusat_food_admin/screens/orders_screen.dart';
import 'package:charusat_food_admin/screens/sellers_screen.dart';
import 'package:charusat_food_admin/screens/settings_screen.dart';
import 'package:charusat_food_admin/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHARUSAT FOOD ADMIN DASHBOARD',
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
      ),
      home: SplashScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        LogInPage.id: (context) => LogInPage(),
        BannerScreen.id: (context) => BannerScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        OrderScreen.id: (context) => OrderScreen(),
        NotificationScreen.id: (context) => NotificationScreen(),
        AdminUsersScreen.id: (context) => AdminUsersScreen(),
        SettingScreen.id: (context) => SettingScreen(),
        SellerScreen.id: (context) => SellerScreen()
      },
    );
  }
}

//flutter run --web-renderer html
//flutter run -d chrome --web-renderer html
