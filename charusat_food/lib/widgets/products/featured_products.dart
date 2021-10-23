import 'package:charusat_food/services/product_services.dart';
import 'package:charusat_food/widgets/products/product_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeaturedProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    return FutureBuilder<QuerySnapshot>(
      future: _services.products
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Featured Products')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.data.docs.isEmpty) {
          Container();
        }

        return new ListView(
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
