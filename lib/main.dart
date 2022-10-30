import 'package:flutter/material.dart';
import 'package:nnlg/view/Start.dart';

void main(){
 return runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Start(),
    );
  }
}


