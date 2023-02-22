import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timer_tracker/app/landing_page.dart';
import 'package:timer_tracker/services/auth.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
        create:(context)=> Auth(),
        child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.indigo),
          title: "Timer tracker",
          home: const LandingPage(),
        ));
  }
}
