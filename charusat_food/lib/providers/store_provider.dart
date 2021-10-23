import 'package:charusat_food/screens/welcome_screen.dart';
import 'package:charusat_food/services/store_services.dart';
import 'package:charusat_food/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class StoreProvider with ChangeNotifier {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;

  String selectedStore;
  String selectedStoreId;
  DocumentSnapshot storeDetails;
  String distance = '';
  String selectedProductCategory;

  getSelectedStore(storeDetails, distance) {
    this.distance = distance;
    this.storeDetails = storeDetails;
    notifyListeners();
  }
  selectedCategory(category) {
    this.selectedProductCategory = category;
    notifyListeners();
  }

  Future<void> getUserLocationData(context) async {
    _userServices.getUserbyId(user.uid).then((result) {
      if (user != null) {
        this.userLatitude = result.data()['latitude'];
        this.userLongitude = result.data()['longitude'];
        notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
  }
}
