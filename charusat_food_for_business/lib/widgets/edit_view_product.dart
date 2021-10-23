import 'dart:io';

import 'package:charusat_food_for_business/providers/product_provider.dart';
import 'package:charusat_food_for_business/services/firebase_services.dart';
import 'package:charusat_food_for_business/widgets/category_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;
  EditViewProduct({this.productId});

  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formkey = GlobalKey<FormState>();
  var _brandText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _taxTextController = TextEditingController();

  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];

  String dropDownValue;

  String image;
  String categoryImage;

  File _image;
  bool _visible = false;
  DocumentSnapshot doc;

  bool _editing = true;

  double discount;
  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _brandText.text = document.data()['brand'];
          _skuText.text = document.data()['sku'];
          _productNameText.text = document.data()['productName'];
          _priceText.text = document.data()['price'].toString();
          _comparedPriceText.text = document.data()['comparedPrice'].toString();

          _weightText.text = document.data()['weight'];
          _descriptionText.text = document.data()['description'];
          _categoryTextController.text =
              document.data()['category']['mainCategory'];
          _subCategoryTextController.text =
              document.data()['category']['subCategoryName'];

          var differance = int.parse(_comparedPriceText.text) -
              double.parse(_priceText.text);
          discount = (differance / int.parse(_comparedPriceText.text) * 100);
          image = document.data()['productImage'];

          dropDownValue = document.data()['collection'];
          _lowStockTextController.text =
              document.data()['lowstockQty'].toString();

          _taxTextController.text = document.data()['tax'].toString();

          _stockTextController.text = document.data()['stockQty'].toString();
          categoryImage = document.data()['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                setState(() {
                  _editing = false;
                });
              })
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )),
            Expanded(
                child: AbsorbPointer(
              absorbing: _editing,
              child: InkWell(
                onTap: () {
                  if (_formkey.currentState.validate()) {
                    EasyLoading.show(status: 'Saving...');
                    if (_image != null) {
                      _provider
                          .uploadProductImage(
                              _image.path, _productNameText.text)
                          .then((url) {
                        if (url != null) {
                          EasyLoading.dismiss();
                          _provider.updateProduct(
                              context: context,
                              productName: _productNameText.text,
                              weight: _weightText.text,
                              tax: double.parse(_taxTextController.text),
                              stockQty: int.parse(_stockTextController.text),
                              sku: _skuText.text,
                              price: double.parse(_priceText.text),
                              lowstockQty:
                                  int.parse(_lowStockTextController.text),
                              description: _descriptionText.text,
                              collection: dropDownValue,
                              brand: _brandText.text,
                              comparedPrice: int.parse(_comparedPriceText.text),
                              productId: widget.productId,
                              image: image,
                              category: _categoryTextController.text,
                              subCategory: _subCategoryTextController.text,
                              categoryImage: categoryImage);
                        }
                      });
                    } else {
                      _provider.updateProduct(
                          context: context,
                          productName: _productNameText.text,
                          weight: _weightText.text,
                          tax: double.parse(_taxTextController.text),
                          stockQty: int.parse(_stockTextController.text),
                          sku: _skuText.text,
                          price: double.parse(_priceText.text),
                          lowstockQty: int.parse(_lowStockTextController.text),
                          description: _descriptionText.text,
                          collection: dropDownValue,
                          brand: _brandText.text,
                          comparedPrice: int.parse(_comparedPriceText.text),
                          productId: widget.productId,
                          image: image,
                          category: _categoryTextController.text,
                          subCategory: _subCategoryTextController.text,
                          categoryImage: categoryImage);
                      EasyLoading.dismiss();
                    }
                    _provider.resetProvider();
                  }
                },
                child: Container(
                  color: Theme.of(context).primaryColor.withOpacity(.9),
                  child: Center(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                height: 30,
                                child: TextFormField(
                                  controller: _brandText,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      hintText: 'Brand',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.1)),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('SKU : '),
                                  Container(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _skuText,
                                      style: TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none),
                              controller: _productNameText,
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none),
                              controller: _weightText,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: '\₹'),
                                  controller: _priceText,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: '\₹'),
                                  controller: _comparedPriceText,
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.red),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    '${(discount).toStringAsFixed(0)} % OFF',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Inclusive of all Taxes',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _image != null
                                  ? Image.file(
                                      _image,
                                      height: 300,
                                    )
                                  : Image.network(image, height: 300),
                            ),
                          ),
                          Text(
                            'About this product',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLines: null,
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.grey),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'select category';
                                        }

                                        return null;
                                      },
                                      controller: _categoryTextController,
                                      decoration: InputDecoration(
                                          hintText: 'not selected',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]))),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _editing ? false : true,
                                  child: IconButton(
                                      icon: Icon(Icons.edit_outlined),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _categoryTextController.text =
                                                _provider.selectedCategory;
                                            _visible = true;
                                          });
                                        });
                                      }),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Sub Category',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'select sub category';
                                          }

                                          return null;
                                        },
                                        controller: _subCategoryTextController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: 'not selected',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[300]))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.edit_outlined),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SubCategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _subCategoryTextController.text =
                                                _provider.selectedSubCategory;
                                          });
                                        });
                                      })
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Collection',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  hint: Text('Select Collection'),
                                  value: dropDownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (String value) {
                                    setState(() {
                                      dropDownValue = value;
                                    });
                                  },
                                  items: _collections
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value, child: Text(value));
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('Stock : '),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none),
                                  controller: _stockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Low Stock : '),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none),
                                  controller: _lowStockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Tax % : '),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none),
                                  controller: _taxTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
