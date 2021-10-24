import 'package:charusat_food/providers/store_provider.dart';
import 'package:charusat_food/services/product_services.dart';
import 'package:charusat_food/widgets/products/product_list.dart';
import 'package:charusat_food/widgets/seller_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget{
  static const id = 'home-screen';
  @override
  Widget build(BuildContext context){
    
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(_storeProvider.selectedProductCategory, style: TextStyle(color: Colors.white),),
                iconTheme: IconThemeData(
                  color: Colors.white
                ),
              ),
            ];
          },
          body: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              ProductListWidget(),
            ],
          ),
    ),
    );
  }
}