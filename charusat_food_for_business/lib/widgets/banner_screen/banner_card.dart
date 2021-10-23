import 'package:charusat_food_for_business/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BannerCard extends StatelessWidget {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _services.sellerBanner.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                        child: Image.network(
                      document['imageUrl'],
                      fit: BoxFit.fill,
                    )),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              EasyLoading.show(status: 'Deleting...');
                              _services.deleteBanner(id: document.id);
                              EasyLoading.dismiss();
                            }),
                      ))
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
