import 'dart:io';

import 'package:charusat_food_for_business/providers/product_provider.dart';
import 'package:charusat_food_for_business/services/firebase_services.dart';
import 'package:charusat_food_for_business/widgets/banner_screen/banner_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BannerScreen extends StatefulWidget {
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File _image;
  var _imagePathText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: [
        BannerCard(),
        Divider(
          thickness: 3,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Center(
            child: Text(
              'ADD NEW BANNER',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Card(
                    child: _image != null
                        ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                        : Center(
                            child: Text('No Image Selected'),
                          ),
                    color: Colors.grey[200],
                  ),
                ),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _visible ? false : true,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _visible = true;
                            });
                          },
                          child: Text('Add New Banner'),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  getBannerImage().then((value) {
                                    if (_image != null) {
                                      setState(() {
                                        _imagePathText.text = _image.path;
                                      });
                                    }
                                  });
                                },
                                child: Text('Upload Image'),
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: _image != null ? false : true,
                                child: ElevatedButton(
                                  onPressed: () {
                                    EasyLoading.show(status: 'Saving...');
                                    uploadBannerImage(
                                            _image.path, _provider.shopName)
                                        .then((url) {
                                      if (url != null) {
                                        _services.saveBannertoDb(url);
                                        setState(() {
                                          _imagePathText.clear();
                                          _image = null;
                                        });
                                        EasyLoading.dismiss();
                                        _provider.alertDialog(
                                            content:
                                                'Banner Uploaded Successfully',
                                            context: context,
                                            title: 'Banner Upload');
                                      } else {
                                        EasyLoading.dismiss();

                                        _provider.alertDialog(
                                            content: 'Banner Upload Failed',
                                            context: context,
                                            title: 'Banner Upload');
                                      }
                                    });
                                  },
                                  child: Text('Save'),
                                  style: ElevatedButton.styleFrom(
                                    primary: _image != null
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _visible = false;
                                    _imagePathText.clear();
                                    _image = null;
                                  });
                                },
                                child: Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Future<File> getBannerImage() async {
    final picker = ImagePicker();

    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
    return _image;
  }

  Future<String> uploadBannerImage(filePath, shopName) async {
    File file = File(filePath);
    var timestamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('sellerBanner/$shopName/$timestamp').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }

    String downloadURL = await _storage
        .ref('sellerBanner/$shopName/$timestamp')
        .getDownloadURL();

    return downloadURL;

    // Within your widgets:
    // Image.network(downloadURL);
  }
}
