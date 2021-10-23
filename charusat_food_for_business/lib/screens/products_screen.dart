import 'package:charusat_food_for_business/screens/add_new_product_widget.dart';
import 'package:charusat_food_for_business/widgets/published_unpublished_widget/published_product.dart';
import 'package:charusat_food_for_business/widgets/published_unpublished_widget/unpublished_product.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
          body: Column(
        children: [
          Material(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text('Products'),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            maxRadius: 8,
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "20",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add new',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AddNewProduct.id);
                    },
                  )
                ],
              ),
            ),
          ),
          TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black54,
              labelColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(
                  text: 'PUBLISHED',
                ),
                Tab(
                  text: 'UNPUBLISHED',
                )
              ]),
          Expanded(
            child: Container(
              child: TabBarView(
                  children: [PublishedProducts(), UnPublishedProducts()]),
            ),
          )
        ],
      )),
    );
  }
}
