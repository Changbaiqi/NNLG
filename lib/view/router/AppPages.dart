
import 'package:get/get.dart';
import 'package:nnlg/view/about_me_view/binding.dart';
import 'package:nnlg/view/about_me_view/view.dart';
import 'package:nnlg/view/chit_chat_view/binding.dart';
import 'package:nnlg/view/chit_chat_view/view.dart';
import 'package:nnlg/view/exam_inquiry_view/binding.dart';
import 'package:nnlg/view/exam_inquiry_view/view.dart';
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
import 'package:nnlg/view/score_inquiry_view/binding.dart';
import 'package:nnlg/view/score_inquiry_view/view.dart';
import 'package:nnlg/view/start_view/binding.dart';
import 'package:nnlg/view/start_view/view.dart';
import 'package:nnlg/view/teaching_eva_view/binding.dart';
import 'package:nnlg/view/teaching_eva_view/view.dart';
import 'package:nnlg/view/water_charge_view/binding.dart';
import 'package:nnlg/view/water_charge_view/view.dart';

import 'Routes.dart';

abstract class AppPages{
  static final pages=[
    GetPage(name: Routes.Start, page:()=> StartViewPage(),binding: StartViewBinding()),
    GetPage(name: Routes.Main, page: ()=> MainViewPage(),binding: MainViewBinding()),
    GetPage(name: Routes.ChitChat, page: ()=> ChitChatViewPage(),binding: ChitChatViewBinding()),
    GetPage(name: Routes.Login, page: ()=> LoginViewPage(),binding: LoginViewBinding()),
    GetPage(name: Routes.MainUser, page: ()=>MainUserViewPage(),binding: MainUserViewBinding()),
    GetPage(name: Routes.MainCourse, page: ()=>MainCourseViewPage(),binding: MainCourseViewBinding()),
    GetPage(name: Routes.MainWater, page: ()=>MainWaterViewPage(),binding: MainWaterViewBinding()),
    GetPage(name: Routes.MainCommunity, page:()=>MainCommunityViewPage(),binding: MainCommunityViewBinding() ),
    GetPage(name: Routes.AboutMe, page:()=>AboutMeViewPage(),binding: AboutMeViewBinding() ),
    GetPage(name: Routes.ScoreInquiry, page:()=>ScoreInquiryViewPage(),binding: ScoreInquiryViewBinding() ),
    GetPage(name: Routes.ExamInquiry, page:()=>ExamInquiryViewPage(),binding: ExamInquiryViewBinding() ),
    GetPage(name: Routes.WaterCharge, page:()=>WaterChargeViewPage(),binding: WaterChargeViewBinding() ),
    GetPage(name: Routes.TeachingEva, page:()=>TeachingEvaViewPage(),binding: TeachingEvaViewBinding() ),
  ];
}