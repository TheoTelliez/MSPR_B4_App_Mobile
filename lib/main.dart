import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payetonkawa/screens/homePage.dart';
import 'package:payetonkawa/screens/lifeCyclePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // check storage for token
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'jwt');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const LifeCycleManager(
        child: MaterialApp(
      home: HomePage(),
    ));
  }
}
