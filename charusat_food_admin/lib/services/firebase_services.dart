import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference sellers =
      FirebaseFirestore.instance.collection('shopkeepers');

  CollectionReference category =
      FirebaseFirestore.instance.collection('category');

  FirebaseStorage storage = FirebaseStorage.instance;
  Future<DocumentSnapshot> getAdminCredencials(id) {
    var result = FirebaseFirestore.instance.collection('Admin').doc(id).get();
    return result;
  }

  // Future<String> uploadBannerImageToDb(url) async {
  //   String downloadUrl = await storage.ref(url).getDownloadURL();
  //   if (downloadUrl != null) {
  //     firestore.collection('slider').add({'image': downloadUrl});
  //   }
  //   return downloadUrl;
  // }

  Future<String> uploadBannerImageToDb(url) async {
    print('finall $url');
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('slider').add({'image': downloadUrl});
    }
    return downloadUrl;
  }

// Future<String> uploadBannerImageToDbb(url) async {
//   String link;
//     // Points to the root reference
//     //
//     link2 = st
//     StorageReference dateRef = storageRef.child("/" + date+ ".csv");
//     link = dateRef.getDownloadUrl().toString();
//     return link;
//     String downloadUrl = await storage.ref('').getDownloadURL();
//     if (downloadUrl != null) {
//       firestore.collection('slider').add({'image': downloadUrl});
//     }
//     return downloadUrl;
//   }
  deleteBannerImagefromdb(id) async {
    firestore.collection('slider').doc(id).delete();
  }

  updateSellerStatus({id, status, statusName}) async {
    sellers.doc(id).update({statusName: status ? false : true});
  }

  //for category

  Future<String> uploadCategoryImageToDb({url, catName}) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      category.doc(catName).set({'image': downloadUrl, 'name': catName});
    }
    return downloadUrl;
  }

  // Future<Uri> uploadCat(url) async {
  //   StorageReference _postsReference =
  //       storage.ref().child('CategoryImage') as StorageReference;

  //   StorageReference _postFileRef = _postsReference.child(url);
  //   Uri _downloadURL = await _postFileRef.getDownloadURL();
  //   firestore.collection('slider').add({'image': downloadUrl});
  //   return _downloadURL;
  // }

  Future<void> confirmDeleteDialog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteBannerImagefromdb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
