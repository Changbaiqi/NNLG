
import 'package:callo/view/water_help_view/binding.dart';
import 'package:callo/view/water_help_view/view.dart';
import 'package:get/get.dart';
import 'package:callo/view/about_me_view/binding.dart';
import 'package:callo/view/about_me_view/view.dart';
import 'package:callo/view/account_safe_view/binding.dart';
import 'package:callo/view/account_safe_view/view.dart';
import 'package:callo/view/authentication_standards_view/binding.dart';
import 'package:callo/view/authentication_standards_view/view.dart';
import 'package:callo/view/card_message_set_view/binding.dart';
import 'package:callo/view/card_message_set_view/view.dart';
import 'package:callo/view/chit_chat_view/binding.dart';
import 'package:callo/view/chit_chat_view/view.dart';
import 'package:callo/view/course_set_view/binding.dart';
import 'package:callo/view/course_set_view/view.dart';
import 'package:callo/view/course_shared_choose_view/binding.dart';
import 'package:callo/view/course_shared_choose_view/view.dart';
import 'package:callo/view/course_shared_list_view/binding.dart';
import 'package:callo/view/course_shared_list_view/view.dart';
import 'package:callo/view/course_shared_show_view/binding.dart';
import 'package:callo/view/course_shared_show_view/view.dart';
import 'package:callo/view/course_shared_view/binding.dart';
import 'package:callo/view/course_shared_view/view.dart';
import 'package:callo/view/eva_detail_view/binding.dart';
import 'package:callo/view/eva_detail_view/view.dart';
import 'package:callo/view/eval_form_view/binding.dart';
import 'package:callo/view/eval_form_view/view.dart';
import 'package:callo/view/exam_inquiry_view/binding.dart';
import 'package:callo/view/exam_inquiry_view/view.dart';
import 'package:callo/view/login_view/binding.dart';
import 'package:callo/view/login_view/view.dart';
import 'package:callo/view/main_community_view/binding.dart';
import 'package:callo/view/main_community_view/view.dart';
import 'package:callo/view/main_course_view/binding.dart';
import 'package:callo/view/main_course_view/view.dart';
import 'package:callo/view/main_user_view/binding.dart';
import 'package:callo/view/main_user_view/view.dart';
import 'package:callo/view/main_view/binding.dart';
import 'package:callo/view/main_view/view.dart';
import 'package:callo/view/main_water_view/binding.dart';
import 'package:callo/view/main_water_view/view.dart';
import 'package:callo/view/nnlg_community_view/binding.dart';
import 'package:callo/view/nnlg_community_view/view.dart';
import 'package:callo/view/score_inquiry_view/binding.dart';
import 'package:callo/view/score_inquiry_view/view.dart';
import 'package:callo/view/software_development_test_view/binding.dart';
import 'package:callo/view/software_development_test_view/view.dart';
import 'package:callo/view/start_view/binding.dart';
import 'package:callo/view/start_view/view.dart';
import 'package:callo/view/teaching_eva_view/binding.dart';
import 'package:callo/view/teaching_eva_view/view.dart';
import 'package:callo/view/train_plan_semester_view/binding.dart';
import 'package:callo/view/train_plan_semester_view/view.dart';
import 'package:callo/view/train_plan_view/binding.dart';
import 'package:callo/view/train_plan_view/view.dart';
import 'package:callo/view/water_charge_view/binding.dart';
import 'package:callo/view/water_charge_view/view.dart';

import 'Routes.dart';

