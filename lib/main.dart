import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/food/home_food.dart';
import 'package:flutter_application_1/app/user/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginScreen());

    // return MaterialApp(home: MyHomePage(title: 'Food'));

    //  users
    // return MaterialApp(home: Home());
  }
}
