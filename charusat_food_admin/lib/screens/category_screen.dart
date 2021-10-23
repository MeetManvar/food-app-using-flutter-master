import 'package:charusat_food_admin/widgets/category_screen_widgets/category_list_widget.dart';
import 'package:charusat_food_admin/widgets/category_screen_widgets/category_upload_widget.dart';
import 'package:charusat_food_admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class CategoryScreen extends StatelessWidget {
  static const String id = 'category-screen';
  @override
  Widget build(BuildContext context) {
    SidebarWidget _sideBar = SidebarWidget();
    return Scaffold(
        body: AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Food App DashBoard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBar.sideBarMenus(context, CategoryScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add new Categories and Sub Categories'),
              Divider(
                thickness: 5,
              ),
              CategoryCreateWidget(),
              Divider(
                thickness: 5,
              ),
              CategoryList()
            ],
          ),
        ),
      ),
    ));
  }
}
