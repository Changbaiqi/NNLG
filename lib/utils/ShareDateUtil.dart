
import 'package:flutter/cupertino.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/AppInfoData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/dao/NoticeData.dart';
import 'package:nnlg/dao/XiaoBeiData.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/XiaoBeiUserUtil.dart';
import 'package:nnlg/view/Login.dart';
import 'package:nnlg/view/Main_course.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dao/ContextData.dart';
import '../dao/WaterData.dart';

class ShareDateUtil{


  //用于初始化所有数据加载
  Future<void> initLoading()async {

    //初始化APP的相关信息，比如APP版本以及APP名称和签名等
    AppInfoData.init();

    //头像加载
    await getAccountHeadMode();
    await getAccountHeadQQ();
    await getAccountHeadFilePath();

    //学生信息详细信息加载
    await getAccountStudentName();
    await getAccountStudentID();
    await getAccountStudentMajor();

    //登录界面信息初始化信息加载
    await getAutoLogin();
    await getRememberAccountAndPassword();
    await getLoginAccount();
    await getLoginPassword();

    //课表信息页初始化信息加载
    await getSchoolOpenDate();
    await getSemesterWeekNum();
    await getWeekCourseList();
    await getSemesterCourseList();
    await getNowCourseList();
    await getCourseTimeList();


    //打水功能相关功能信息加载
    await getWaterAccount();
    await getCoolWater();
    await getHotWater();
    await getCardNum();
    await getWaterSaler();
    await getWaterUserId();

    //初始化通知寄存版本号
    await getNoticeId();

    //用来判断当前周数并赋值给配置变量
    CourseData.nowWeek.value = CourseUtil.getNowWeek(CourseData.schoolOpenTime.value, CourseData.ansWeek.value);


  }

  //清空所有账号数据
  Future<void> clearAllAccountData() async {

    //账户信息数据
    await setAccountStudentName("");
    await setAccountStudentID("");
    await setAccountStudentMajor("");

    //自动登录取消
    await setAutoLogin(false);

    //课表信息数据
    await setWeekCourseList(<String>[]);

    //清空VIP账号信息数据
    XiaoBeiData.xiaobeiAccount='';
    XiaoBeiData.xiaobeiPassword='';


  }

