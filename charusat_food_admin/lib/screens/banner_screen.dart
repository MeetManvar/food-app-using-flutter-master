import 'dart:html';

import 'package:charusat_food_admin/widgets/banner_screen_widgets/banner_upload_widget.dart';
import 'package:charusat_food_admin/widgets/banner_screen_widgets/banner_widget.dart';
import 'package:charusat_food_admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class BannerScreen extends StatefulWidget {
  static const String id = 'banner-screen';

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  SidebarWidget _sideBar = SidebarWidget();
  @override
  Widget build(BuildContext context) {
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
      sideBar: _sideBar.sideBarMenus(context, BannerScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Banner Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add / Delete Banner'),
              Divider(
                thickness: 5,
              ),
              BannerWidget(),
              Divider(
                thickness: 5,
              ),
              BannerUploadWidget(),
            ],
          ),
        ),
      ),
    ));
  }
}
