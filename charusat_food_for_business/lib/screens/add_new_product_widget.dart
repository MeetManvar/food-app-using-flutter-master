import 'dart:io';

import 'package:charusat_food_for_business/providers/product_provider.dart';
import 'package:charusat_food_for_business/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'add-new-product';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formkey = GlobalKey<FormState>();
  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];

  String dropDownValue;

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _stockTextController = TextEditingController();

  File _image;
  bool _visible = false;
  bool _track = false;
  String productName;
  String description;
  double price;
  double comparedPrice;
  String sku;
  String weight;
  double tax;
  int stockQty;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formkey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text('Products / Add'),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            if (_categoryTextController.text.isNotEmpty) {
                              if (_subCategoryTextController.text.isNotEmpty) {
                                if (_image != null) {
                                  EasyLoading.show(status: 'Saving...');
                                  _provider
                                      .uploadProductImage(
                                          _image.path, productName)
                                      .then((url) {
                                    if (url != null) {
                                      EasyLoading.dismiss();
                                      _provider.saveProductDataToDb(
                                          context: context,
                                          comparedPrice: int.parse(
                                              _comparedPriceTextController
                                                  .text),
                                          brand: _brandTextController.text,
                                          collection: dropDownValue,
                                          description: description,
                                          lowstockQty: int.parse(
                                              _lowStockTextController.text),
                                          price: price,
                                          sku: sku,
                                          stockQty: int.parse(
                                              _stockTextController.text),
                                          tax: tax,
                                          weight: weight,
                                          productName: productName);
                                      setState(() {
                                        _formkey.currentState.reset();
                                        _comparedPriceTextController.clear();
                                        dropDownValue = null;
                                        _subCategoryTextController.clear();
                                        _categoryTextController.clear();
                                        _brandTextController.clear();
                                        _track = false;
                                        _image = null;
                                        _visible = false;
                                      });
                                    } else {
                                      _provider.alertDialog(
                                          context: context,
                                          title: 'Image Upload',
                                          content: 'Failed to Upload image');
                                    }
                                  });
                                } else {
                                  _provider.alertDialog(
                                      context: context,
                                      title: 'Product Name',
                                      content: 'Product Image is not selected');
                                }
                              } else {
                                _provider.alertDialog(
                                    context: context,
                                    title: 'Sub Category',
                                    content: 'Sub Category not selected');
                              }
                            } else {
                              _provider.alertDialog(
                                  context: context,
                                  title: 'Main Category',
                                  content: 'Main Category not selected');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black54,
                  labelColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(
                      text: 'GENERAL',
                    ),
                    Tab(
                      text: 'INVENTORY',
                    )
                  ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Product Name';
                                      }
                                      setState(() {
                                        productName = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Product Name',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLength: 500,
                                    maxLines: 5,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Description';
                                      }
                                      setState(() {
                                        description = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'About Product',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        _provider
                                            .getProductImage()
                                            .then((image) {
                                          setState(() {
                                            _image = image;
                                          });
                                        });
                                      },
                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Card(
                                          child: Center(
                                            child: _image == null
                                                ? Text('select image')
                                                : Image.file(_image),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter selling price';
                                      }
                                      setState(() {
                                        price = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Price',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
                                  ),
                                  TextFormField(
                                    controller: _comparedPriceTextController,
                                    validator: (value) {
                                      if (price > double.parse(value)) {
                                        return 'Compared price should be higher';
                                      }
                                      setState(() {
                                        comparedPrice = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Compared Price',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
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
                                                value: value,
                                                child: Text(value));
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _brandTextController,
                                    decoration: InputDecoration(
                                        labelText: 'Brand',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter SKU';
                                      }
                                      setState(() {
                                        sku = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'SKU',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 10),
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
                                              controller:
                                                  _categoryTextController,
                                              decoration: InputDecoration(
                                                  hintText: 'not selected',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      300]))),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.edit_outlined),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CategoryList();
                                                  }).whenComplete(() {
                                                setState(() {
                                                  _categoryTextController.text =
                                                      _provider
                                                          .selectedCategory;
                                                  _visible = true;
                                                });
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Sub Category',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
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
                                                controller:
                                                    _subCategoryTextController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    hintText: 'not selected',
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.grey[
                                                                        300]))),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.edit_outlined),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SubCategoryList();
                                                    }).whenComplete(() {
                                                  setState(() {
                                                    _subCategoryTextController
                                                            .text =
                                                        _provider
                                                            .selectedSubCategory;
                                                  });
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter weight';
                                      }
                                      setState(() {
                                        weight = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Weight e.g. kg, gram',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter tax';
                                      }
                                      setState(() {
                                        tax = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Tax',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]))),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SwitchListTile(
                                onChanged: (selected) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                },
                                title: Text('Track inventory'),
                                value: _track,
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text(
                                  'Switch on to track inventory',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Visibility(
                                visible: _track,
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _stockTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Inventory Quantity*',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey[300]))),
                                          ),
                                          TextField(
                                            controller: _lowStockTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Inventory Low Stock Quantity',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey[300]))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
