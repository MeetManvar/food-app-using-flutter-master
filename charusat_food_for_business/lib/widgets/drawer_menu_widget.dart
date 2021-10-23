import 'package:charusat_food_for_business/providers/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User user = FirebaseAuth.instance.currentUser;
  var sellerData;

  @override
  void initState() {
    getSellerData();
    super.initState();
  }

  Future<DocumentSnapshot> getSellerData() async {
    var result = await FirebaseFirestore.instance
        .collection('shopkeepers')
        .doc(user.uid)
        .get();

    setState(() {
      sellerData = result;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider
        .getShopName(sellerData != null ? sellerData.data()['shopName'] : '');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: sellerData != null
                          ? NetworkImage(sellerData.data()['imageUrl'])
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    sellerData != null
                        ? sellerData.data()['shopName']
                        : 'Shop Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          sliderItem('Dashboard', Icons.dashboard_outlined),
          sliderItem('Products', Icons.shopping_bag_outlined),
          sliderItem('Banners', Icons.photo),
          sliderItem('Coupons', CupertinoIcons.gift),
          sliderItem('Orders', Icons.list_alt_outlined),
          sliderItem('Reports', Icons.stacked_bar_chart),
          sliderItem('Setting', Icons.settings_outlined),
          sliderItem('LogOut', Icons.logout),
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(
                  icons,
                  color: Colors.black54,
                  size: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        widget.onItemClick(title);
      });
}
