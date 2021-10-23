import 'package:charusat_food_for_business/screens/banners_screen.dart';
import 'package:charusat_food_for_business/screens/dashboard_screen.dart';
import 'package:charusat_food_for_business/screens/products_screen.dart';
import 'package:flutter/material.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return MainScreen();
    }

    if (title == 'Products') {
      return ProductScreen();
    }

    if (title == 'Banners') {
      return BannerScreen();
    }

    if (title == 'Coupons') {
      return MainScreen();
    }

    if (title == 'Orders') {
      return MainScreen();
    }

    if (title == 'Reports') {
      return MainScreen();
    }

    if (title == 'Setting') {
      return MainScreen();
    }

    if (title == 'LogOut') {
      return MainScreen();
    }

    return MainScreen();
  }
}
