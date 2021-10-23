import 'package:charusat_food_admin/services/firebase_services.dart';
import 'package:charusat_food_admin/widgets/seller_screen_widgets/seller_details_box.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerDataTable extends StatefulWidget {
  @override
  _SellerDataTableState createState() => _SellerDataTableState();
}

class _SellerDataTableState extends State<SellerDataTable> {
  List<DataRow> _sellerDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newlist = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          IconButton(
            onPressed: () {
              services.updateSellerStatus(
                  id: document.data()['uid'],
                  status: document.data()['isAccVerified'],
                  statusName: 'isAccVerified');
            },
            icon: document.data()['isAccVerified']
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.grey,
                  ),
          ),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              services.updateSellerStatus(
                  id: document.data()['uid'],
                  status: document.data()['isTopPicked'],
                  statusName: 'isTopPicked');
            },
            icon: document.data()['isTopPicked']
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.grey,
                  ),
          ),
        ),
        DataCell(Text(document.data()['shopName'])),
        DataCell(Row(
          children: [
            Icon(Icons.star),
            Text('3.4'),
          ],
        )),
        DataCell(Text('2000')),
        DataCell(Text(document.data()['mobile'])),
        DataCell(Text(document.data()['email'])),
        DataCell(IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SellerDetailsBox(document.data()['uid']);
                  });
            }))
      ]);
    }).toList();
    return newlist;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    int tag = 0;
    List<String> options = [
      'All Shops',
      'Active',
      'Inactive',
      'Top Picked',
      'Top Rated',
    ];

    filter(val) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
            });
            filter(val);
          },
          choiceItems: C2Choice.listFrom<int, String>(
            activeStyle: (i, v) {
              return C2ChoiceStyle(
                  brightness: Brightness.dark, color: Colors.black54);
            },
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
        Divider(
          thickness: 5,
        ),
        StreamBuilder(
            stream: _services.sellers
                .orderBy('shopName', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    showBottomBorder: true,
                    dataRowHeight: 60,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.grey[200]),
                    columns: <DataColumn>[
                      DataColumn(label: Text('Active/Inactive')),
                      DataColumn(label: Text('Top Picked')),
                      DataColumn(label: Text('Shop Name')),
                      DataColumn(label: Text('Rating')),
                      DataColumn(label: Text('Total Sales')),
                      DataColumn(label: Text('Mobile')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('View Details')),
                    ],
                    rows: _sellerDetailsRows(snapshot.data, _services)),
              );
            }),
      ],
    );
  }
}
