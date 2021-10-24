import 'package:charusat_food/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UpdateProfile extends StatefulWidget {
  static const String id = "Update-Profile";
  
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formkey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser;
  UserServices _user = UserServices();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var mobile = TextEditingController();
  var Email = TextEditingController();

  updateProfile() {
  //  if (_formkey.currentState.validate()) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        'firstName': firstName.text,
        'lastName': lastName.text,
        'email': Email.text,
       // 'mobile': mobile.text,
      });
   // }
  }

  @override
  void initState() {
    _user.getUserbyId(user.uid).then((value) {
      if (mounted) {
        setState(() {
           firstName.text = value.data()['firstName'];
         lastName.text = value.data()['lastName'];
         Email.text = value.data()['email'];
        mobile.text = user.phoneNumber;
        });
      }
    });
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
              // builder: EasyLoading.init(),

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomSheet: InkWell(
        onTap: () {
           if (_formkey.currentState.validate()) {
          //   EasyLoading.init();
           EasyLoading.show(status: "Updating Profile...");
          updateProfile().then((value){
            EasyLoading.showSuccess("Updated Successfully");
            Navigator.pop(context);
            
          });
           }
          
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: Center(
              child: Text(
            "Update",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: firstName,
                    decoration: InputDecoration(
                        labelText: "First Name",
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.zero),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter First Name";
                      }
                      return null;
                    },
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: TextFormField(
                    controller: lastName,
                    decoration: InputDecoration(
                        labelText: "Last Name",
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.zero),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Last Name";
                      }
                      return null;
                    },
                  ))
                ],
              ),
              SizedBox(
                width: 40,
              ),
              TextFormField(
                controller: mobile,
                enabled: false,
                decoration: InputDecoration(
                    labelText: "Mobile",
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Mobile Number";
                  }
                  return null;
                },
              ),
              SizedBox(
                width: 40,
              ),
              TextFormField(
                controller: Email,
                decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Email Address";
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
    
  }
}
