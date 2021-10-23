import 'package:charusat_food_for_business/providers/auth_provider.dart';
import 'package:charusat_food_for_business/providers/product_provider.dart';
import 'package:charusat_food_for_business/screens/add_new_product_widget.dart';
import 'package:charusat_food_for_business/screens/home_screen.dart';
import 'package:charusat_food_for_business/screens/login_screen.dart';
import 'package:charusat_food_for_business/screens/register_screen.dart';
import 'package:charusat_food_for_business/screens/reset_password_screen.dart';
import 'package:charusat_food_for_business/screens/splash_screen.dart';
import 'package:charusat_food_for_business/screens/verify_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => AuthProvider()),
      Provider(create: (_) => ProductProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF84c225), fontFamily: 'Lato'),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        VerifyScreen.id: (context) => VerifyScreen(),
        AddNewProduct.id: (context) => AddNewProduct()
      },
    );
  }
}
