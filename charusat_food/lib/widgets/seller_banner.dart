import 'package:carousel_slider/carousel_slider.dart';
import 'package:charusat_food/providers/store_provider.dart';
import 'package:charusat_food/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerBanner extends StatefulWidget {
  @override
  _SellerBannerState createState() => _SellerBannerState();
}

class _SellerBannerState extends State<SellerBanner> {
  int _index = 0;
  int _dataLength = 1;

  @override
  void didChangeDependencies() {
    var _storeprovider = Provider.of<StoreProvider>(context);
    getBannerImageFromDb(_storeprovider);

    super.didChangeDependencies();
  }

  Future getBannerImageFromDb(StoreProvider storeProvider) async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore
        .collection('shopkeeperbanner')
        .where('sellerUid', isEqualTo: storeProvider.storeDetails['uid'])
        .get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    var _storeprovider = Provider.of<StoreProvider>(context);

    StoreServices _services = StoreServices();
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getBannerImageFromDb(_storeprovider),
              builder: (_, snapShot) {
                return snapShot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: CarouselSlider.builder(
                            itemCount: snapShot.data.length,
                            itemBuilder: (context, int index) {
                              DocumentSnapshot sliderImage =
                                  snapShot.data[index];
                              Map getImage = sliderImage.data();
                              print('image::' + getImage.toString());
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.network(
                                    getImage['imageUrl'],
                                    fit: BoxFit.fill,
                                  ));
                            },
                            options: CarouselOptions(
                                viewportFraction: 1,
                                initialPage: 0,
                                autoPlay: true,
                                height: 180,
                                onPageChanged:
                                    (int i, carouselPageChangedReason) {
                                  setState(() {
                                    _index = i;
                                  });
                                })),
                      );
              },
            ),
          if (_dataLength != 0)
            DotsIndicator(
              dotsCount: _dataLength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  size: const Size.square(5.0),
                  activeSize: const Size(18.0, 5.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  activeColor: Theme.of(context).primaryColor),
            )
        ],
      ),
    );
  }
}
