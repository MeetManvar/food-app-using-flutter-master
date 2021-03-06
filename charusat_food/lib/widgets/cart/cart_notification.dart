import 'package:charusat_food/providers/cart_provider.dart';
import 'package:charusat_food/screens/cart_screen.dart';
import 'package:charusat_food/services/cart_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CartNotification extends StatefulWidget {
  //const CartNotification({ Key? key }) : super(key: key);

  @override
  _CartNotificationState createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
  CartServices _cart = CartServices();
  DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    _cart.getShopName().then((value) {
      setState(() {
        document = value;
        print("Mahadev");
        print(document.data());
      });
    });

    return Visibility(
      visible: _cartProvider.cartQty > 0 ? true : false,
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${_cartProvider.cartQty}${_cartProvider.cartQty == 1 ? ' Item ' : " Items "} ",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "  |  ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "\$${_cartProvider.subtotal.toStringAsFixed(0)}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (document.exists)
                      Text(
                        "From  ${document.data()["shopName"]}",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // pushNewScreenwithRouteSetting(context, screen: CartScreen(), setting:RouteSettings())
                  pushNewScreenWithRouteSettings(context,
                      screen: CartScreen(
                        document: document,
                      ),
                      settings: RouteSettings(name: CartScreen.id),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                child: Container(
                  child: Row(
                    children: [
                      Text(
                        "View Cart",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
