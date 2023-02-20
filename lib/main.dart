import 'package:flutter/material.dart';
import 'package:timer_tracker/app/signin/sign_in_page.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: "Timer tracker",
      home:const SignInPage(),
    ) ;
  }
}