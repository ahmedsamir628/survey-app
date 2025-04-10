import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Survey App',
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
