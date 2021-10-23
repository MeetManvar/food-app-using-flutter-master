import 'dart:html';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:charusat_food_admin/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as db;

class CategoryCreateWidget extends StatefulWidget {
  @override
  _CategoryCreateWidgetState createState() => _CategoryCreateWidgetState();
}

class _CategoryCreateWidgetState extends State<CategoryCreateWidget> {
  bool _visible = false;

  FirebaseServices _services = FirebaseServices();

  var _fileNameTextController = TextEditingController();
  var _categoryNameTextController = TextEditingController();

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
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: TextField(
                        controller: _categoryNameTextController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1)),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'No category name given',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20)),
                      ),
                    ),
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
                          onPressed: () {
                            if (_categoryNameTextController.text.isEmpty) {
                              return _services.showMyDialog(
                                  context: context,
                                  title: 'Add new Category',
                                  message: 'New Category Name not given');
                            }
                            progressDialog.show();
                            print('url : $_url');

                            _services
                                .uploadCategoryImageToDb(
                                    url:
                                        'gs://charusat-food-app.appspot.com/categoryImage/2021-04-06 14:33:40.459',
                                    catName: _categoryNameTextController.text)
                                .then((downloadUrl) {
                              if (downloadUrl != null) {
                                progressDialog.dismiss();
                                _services.showMyDialog(
                                    context: context,
                                    title: 'New Category',
                                    message: 'Category Saved Successfully');
                              }
                            });
                            _categoryNameTextController.clear();
                            _fileNameTextController.clear();
                          },
                          child: Text("save new category")),
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
                  child: Text("Add new Category")),
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
    final path = 'categoryImage/$dateTime';

    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
          print(_url);
        });
        db
            .storage()
            .refFromURL('gs://charusat-food-app.appspot.com')
            .child(path)
            .put(file);
      }
    });
  }
}
