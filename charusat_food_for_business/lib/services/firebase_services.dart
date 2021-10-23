import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  CollectionReference sellerBanner =
      FirebaseFirestore.instance.collection('shopkeeperbanner');

  Future<void> pulishProduct({id}) {
    return products.doc(id).update({'published': true});
  }

  Future<void> unPulishProduct({id}) {
    return products.doc(id).update({'published': false});
  }

  Future<void> deleteProduct({id}) {
    return products.doc(id).delete();
  }

  Future<void> saveBannertoDb(url) {
    return sellerBanner.add({'imageUrl': url, 'sellerUid': user.uid});
  }

  Future<void> deleteBanner({id}) {
    return sellerBanner.doc(id).delete();
  }
}
