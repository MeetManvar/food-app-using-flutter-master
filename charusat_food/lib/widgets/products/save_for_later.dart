import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaveForLater extends StatefulWidget {
  final DocumentSnapshot document;
  SaveForLater(this.document);
  
  @override
  _SaveForLaterState createState() => _SaveForLaterState();
}

class _SaveForLaterState extends State<SaveForLater> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.grey[900],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
