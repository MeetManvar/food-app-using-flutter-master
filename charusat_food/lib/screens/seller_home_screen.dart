import 'package:charusat_food/widgets/categories_widget.dart';
import 'package:charusat_food/widgets/products/featured_products.dart';
import 'package:charusat_food/widgets/seller_appbar.dart';
import 'package:charusat_food/widgets/seller_banner.dart';
import 'package:flutter/material.dart';

class SellerHomeScreen extends StatelessWidget {
  static const String id = 'seller-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [SellerAppBar()];
          },
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              //SellerBanner(),
              SellerCategories(),
              //FeaturedProducts(),
            ],
          )),
    );
  }
}
