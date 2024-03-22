import 'package:get/get.dart';

class CourseData{

  //开学时间
  static final schoolOpenTime = "2022/8/29".obs;
  //现在周数
  static final nowWeek = 2.obs;
  //总周数
  static final ansWeek = 20.obs;
  //课表的所有JSON数据
  static final sourseAllJSON="".obs;

  //存储每周的课表json数据
  static final weekCourseList = <String>[].obs;

  //用于存储从官网最新拉取的课程表的列表
  static final semesterCourseList = <String>[].obs;
  //当前选择的课程表单
  static final nowCourseList="".obs;

  static final isColorClassSchedule = false.obs; //是否为彩色课表

  static final isShakeToNowSchedule = true.obs; //是否开启摇一摇返回当前周


  //每大节的时间
  static final courseTime = <String>[
    "08:30-10:05",
    "10:25-12:00",
    "14:30-16:05",
    "16:15-18:00",
    "18:20-19:55",
    "20:05-21:40"
  ].obs;


/*
  * 第一大节：8:30-10:05
  * 第二大节：10:25-12:00
  * 第三大节：14:30-16:05
  * 第四大节：16:15-17:50
  * 第五大节：18:20-19:55
  * 第六大节：20:05-21:40
  * */

}