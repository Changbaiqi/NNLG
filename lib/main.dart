import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/view/router/AppPages.dart';
import 'package:nnlg/view/router/Routes.dart';
import 'package:nnlg/view/start_view/view.dart';

void main(){
 return runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.Start,
      getPages: AppPages.pages
    );
  }
}


