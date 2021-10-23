import 'package:charusat_food_admin/widgets/seller_screen_widgets/seller_datatable_widget.dart';
import 'package:charusat_food_admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SellerScreen extends StatefulWidget {
  static const String id = 'seller-screen';

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
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
      sideBar: _sideBar.sideBarMenus(context, SellerScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Sellers',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Manage all shopkeeper activities'),
              Divider(
                thickness: 5,
              ),
              // SellerFilterWidget(),
              // Divider(
              //   thickness: 5,
              // ),
              SellerDataTable(),
              Divider(
                thickness: 5,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
