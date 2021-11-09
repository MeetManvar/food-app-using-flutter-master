import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference sellerBanner =
      FirebaseFirestore.instance.collection('shopkeeperbanner');

  CollectionReference shopkeepers = FirebaseFirestore.instance.collection('shopkeepers');

  getTopPickedStores() {
    return shopkeepers
        .where('isAccVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('isShopOpen', isEqualTo: true)
        //.orderBy('shopName', descending: false)
        .snapshots();
  }

  getAllStores() {
    return shopkeepers
        .where('isAccVerified', isEqualTo: true)
        //.orderBy('shopName')
        // .where('isShopOpen', isEqualTo: true)
        .snapshots();
  }

  getAllStoresQuery() {
    return shopkeepers
        .where('isAccVerified', isEqualTo: true);
        //.orderBy('shopName');
    // .where('isShopOpen', isEqualTo: true);
    // .orderBy('shopName')
  }

  Future<DocumentSnapshot>getShopDetails(sellerUid)async{
    DocumentSnapshot snapshot = await shopkeepers.doc(sellerUid).get();
    return snapshot;
  }
}
