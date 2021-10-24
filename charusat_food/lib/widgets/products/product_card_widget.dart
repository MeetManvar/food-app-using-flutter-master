import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;

  ProductCard(this.document);
  @override
  Widget build(BuildContext context) {
    String offer = ((document.data()['comparedPrice'] - document.data()['price'])/
    document.data()['comparedPrice']*100).toStringAsFixed(0);

    return SingleChildScrollView(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, left: 10, right: 10),
          child: Row(
            children: [
              Stack(
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 120,
                      width: MediaQuery.of(context).size.width - 290,
                      child: Container(
                        child: Image.network(document.data()['productImage']),
                      ),
                    ),
                  ),
                  Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                  child: Text('$offer% OFF',style: TextStyle(color: Colors.white,fontSize: 12),),
                ),
              ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.data()['productName'],
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            document.data()['description'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Text(
                                '\₹${document.data()['price'].toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (document.data()['comparedPrice'] > 0)
                                Text(
                                  '\₹${document.data()['comparedPrice'].toStringAsFixed(0)}',
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Card(
                                color: Theme.of(context).primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 7, bottom: 7),
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
