import 'package:charusat_food_admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class NotificationScreen extends StatelessWidget {
  static const String id = 'notification-screen';
  @override
  Widget build(BuildContext context) {
    SidebarWidget _sideBar = SidebarWidget();
    return Scaffold(
        body: AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Food App DashBoard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBar.sideBarMenus(context, NotificationScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),
      ),
    ));
  }
}
