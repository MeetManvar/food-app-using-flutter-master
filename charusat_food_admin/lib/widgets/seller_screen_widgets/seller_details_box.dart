import 'package:charusat_food_admin/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellerDetailsBox extends StatefulWidget {
  final String uid;
  SellerDetailsBox(this.uid);

  @override
  _SellerDetailsBoxState createState() => _SellerDetailsBoxState();
}

class _SellerDetailsBoxState extends State<SellerDetailsBox> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _services.sellers.doc(widget.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something Went Wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .75,
                  width: MediaQuery.of(context).size.width * .3,
                  child: ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                snapshot.data['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data['shopName'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(snapshot.data['subtext']),
                            ],
                          )
                        ],
                      ),
                      Divider(
                        thickness: 4,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text('Contact number'),
                                )),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(':'),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data['mobile']),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text('Email'),
                                )),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(':'),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data['email']),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text('Address'),
                                )),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(':'),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data['address']),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text('Top Pick Status'),
                                )),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(':'),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        child: snapshot.data['isTopPicked']
                                            ? Chip(
                                                backgroundColor: Colors.green,
                                                label: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      'Top Picked',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ))
                                            : Container())),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Wrap(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.money_dollar_circle,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Revenue'),
                                          Text('12000')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Active Orders'),
                                          Text('10')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_bag,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Orders'),
                                          Text('100')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.grade_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Products'),
                                          Text('160')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.list_alt_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Statement'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: snapshot.data['isAccVerified']
                      ? Chip(
                          backgroundColor: Colors.green,
                          label: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'Active',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ))
                      : Chip(
                          backgroundColor: Colors.red,
                          label: Row(
                            children: [
                              Icon(
                                Icons.remove_circle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'InActive',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
