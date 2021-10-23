import 'package:charusat_food/providers/store_provider.dart';
import 'package:charusat_food/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:charusat_food/screens/product_list_screen.dart';

class SellerCategories extends StatefulWidget {
  @override
  _SellerCategoriesState createState() => _SellerCategoriesState();
}

class _SellerCategoriesState extends State<SellerCategories> {
  ProductServices _services = ProductServices();
  List _catList = [];

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _catList.add(doc['category']['mainCategory']);
        });
      });
    });
    //print(_store.storeDetails['uid']);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //print('cat : $_catList');
    var _storeProvider = Provider.of<StoreProvider>(context);

    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong...'),
          );
        }

        if (_catList.length == 0) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Container();
        }
        return SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12,right: 12,bottom: 10,top: 0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shop by Category',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(offset: Offset(2.0,2.0),blurRadius: 3.0,color: Colors.black)
                          ],
                            color: Colors.white,fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return _catList.contains(document.data()['name'])
                    ? InkWell(
                      onTap: (){
                        _storeProvider.selectedCategory(document.data()['name']);
                        pushNewScreenWithRouteSettings(
                          context, 
                          screen: ProductListScreen(), 
                          settings: RouteSettings(name:ProductListScreen.id),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          ); 
                      },
                      child: Container(
                        width: 120,
                        height: 150,
                        child: Card(
                          child: Column(
                            children: [
                              Center(
                                //child:Text("Hello"),
                                child: Image.network(document.data()['image']),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  document.data()['name'],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                    : Text('');
              }).toList(),
            ),
          ],
        ));
      },
    );
  }
}
