import 'package:flutter/material.dart';

import 'package:band_names/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      initialRoute: "home",
      routes: {
        "home": (_) => HomePage()
      },
    );
  }
}

