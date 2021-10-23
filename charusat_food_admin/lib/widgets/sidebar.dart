import 'package:charusat_food_admin/screens/home_screen.dart';
import 'package:charusat_food_admin/screens/sellers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:charusat_food_admin/screens/admin_users_screen.dart';
import 'package:charusat_food_admin/screens/banner_screen.dart';
import 'package:charusat_food_admin/screens/category_screen.dart';
import 'package:charusat_food_admin/screens/login_page.dart';
import 'package:charusat_food_admin/screens/notification_screen.dart';
import 'package:charusat_food_admin/screens/orders_screen.dart';
import 'package:charusat_food_admin/screens/settings_screen.dart';

class SidebarWidget {
  sideBarMenus(context, selectedRoute) {
    return SideBar(
      activeBackgroundColor: Colors.black54,
      activeIconColor: Colors.white,
      activeTextStyle: TextStyle(color: Colors.white),
      items: const [
        MenuItem(
          title: 'Dashboard',
          route: HomeScreen.id,
          icon: Icons.dashboard,
        ),
        MenuItem(
          title: 'Banners',
          route: BannerScreen.id,
          icon: Icons.photo,
        ),
        MenuItem(
          title: 'Sellers',
          route: SellerScreen.id,
          icon: Icons.group_sharp,
        ),
        MenuItem(
          title: 'Categories',
          route: CategoryScreen.id,
          icon: Icons.category,
        ),
        MenuItem(
          title: 'Orders',
          route: OrderScreen.id,
          icon: Icons.shopping_bag_outlined,
        ),
        MenuItem(
          title: 'Send Notification',
          route: NotificationScreen.id,
          icon: Icons.notifications_active,
        ),
        MenuItem(
          title: 'Admin Users',
          route: AdminUsersScreen.id,
          icon: Icons.person,
        ),
        MenuItem(
          title: 'Settings',
          route: SettingScreen.id,
          icon: Icons.settings,
        ),
        MenuItem(
          title: 'Log out',
          route: LogInPage.id,
          icon: Icons.exit_to_app,
        ),
      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        Navigator.of(context).pushNamed(item.route);
      },
      header: Container(
        height: 50,
        width: double.infinity,
        color: Colors.black26,
        child: Center(
          child: Text(
            'Menu',
            style: TextStyle(
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
      footer: Container(
        height: 50,
        width: double.infinity,
        color: Colors.black26,
        child: Center(
            child: Image.asset(
          'images/chef.png',
          height: 50,
        )),
      ),
    );
  }
}
