import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String id = 'product_detais_screen';
  final DocumentSnapshot document;
  ProductDetailScreen({this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
        ],
      ),
      bottomSheet: Container(
        child: Row(
          children: [
            Expanded(
                child: Container(
              height: 56,
              color: Colors.grey[800],
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Back to Main Page'),
              )),
            )),
            Expanded(
                child: Container(
              height: 56,
              color: Colors.red[800],
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Save for later'),
              )),
            ))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.3),
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 2, top: 2),
                    child: Text(document.data()['brand']),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(document.data()['productName']),
            SizedBox(
              height: 10,
            ),
            Text(document.data()['weight']),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('\$${document.data()['price']}'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.network(document.data()['productImage']),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 6,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  'About this product',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ExpandableText(
                document.data()['description'],
                expandText: 'view more',
                collapseText: 'view less',
                maxLines: 2,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  'other product info',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKU : ${document.data()['sku']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Seller : ${document.data()['seller']['shopname']}',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
