import 'package:get/get.dart';
import 'package:nnlg/dao/entity/ClassScheduleEntity.dart';

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

  //当前显示课表的UUID值
  static final showClassScheduleUUID = "".obs;

  //用于存当前显示的课表实体对象
  static final showClassScheduleEntity = Rx(ClassScheduleEntity);

  //当前选择的课程表单
  static final nowCourseList="".obs;

  static final isColorClassSchedule = false.obs; //是否为彩色课表

  static final isShakeToNowSchedule = true.obs; //是否开启摇一摇返回当前周

  static final isNoonLineSwitch = true.obs; //是否开启午休分割线提示

  static final isPictureBackground = false.obs; //是否为图片背景

  static final isRandomQuadraticBackground = false.obs; //是否为随机二次元背景

  static final isUrlBackground = false.obs; //是否为url背景

  static final isCustomerLocalBackground = false.obs; //是否为二次元背景

  static final courseBackgroundFilePath = "".obs; //背景图片路径
  static final courseBackgroundInputUrl = "".obs; //手动输入的背景图片url
  static final courseBackgroundOpacity = 0.0.obs; //背景透明度

  //每大节的时间
  static final courseTime = <String>[
    "08:30-10:05",
    "10:25-12:00",
    "14:30-16:05",
    "16:15-17:50",
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