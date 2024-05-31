import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/firebase_options.dart';
import 'package:plant_app/screens/login.dart';
import 'package:plant_app/screens/registo.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: LoginPage(),
    debugShowCheckedModeBanner: false,
    )
  );
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant App',
      home: LoginPage(),
    );
  }
}