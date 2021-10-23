import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:charusat_food_admin/screens/home_screen.dart';
import 'package:charusat_food_admin/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final _formkey = GlobalKey<FormState>();

  FirebaseServices _services = FirebaseServices();

  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  // String username;
  // String password;

  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF84c225).withOpacity(0.6),
        animationDuration: Duration(milliseconds: 500));

    _login({username, password}) async {
      progressDialog.show();
      _services.getAdminCredencials(username).then((value) async {
        if (value.exists) {
          if (value.data()['username'] == username) {
            if (value.data()['password'] == password) {
              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInAnonymously();
                if (userCredential != null) {
                  progressDialog.dismiss();
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              } catch (e) {
                progressDialog.dismiss();
                _showMyDialog(title: 'Login', message: '${e.toString()}');
              }
              return;
            }
            progressDialog.dismiss();
            _showMyDialog(
                title: 'incorrect password',
                message: 'password entered is invalid');
            return;
          }
          progressDialog.dismiss();
          _showMyDialog(
              title: 'invalid username',
              message: 'username entered is invalid');
        }
        progressDialog.dismiss();
        _showMyDialog(
            title: 'invalid username', message: 'username entered is invalid');
      });
    }

    // Future<void> _login() async {
    //   progressDialog.show(); // show dialog

    //   _services.getAdminCredencials().then((value) {
    //     value.docs.forEach((doc) async {
    //       if (doc.get('username') == username) {
    //         if (doc.get('password') == password) {
    //           UserCredential userCredential =
    //               await FirebaseAuth.instance.signInAnonymously();
    //           progressDialog.dismiss();
    //           if (userCredential.user.uid != null) {
    //             Navigator.pushReplacement(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (BuildContext context) => HomeScreen()));
    //             return;
    //           } else {
    //             _showMyDialog(title: 'Login', message: 'Login failed');
    //           }
    //         } else {
    //           progressDialog.dismiss(); //close dialog

    //           _showMyDialog(
    //               title: 'Invalid Password',
    //               message: 'Password you entered is invalid');
    //         }
    //       } else {
    //         progressDialog.dismiss();
    //         _showMyDialog(
    //             title: 'Invalid Username',
    //             message: 'Username you entered is invalid');
    //       }
    //     });
    //   });
    // }

    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   centerTitle: true,
        //   title: Text(
        //     widget.title,
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        body: FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text('Connection Failed'));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF84c225), Colors.white],
                    stops: [1.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 0.0))),
            child: Center(
              child: Container(
                width: 300,
                height: 500,
                child: Card(
                    elevation: 6,
                    shape: Border.all(color: Colors.green, width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Image.asset('images/chef.png'),
                                  Text(
                                    'CHARUSAT Food Admin',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _usernameTextController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Username';
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: 'Username',
                                        contentPadding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2))),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _passwordTextController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Password';
                                      }
                                      if (value.length < 6) {
                                        return 'Minimun 6 characters required';
                                      }

                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        // helperText: 'Min 6 characters',
                                        prefixIcon: Icon(Icons.lock),
                                        labelText: 'Password',
                                        contentPadding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2))),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formkey.currentState.validate()) {
                                          _login(
                                              username:
                                                  _usernameTextController.text,
                                              password:
                                                  _passwordTextController.text);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context)
                                            .primaryColor, // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                      child: Text('login')),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }

  Future<void> _showMyDialog({title, message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text('Please Try Again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