  //设置登录Cookie
  setCookie(String cookie) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cookie', '${cookie}').then((c){
      ContextDate.ContextCookie = cookie;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取登录Cookie
  Future<String> getCookie() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookie = await prefs.getString('cookie');
    ContextDate.ContextCookie = cookie??"";
    return cookie??"";
  }


  //设置登录是否登录记住账号密码
  setRememberAccountAndPassword(bool isRemember) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberAccountAndPassword', isRemember).then((c){
      LoginData.rememberAccountAndPassword.value = isRemember;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取是否登录记住账号密码
  Future<bool> getRememberAccountAndPassword() async {
    final prefs = await SharedPreferences.getInstance();
    bool? rememberAccountAndPassword = await prefs.getBool('rememberAccountAndPassword');
    LoginData.rememberAccountAndPassword.value = rememberAccountAndPassword??false;
    return rememberAccountAndPassword??false;
  }


  //设置是否需要自动登录
  setAutoLogin(bool isAutoLogin) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAutoLogin', isAutoLogin).then((c){
       LoginData.autoLogin.value = isAutoLogin;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取是否需要自动登录
  Future<bool> getAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAutoLogin = await prefs.getBool('isAutoLogin');
    LoginData.autoLogin.value = isAutoLogin??false;
    return isAutoLogin??false;
  }


  //设置账号头像模式
  setAccountHeadMode(int mode) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountHeadMode', mode).then((c){
      AccountData.headMode = mode;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取账号头像模式
  Future<int> getAccountHeadMode() async {
    final prefs = await SharedPreferences.getInstance();
    int? mode = await prefs.getInt('accountHeadMode');
    AccountData.headMode = mode??0;
    return mode??0;
  }


  //设置头像QQ
  setAccountHeadQQ(String qq) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountHeadQQ', qq).then((c){
      AccountData.head_qq = qq;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取账号头像QQ
  Future<String> getAccountHeadQQ() async {
    final prefs = await SharedPreferences.getInstance();
    String? qq = await prefs.getString('accountHeadQQ');
    AccountData.head_qq = qq??"2084069833";
    return qq??"2084069833";
  }

  //设置头像路径
  setAccountHeadFilePath(String filePath)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountHeadFilePath', filePath).then((c){
      AccountData.head_filePath= filePath;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
  }

  //获取账号头像路径
  Future<String> getAccountHeadFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('accountHeadFilePath');
    AccountData.head_filePath = path??"";
    return path??"";
  }





  //设置登录账号
  setLoginAccount(String loginAccount) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginAccount', '${loginAccount}').then((c){
      LoginData.account = loginAccount;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取登录账号
  Future<String> getLoginAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String? loginAccount = await prefs.getString('loginAccount');
    LoginData.account = loginAccount??"";
    return loginAccount??"";
  }

  //设置登录密码
  setLoginPassword(String loginPassword) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginPassword', '${loginPassword}').then((c){
      LoginData.password = loginPassword;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取登录密码
  Future<String> getLoginPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? loginPassword = await prefs.getString('loginPassword');
    LoginData.password = loginPassword??"";
    return loginPassword??"";
  }


  //设置登录学生姓名
  Future setAccountStudentName(String studentName) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentName', '${studentName}').then((c){
      AccountData.studentName = studentName;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取登录账号学生姓名
  Future<String> getAccountStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    String? studentName = await prefs.getString('studentName');
    AccountData.studentName = studentName??"请先登录";
    return studentName??"";
  }


  //设置登录学生学号
  Future setAccountStudentID(String studentID) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentID', '${studentID}').then((c){
      AccountData.studentID = studentID;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取登录账号学生学号
  Future<String> getAccountStudentID() async {
    final prefs = await SharedPreferences.getInstance();
    String? studentID = await prefs.getString('studentID');
    AccountData.studentID = studentID??"请先登录";
    return studentID??"";
  }



  //设置登录学生专业
  Future setAccountStudentMajor(String studentMajor) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentMajor', '${studentMajor}').then((c){
      AccountData.studentMajor = studentMajor;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取登录账号学生专业
  Future<String> getAccountStudentMajor() async {
    final prefs = await SharedPreferences.getInstance();
    String? studentMajor = await prefs.getString('studentMajor');
    AccountData.studentMajor = studentMajor??"请先登录";
    return studentMajor??"";
  }




  //设置开学日期
  Future<void> setSchoolOpenDate(String schoolOpenDate) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('schoolOpenDate', '${schoolOpenDate}').then((c){
      CourseData.schoolOpenTime.value = schoolOpenDate;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取开学日期
  Future<String> getSchoolOpenDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? schoolOpenDate = await prefs.getString('schoolOpenDate');
    CourseData.schoolOpenTime.value = schoolOpenDate??"${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}";
    return schoolOpenDate??"";
  }


  //设置本学期总周数
  setSemesterWeekNum(int semesterWeekNum) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('semesterWeekNum', semesterWeekNum).then((c){
      CourseData.ansWeek.value = semesterWeekNum;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取本学期总周数
  Future<int> getSemesterWeekNum() async {
    final prefs = await SharedPreferences.getInstance();
    int? semesterWeekNum = await prefs.getInt('semesterWeekNum');
    CourseData.ansWeek.value = semesterWeekNum??20;
    return semesterWeekNum??20;
  }


  //设置本学期课表数据
  setWeekCourseList(List<String> weekCourseList) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('weekCourseList', weekCourseList).then((c){
      CourseData.weekCourseList.value = weekCourseList;
      CourseData.weekCourseList.refresh();
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取本学期课表数据
  Future<List<String>> getWeekCourseList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? weekCourseList = await prefs.getStringList('weekCourseList');
    // CourseData.weekCourseList.value = weekCourseList??<String>[];
    CourseData.weekCourseList.value.clear();
    CourseData.weekCourseList.value.addAll(weekCourseList??<String>[]);
    return weekCourseList??<String>[];
  }



  //设置拉取的学期课程列表
  Future<void> setSemesterCourseList(List<String> semesterCourseList) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('semesterCourseList', semesterCourseList).then((c){
      // CourseData.semesterCourseList.value = semesterCourseList;
      CourseData.semesterCourseList.value.clear();
      CourseData.semesterCourseList.value.addAll(semesterCourseList);
      CourseData.semesterCourseList.refresh();
      return semesterCourseList;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取学期课程列表
  Future<List<String>> getSemesterCourseList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? semesterCourseList = await prefs.getStringList('semesterCourseList');
    // CourseData.semesterCourseList = semesterCourseList??<String>[];
    CourseData.semesterCourseList.value.clear();
    CourseData.semesterCourseList.value.addAll(semesterCourseList??<String>[]);
    CourseData.semesterCourseList.refresh();
    return semesterCourseList??<String>[];
  }





  //设置当前所选的课程表单
  setNowCourseList(String nowCourseList) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nowCourseList', nowCourseList).then((c){
      CourseData.nowCourseList.value = nowCourseList;
      CourseData.nowCourseList.refresh();
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取当前所选的课程表单
  Future<String> getNowCourseList() async {
    final prefs = await SharedPreferences.getInstance();
    String? nowCourseList = await prefs.getString('nowCourseList');
    CourseData.nowCourseList.value = nowCourseList??"";
    CourseData.nowCourseList.refresh();
    return nowCourseList??"";
  }

  //设置拉取的学期课程列表
  Future<void> setCourseTimeList(List<String> courseTimeList) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('courseTimeList', courseTimeList).then((c){
      // CourseData.courseTime= courseTimeList;
      CourseData.courseTime.value.clear();
      CourseData.courseTime.value.addAll(courseTimeList);
      CourseData.courseTime.refresh();
      return courseTimeList;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取学期课程列表
  Future<List<String>> getCourseTimeList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? courseTimeList = await prefs.getStringList('courseTimeList');
    if(courseTimeList!=null){
      CourseData.courseTime.value.clear();
      CourseData.courseTime.value.addAll(courseTimeList);
      CourseData.courseTime.refresh();
    }
    return courseTimeList??<String>[];
  }









  //打水部分
  Future<void> setWaterAccount(String waterAccount) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('WaterAccount', '${waterAccount}').then((c){
      WaterData.waterAccount = waterAccount;
    });
  }

  Future<String> getWaterAccount() async{
    final prefs = await SharedPreferences.getInstance();
    String? waterAccount = await prefs.getString('WaterAccount');
    WaterData.waterAccount = waterAccount??"";
    return waterAccount??"";
  }



  Future<void> setCoolWater(String coolWater) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('CoolWater', '${coolWater}').then((c){
      WaterData.coolWater = coolWater;
    });
    //('设置的Token：${WaterData.token}');
  }

  Future<String> getCoolWater() async{
    final prefs = await SharedPreferences.getInstance();
    String? coolWater = await prefs.getString('CoolWater');
    WaterData.coolWater = coolWater??"";
    return coolWater??"";
  }


  Future<void> setHotWater(String hotWater) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('HotWater', '${hotWater}').then((c){
      WaterData.hotWater = hotWater;
    });
  }

  Future<String> getHotWater() async{
    final prefs = await SharedPreferences.getInstance();
    String? hotWater = await prefs.getString('HotWater');
    WaterData.hotWater = hotWater??"";
    return hotWater??"";
  }

  Future<void> setCardNum(String cardNum) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('CardNum', '${cardNum}').then((c){
      WaterData.cardNum = cardNum;
    });
  }

  Future<String> getCardNum() async{
    final prefs = await SharedPreferences.getInstance();
    String? cardNum = await prefs.getString('CardNum');
    WaterData.cardNum = cardNum??"";
    return cardNum??"";
  }



  Future<void> setWaterSaler(String waterSaler) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('WaterSaler', '${waterSaler}').then((c){
      WaterData.waterSaler = waterSaler;
    });
  }

  Future<String> getWaterSaler() async{
    final prefs = await SharedPreferences.getInstance();
    String? waterSaler = await prefs.getString('WaterSaler');
    WaterData.waterSaler = waterSaler??"";
    return waterSaler??"";
  }


  Future<void> setWaterUserId(String userId) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('WaterUserId', '${userId}').then((c){
      WaterData.userId =userId;
    });
  }

  Future<String> getWaterUserId() async{
    final prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('WaterUserId');
    WaterData.userId = userId??"";
    return userId??"";
  }

  //解除绑定
  Future<void> setWaterUnBind() async{
    await setWaterUserId("");
    await setWaterAccount("");
    await setWaterSaler("");
  }



  //获取通知寄存版本号
  Future<int> getNoticeId() async{
    final prefs = await SharedPreferences.getInstance();
    int? noticeId = await prefs.getInt('NoticeId');
    NoticeData.noticeId = noticeId??0;
    return noticeId??0;
  }

 //设置通知寄存版本号
  Future<void> setNoticeId(int noticeId) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('NoticeId', noticeId).then((c){
      NoticeData.noticeId = noticeId;
    });
  }





}