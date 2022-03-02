import 'package:flutter/material.dart';
import 'package:voting_dapp/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple))),
        appBarTheme: AppBarTheme(elevation: 0),
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
