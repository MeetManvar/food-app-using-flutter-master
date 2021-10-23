import 'package:charusat_food/providers/store_provider.dart';
import 'package:charusat_food/services/product_services.dart';
import 'package:charusat_food/widgets/products/product_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    ProductServices _services = ProductServices();
    var _storeProvider = Provider.of<StoreProvider>(context);

    return FutureBuilder<QuerySnapshot>(
      future: _services.products
      .where('published', isEqualTo: true)
          .where('category.mainCategory', isEqualTo: _storeProvider.selectedProductCategory).get(),

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        /*if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(),);
        }*/
        if (snapshot.data.docs.isEmpty) {
          Container();
        }

        return   
          new ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ProductCard(document);
          }).toList(),
        );
      }, 
    );
  }
}