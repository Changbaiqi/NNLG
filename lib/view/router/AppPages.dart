
import 'package:get/get.dart';
import 'package:nnlg/view/login_view/binding.dart';
import 'package:nnlg/view/login_view/view.dart';
import 'package:nnlg/view/main_community_view/binding.dart';
import 'package:nnlg/view/main_community_view/view.dart';
import 'package:nnlg/view/main_course_view/binding.dart';
import 'package:nnlg/view/main_course_view/view.dart';
import 'package:nnlg/view/main_user_view/binding.dart';
import 'package:nnlg/view/main_user_view/view.dart';
import 'package:nnlg/view/main_view/binding.dart';
import 'package:nnlg/view/main_view/view.dart';
import 'package:nnlg/view/main_water_view/binding.dart';
import 'package:nnlg/view/main_water_view/view.dart';
import 'package:nnlg/view/start_view/binding.dart';
import 'package:nnlg/view/start_view/view.dart';

import 'Routes.dart';

abstract class AppPages{
  static final pages=[
    GetPage(name: Routes.Start, page:()=> StartViewPage(),binding: StartViewBinding()),
    GetPage(name: Routes.Main, page: ()=> MainViewPage(),binding: MainViewBinding()),
    GetPage(name: Routes.Login, page: ()=> LoginViewPage(),binding: LoginViewBinding()),
    GetPage(name: Routes.MainUser, page: ()=>MainUserViewPage(),binding: MainUserViewBinding()),
    GetPage(name: Routes.MainCourse, page: ()=>MainCourseViewPage(),binding: MainCourseViewBinding()),
    GetPage(name: Routes.MainWater, page: ()=>MainWaterViewPage(),binding: MainWaterViewBinding()),
    GetPage(name: Routes.MainCommunity, page:()=>MainCommunityViewPage(),binding: MainCommunityViewBinding() )
  ];
}