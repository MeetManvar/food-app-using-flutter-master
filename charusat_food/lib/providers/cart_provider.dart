import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charusat_food/services/cart_services.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  CartServices _cart = CartServices();
  double subtotal = 0.0;
  int cartQty = 0;
  QuerySnapshot snapshot;
  double saving = 0.0;

  Future<double> getCartTotal() async {
    var cartTotal = 0.0;
    var saving = 0.0;
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user.uid).collection('products').get();
    if (snapshot == null) {
      return null;
    }
    snapshot.docs.forEach((doc) {
      cartTotal = cartTotal + doc.data()['total'];
      saving =
          saving + ((doc.data()['comparedPrice'] - doc.data()['price']) > 0
              ? doc.data()['comparedPrice'] - doc.data()['price']
              : 0);
    });

    this.subtotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    this.saving = saving;
    notifyListeners();

    return cartTotal;
  }
}
