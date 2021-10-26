import 'package:charusat_food/services/cart_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;

  CounterForCard(this.document);

  @override
  _CounterForCardState createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User user = FirebaseAuth.instance.currentUser;
  CartServices _cart = CartServices();

  int _qty = 1;
  String _docId;
  bool _exists = false;
  bool _updating = false;

  getCartData() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document.data()['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc['productId'] == widget.document.data()['productId']) {
                  setState(() {
                    _qty = doc['qty'];
                    _docId = doc.id;
                    _exists = true;
                  });
                }
              }),
            });
  }

  @override
  void initState() {
    getCartData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _exists
        ? Container(
            height: 28,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.pink),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                    });
                    if (_qty == 1) {
                      _cart.removeFromCart(_docId).then((value) {
                        setState(() {
                          _updating = false;
                          _exists = false;
                        });
                        _cart.checkData();
                      });
                    }
                    if (_qty > 1) {
                      setState(() {
                        _qty--;
                      });
                      _cart.updateCartQty(_docId, _qty).then((value) {
                        setState(() {
                          _updating = false;
                        });
                      });
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Icon(
                        _qty == 1 ? Icons.delete_outline : Icons.remove,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: 30,
                  color: Colors.pink,
                  child: Center(
                      child: _updating
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : Text(_qty.toString())),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                      _qty++;
                    });
                    _cart.updateCartQty(_docId, _qty).then((value) {
                      setState() {
                        _updating = false;
                      }
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Icon(
                        Icons.add,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : InkWell(
            onTap: () {
              EasyLoading.show(status: 'Adding to Catt');
              _cart.addToCart(widget.document).then((value) {
                setState(() {
                  _exists = true;
                });

                EasyLoading.showSuccess('Added to cart');
              });
            },
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Text('Add'),
                ),
              ),
            ),
          );
  }
}