abstract class AppPages{
  static final pages=[
    GetPage(name: Routes.Start, page:()=> StartViewPage(),binding: StartViewBinding()), //开始页面
    GetPage(name: Routes.Main, page: ()=> MainViewPage(),binding: MainViewBinding()), //主页面
    GetPage(name: Routes.ChitChat, page: ()=> ChitChatViewPage(),binding: ChitChatViewBinding()),//校园聊一聊
    GetPage(name: Routes.Login, page: ()=> LoginViewPage(),binding: LoginViewBinding()),  //登录页面
    GetPage(name: Routes.MainUser, page: ()=>MainUserViewPage(),binding: MainUserViewBinding()), //用户页面
    GetPage(name: Routes.MainCourse, page: ()=>MainCourseViewPage(),binding: MainCourseViewBinding()), //个人课表页面
    // GetPage(name: Routes.MainCourseNew, page: ()=>MainCourseNewViewPage(),binding: MainCourseNewViewBinding()), //个人课表页面
    GetPage(name: Routes.MainWater, page: ()=>MainWaterViewPage(),binding: MainWaterViewBinding()), //打水页面
    GetPage(name: Routes.MainCommunity, page:()=>MainCommunityViewPage(),binding: MainCommunityViewBinding() ),//主页
    GetPage(name: Routes.AboutMe, page:()=>AboutMeViewPage(),binding: AboutMeViewBinding() ),//关于页面
    GetPage(name: Routes.ScoreInquiry, page:()=>ScoreInquiryViewPage(),binding: ScoreInquiryViewBinding() ),//成绩查询页面
    GetPage(name: Routes.ExamInquiry, page:()=>ExamInquiryViewPage(),binding: ExamInquiryViewBinding() ), //考试查询页面
    GetPage(name: Routes.WaterCharge, page:()=>WaterChargeViewPage(),binding: WaterChargeViewBinding() ), //打水扫码页面
    GetPage(name: Routes.TeachingEva, page:()=>TeachingEvaViewPage(),binding: TeachingEvaViewBinding() ), //评教页面
    GetPage(name: Routes.TeachingEvaDetails, page:()=>EvaDetailViewPage(),binding: EvaDetailViewBinding() ), //评教子页面
    GetPage(name: Routes.EvalForm, page:()=>EvalFormViewPage(),binding: EvalFormViewBinding() ), //评教表单页面
    GetPage(name: Routes.TrainPlan, page:()=>TrainPlanViewPage(),binding: TrainPlanViewBinding() ), //培养计划页面
    GetPage(name: Routes.TrainPlanSemester, page:()=>TrainPlanSemesterViewPage(),binding: TrainPlanSemesterViewBinding() ), //培养计划页面
    GetPage(name: Routes.SharedCourseChoose, page:()=> CourseSharedChooseViewPage(),binding: CourseSharedChooseViewBinding()), //共享课表页面
    GetPage(name: Routes.CourseSharedList, page:()=> CourseSharedListViewPage(),binding: CourseSharedListViewBinding()), // 共享课表账号名单页面
    GetPage(name: Routes.CourseSharedShow, page:()=> CourseSharedShowViewPage(),binding: CourseSharedShowViewBinding()), // 共享课表查看页面
    GetPage(name: Routes.CourseShared, page:()=> CourseSharedViewPage(),binding: CourseSharedViewBinding()), // 共享课表查看页面
    GetPage(name: Routes.CourseSet, page: ()=>CourseSetViewPage(),binding: CourseSetViewBinding()), //课表设置页面
    GetPage(name: Routes.AuthenticationStandards, page:()=> AuthenticationStandardsViewPage(),binding: AuthenticationStandardsViewBinding()), // 认证说明
    GetPage(name: Routes.NnlgCommunity, page: ()=>NnlgCommunityViewPage(),binding: NnlgCommunityViewBinding()), //校园社区
    GetPage(name: Routes.AccountSafe, page: ()=>AccountSafeViewPage(),binding: AccountSafeViewBinding()), //账号安全与隐私
    GetPage(name: Routes.SoftwareDevelopmentTestView, page: ()=>SoftwareDevelopmentTestViewPage(),binding:  SoftwareDevelopmentTestViewBinding()), //用于测试的页面
    GetPage(name: Routes.CardMessageSet, page: ()=>CardMessageSetViewPage(),binding:  CardMessageSetViewBinding()), //卡片设置
    GetPage(name: Routes.WaterHelp, page: ()=>WaterHelpViewPage(),binding:  WaterHelpViewBinding()), //打水教程
  ];
}