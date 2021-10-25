import 'package:charusat_food/providers/store_provider.dart';
import 'package:charusat_food/widgets/categories_widget.dart';
import 'package:charusat_food/widgets/products/featured_products.dart';
import 'package:charusat_food/widgets/seller_appbar.dart';
import 'package:charusat_food/widgets/seller_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class SellerHomeScreen extends StatelessWidget {
  static const String id = 'seller-screen';

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {}, icon: Icon(CupertinoIcons.search),
              )
            ],
            title: Text(
              _store.selectedStore,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ];
      },
      body: Center(
          child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          SellerBanner(),
          //SellerCategories(),
          //FeaturedProducts(),
        ],
      )),
    ));
  }
}
