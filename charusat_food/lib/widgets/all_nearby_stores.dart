import 'package:charusat_food/providers/store_provider.dart';
import 'package:charusat_food/screens/constants.dart';
import 'package:charusat_food/screens/seller_home_screen.dart';
import 'package:charusat_food/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AllNearByStores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    PaginateRefreshedChangeListener refreshedChangeListener =
        PaginateRefreshedChangeListener();

    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);
    String getDistance(location) {
      var distance = Geolocator.distanceBetween(_storeData.userLatitude,
          _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _storeServices.getAllStores(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
            if (!snapShot.hasData) return CircularProgressIndicator();
            List shopDistance = [];
            for (int i = 0; i <= snapShot.data.docs.length - 1; i++) {
              var distance = Geolocator.distanceBetween(
                  _storeData.userLatitude,
                  _storeData.userLongitude,
                  snapShot.data.docs[i]['location'].latitude,
                  snapShot.data.docs[i]['location'].longitude);
              var distanceInKm = distance / 1000;
              shopDistance.add(distanceInKm);
            }
            shopDistance.sort();
            // if (shopDistance[0] > 10) {
            //   return Container(
            //     child: Stack(
            //       children: [
            //         Center(
            //           child: Text(
            //             'End of Page',
            //             style: TextStyle(color: Colors.grey),
            //           ),
            //         ),
            //         // Image.asset(
            //         //   'images/city.png',
            //         //   color: Colors.black12,
            //         // ),
            //         // Positioned(
            //         //   right: 10,
            //         //   top: 80,
            //         //   child: Container(
            //         //     width: 100,
            //         //     child: Column(
            //         //       crossAxisAlignment: CrossAxisAlignment.start,
            //         //       children: [
            //         //         Text(
            //         //           "Made By ",
            //         //           style: TextStyle(color: Colors.black54),
            //         //         ),
            //         //         Text(
            //         //           'Raj Parmar',
            //         //           style: TextStyle(
            //         //               fontWeight: FontWeight.bold,
            //         //               fontFamily: 'Anton',
            //         //               letterSpacing: 2,
            //         //               color: Colors.grey),
            //         //         )
            //         //       ],
            //         //     ),
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   );
            // }
            return Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RefreshIndicator(
                    child: PaginateFirestore(
                      bottomLoader: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                                    'All Stores',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Colors.black)
                                        ],
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilderType: PaginateBuilderType.listView,
                      itemBuilder: (index, context, document) {
                        return InkWell(
                          onTap: () {
                            _storeData.getSelectedStore(
                                document, getDistance(document['location']));
                            pushNewScreenWithRouteSettings(
                              context,
                              settings:
                                  RouteSettings(name: SellerHomeScreen.id),
                              screen: SellerHomeScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Card(
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          document['imageUrl'],
                                          fit: BoxFit.cover,
                                        ),
                                      ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          document.data()['shopName'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        document.data()['subtext'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: kStoreCardStyle,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                250,
                                        child: Text(document.data()['address'],
                                            overflow: TextOverflow.ellipsis,
                                            style: kStoreCardStyle),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          '${getDistance(document['location'])} KM',
                                          overflow: TextOverflow.ellipsis,
                                          style: kStoreCardStyle),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      query: _storeServices.getAllStoresQuery(),
                      listeners: [refreshedChangeListener],
                      // footer: Padding(
                      //   padding: const EdgeInsets.only(top: 30),
                      //   child:
                      // ),
                    ),
                    onRefresh: () async {
                      refreshedChangeListener.refreshed = true;
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
