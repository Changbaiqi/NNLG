class CourseData{

  //开学时间
  static String schoolOpenTime = "2022/8/29";
  //现在周数
  static int nowWeek = 2;
  //总周数
  static int ansWeek = 20;
  //课表的所有JSON数据
  static String sourseAllJSON="";

  //存储每周的课表json数据
  static List<String> weekCourseList = [];

  //用于存储从官网最新拉取的课程表的列表
  static List<String> semesterCourseList = [];
  //当前选择的课程表单
  static String nowCourseList="";


  //每大节的时间
  static List<String> courseTime = [
    "08:30-10:05",
    "10:25-12:00",
    "14:30-16:05",
    "16:15-18:00",
    "18:20-19:55",
    "20:05-21:40"
  ];


/*
  * 第一大节：8:30-10:05
  * 第二大节：10:25-12:00
  * 第三大节：14:30-16:05
  * 第四大节：16:15-17:50
  * 第五大节：18:20-19:55
  * 第六大节：20:05-21:40
  * */

}