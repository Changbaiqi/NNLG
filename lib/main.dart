import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nnlg/view/router/AppPages.dart';
import 'package:nnlg/view/router/Routes.dart';
import 'package:nnlg/view/start_view/view.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
 return runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(2080, 2340),
      minTextAdapt: true,
      splitScreenMode: true,

      child: MaterialApp(
        home: GetMaterialApp(
            initialRoute: Routes.Start,
            getPages: AppPages.pages
        ),
      ),
    );
  }
}


