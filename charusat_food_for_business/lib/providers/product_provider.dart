import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory;
  String selectedSubCategory;
  String categoryImage;
  File image;
  String pickerError;
  String shopName;
  String productUrl;

  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();

    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected.';
      print('No image selected.');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(filePath);
    var timestamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timestamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }

    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timestamp')
        .getDownloadURL();

    this.productUrl = downloadURL;
    notifyListeners();

    return downloadURL;

    // Within your widgets:
    // Image.network(downloadURL);
  }

  getShopName(shopName) {
    this.shopName = shopName;
    notifyListeners();
  }

  Future<void> saveProductDataToDb(
      {productName,
      description,
      price,
      comparedPrice,
      collection,
      brand,
      sku,
      weight,
      tax,
      stockQty,
      lowstockQty,
      context}) {
    var timestamp = DateTime.now().microsecondsSinceEpoch;
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(timestamp.toString()).set({
        'seller': {'shopName': this.shopName, 'sellerUid': user.uid},
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'sku': sku,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategoryName': this.selectedSubCategory,
          'categoryImage': this.categoryImage
        },
        'weight': weight,
        'tax': tax,
        'stockQty': stockQty,
        'lowstockQty': lowstockQty,
        'published': false,
        'productId': timestamp.toString(),
        'productImage': this.productUrl
      });
      this.alertDialog(
          context: context, // error probability
          title: 'Save Data',
          content: 'Product Details Saved Successfully');
    } catch (e) {
      this.alertDialog(
          context: context, // error probability
          title: 'Save Data',
          content: '${e.toString()}');
    }
    return null;
  }

  resetProvider() {
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.categoryImage = null;
    this.image = null;
    this.pickerError = null;
    this.shopName = null;
    this.productUrl = null;
    notifyListeners();
  }

  Future<void> updateProduct({
    productName,
    description,
    price,
    comparedPrice,
    collection,
    brand,
    sku,
    weight,
    tax,
    stockQty,
    lowstockQty,
    context,
    productId,
    image,
    category,
    subCategory,
    categoryImage,
  }) {
    var timestamp = DateTime.now().microsecondsSinceEpoch;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productId).update({
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'sku': sku,
        'category': {
          'mainCategory': category,
          'subCategoryName': subCategory,
          'categoryImage':
              this.categoryImage == null ? categoryImage : this.categoryImage
        },
        'weight': weight,
        'tax': tax,
        'stockQty': stockQty,
        'lowstockQty': lowstockQty,
        'productImage': this.productUrl == null ? image : this.productUrl
      });
      this.alertDialog(
          context: context, // error probability
          title: 'Save Data',
          content: 'Product Details Saved Successfully');
    } catch (e) {
      this.alertDialog(
          context: context, // error probability
          title: 'Save Data',
          content: '${e.toString()}');
    }
    return null;
  }
}
