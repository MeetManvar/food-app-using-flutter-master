import 'package:charusat_food/providers/cart_provider.dart';
import 'package:charusat_food/services/store_services.dart';
import 'package:charusat_food/widgets/cart/cart_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
//const CartScreen({ Key? key }) : super(key: key);
  static const String id = "cart-screen";
  final DocumentSnapshot document;
  CartScreen({this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices _store = StoreServices();
  DocumentSnapshot doc;
  var textStyle = TextStyle(color: Colors.grey);
  int deliveryFee = 50;

  @override
  void initState() {
    _store.getShopDetails(widget.document.data()['sellerUid']).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    var _payable = _cartProvider.subtotal + deliveryFee;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomSheet: Container(
        height: 60,
        color: Colors.blueGrey[900],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "\₹${_cartProvider.subtotal.toStringAsFixed(0)}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Including Taxes",
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text(
                    "CheckOut",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.redAccent,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBozIsSxrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document.data()['shopName'],
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        "${_cartProvider.cartQty} ${_cartProvider.cartQty > 1 ? 'Items' : 'Item'}",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        "To Pay : \₹ ${_cartProvider.subtotal.toStringAsFixed(0)}",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
        body: _cartProvider.cartQty>0 ? SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 80),
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                if (doc != null)
                  ListTile(
                    tileColor: Colors.white,
                    leading: Container(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            doc.data()['imageUrl'],
                            fit: BoxFit.cover,
                          )),
                    ),
                    title: Text(doc.data()['shopName']),
                    subtitle: Text(
                      doc.data()['address'],
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                CartList(
                  document: widget.document,
                ),
                SizedBox(height: 10),
                /*Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:10,right:10,left: 10),
                  child: Row(
                    children: [
                    TextField(),
                    
                  ],),
                ),
              )*/

                //bill details card
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bill Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Cart Value',
                                  style: textStyle,
                                )),
                                Text(
                                    '\₹ ${_cartProvider.subtotal.toStringAsFixed(0)}',
                                    style: textStyle),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Delivery Fee',
                                  style: textStyle,
                                )),
                                Text('\₹ $deliveryFee', style: textStyle),
                              ],
                            ),
                            Divider(color: Colors.grey),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Total Amount',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Text(
                                  '\₹ ${_payable.toStringAsFixed(0)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Total Saving',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    Text(
                                      '\₹ ${_cartProvider.saving.toStringAsFixed(0)}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        :Center(child: Text('Cart Empty, Continue Shopping'),),
      ),
    );
  }
}
