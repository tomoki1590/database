import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_datebase/db/database.dart';
import 'home_screen.dart';

late MyDatabase database;


void main()  {
database=MyDatabase();
runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "単語帳",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: ("lanobe"),

      ),
      home: HomeScreen(),
    );
  }
}
