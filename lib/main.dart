import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:nnlg/dao/ClassScheduleDatabase.dart';
import 'package:nnlg/view/router/AppPages.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'dao/ClassScheduleDao.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //数据库迁移更新
  final database = await $FloorClassScheduleDatabase.databaseBuilder('app_database.db')
      .addMigrations([Migration(4, 5, (database)async{
        await database.update('ClassScheduleEntity', {'list': null});
  })]).build();
  
  final dao = database.classScheduleDao;
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<ClassScheduleDao>(dao,signalsReady: true);
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


