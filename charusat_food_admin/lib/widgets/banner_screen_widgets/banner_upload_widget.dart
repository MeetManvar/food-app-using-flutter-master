import 'dart:html';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:charusat_food_admin/services/firebase_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class BannerUploadWidget extends StatefulWidget {
  @override
  _BannerUploadWidgetState createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {
  bool _visible = false;
  FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseServices _services = FirebaseServices();

  var _fileNameTextController = TextEditingController();

  bool _imageSelected = true;

  String _url;

  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF84c225).withOpacity(0.6),
        animationDuration: Duration(milliseconds: 500));

    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                          width: 300,
                          height: 30,
                          child: TextField(
                            controller: _fileNameTextController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'No image selected',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 20)),
                          )),
                    ),
                    ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.black54),
                        onPressed: () {
                          uploadToStorage();
                        },
                        child: Text("upload image")),
                    SizedBox(
                      width: 10,
                    ),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: _imageSelected
                                  ? Colors.black12
                                  : Colors.black54),
                          onPressed: () async {
                            print('url : $_url');

                            progressDialog.show();
                            _services
                                .uploadBannerImageToDb(
                                    'gs://charusat-food-app.appspot.com/$_url')
                                .then((downloadUrl) {
                              if (downloadUrl != null) {
                                progressDialog.dismiss();
                                _services.showMyDialog(
                                    context: context,
                                    title: 'New Banner Add',
                                    message: 'Banner Image Saved Successfully');
                              }
                            });
                          },
                          child: Text("save image")),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ? false : true,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black54),
                  onPressed: () {
                    setState(() {
                      _visible = true;
                    });
                  },
                  child: Text("Add new banner")),
            ),
          ],
        ),
      ),
    );
  }

  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  void uploadToStorage() {
    final dateTime = DateTime.now();
    final path = 'bannerImage/$dateTime';

    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
          print(_url);
        });
        fb
            .storage()
            .refFromURL('gs://charusat-food-app.appspot.com')
            .child(path)
            .put(file);
      }
    });
  }
}
