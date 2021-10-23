import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference sellerBanner =
      FirebaseFirestore.instance.collection('shopkeeperbanner');

  getTopPickedStores() {
    return FirebaseFirestore.instance
        .collection('shopkeepers')
        .where('isAccVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('isShopOpen', isEqualTo: true)
        //.orderBy('shopName', descending: false)
        .snapshots();
  }

  getAllStores() {
    return FirebaseFirestore.instance
        .collection('shopkeepers')
        .where('isAccVerified', isEqualTo: true)
        // .where('isShopOpen', isEqualTo: true)
        // .orderBy('shopName')
        .snapshots();
  }

  getAllStoresQuery() {
    return FirebaseFirestore.instance
        .collection('shopkeepers')
        .where('isAccVerified', isEqualTo: true);
    // .where('isShopOpen', isEqualTo: true);
    // .orderBy('shopName')
  }
}
