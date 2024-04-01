
import 'package:get/get.dart';
import 'package:nnlg/view/about_me_view/binding.dart';
import 'package:nnlg/view/about_me_view/view.dart';
import 'package:nnlg/view/authentication_standards_view/binding.dart';
import 'package:nnlg/view/authentication_standards_view/view.dart';
import 'package:nnlg/view/chit_chat_view/binding.dart';
import 'package:nnlg/view/chit_chat_view/view.dart';
import 'package:nnlg/view/course_set_view/binding.dart';
import 'package:nnlg/view/course_set_view/view.dart';
import 'package:nnlg/view/course_shared_choose_view/binding.dart';
import 'package:nnlg/view/course_shared_choose_view/view.dart';
import 'package:nnlg/view/course_shared_list_view/binding.dart';
import 'package:nnlg/view/course_shared_list_view/view.dart';
import 'package:nnlg/view/course_shared_show_view/binding.dart';
import 'package:nnlg/view/course_shared_show_view/view.dart';
import 'package:nnlg/view/course_shared_view/binding.dart';
import 'package:nnlg/view/course_shared_view/view.dart';
import 'package:nnlg/view/eva_detail_view/binding.dart';
import 'package:nnlg/view/eva_detail_view/view.dart';
import 'package:nnlg/view/eval_form_view/binding.dart';
import 'package:nnlg/view/eval_form_view/view.dart';
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
import 'package:nnlg/view/train_plan_semester_view/binding.dart';
import 'package:nnlg/view/train_plan_semester_view/view.dart';
import 'package:nnlg/view/train_plan_view/binding.dart';
import 'package:nnlg/view/train_plan_view/view.dart';
import 'package:nnlg/view/water_charge_view/binding.dart';
import 'package:nnlg/view/water_charge_view/view.dart';

import 'Routes.dart';

abstract class AppPages{
  static final pages=[
    GetPage(name: Routes.Start, page:()=> StartViewPage(),binding: StartViewBinding()), //开始页面
    GetPage(name: Routes.Main, page: ()=> MainViewPage(),binding: MainViewBinding()), //主页面
    GetPage(name: Routes.ChitChat, page: ()=> ChitChatViewPage(),binding: ChitChatViewBinding()),//校园聊一聊
    GetPage(name: Routes.Login, page: ()=> LoginViewPage(),binding: LoginViewBinding()),  //登录页面
    GetPage(name: Routes.MainUser, page: ()=>MainUserViewPage(),binding: MainUserViewBinding()), //用户页面
    GetPage(name: Routes.MainCourse, page: ()=>MainCourseViewPage(),binding: MainCourseViewBinding()), //个人课表页面
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
  ];
}