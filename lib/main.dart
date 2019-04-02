import 'package:flutter/material.dart';
import 'package:flutter_sqlite/screens/NoteList.dart';
import 'package:flutter_sqlite/screens/NoteDetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Keeper',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
//      home: NoteList(),
      home: NoteList(),
    );
  }
}
