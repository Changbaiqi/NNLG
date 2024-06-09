
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/AppInfoData.dart';
import 'package:nnlg/dao/AppUpdateData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/dao/NoticeData.dart';
import 'package:nnlg/dao/XiaoBeiData.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dao/ContextData.dart';
import '../dao/WaterData.dart';

class ShareDateUtil{


  //用于初始化所有数据加载
  Future<void> initLoading()async {

    //初始化APP的相关信息，比如APP版本以及APP名称和签名等
    await AppInfoData.init();

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
    await getColorClassSchedule();
    await getShakeToNowSchedule();
    await getNoonLineSwitch();
    await getIsPictureBackground(); //获取是否开启背景图
    await getIsRandomQuadraticBackground(); //获取是否为二次元随机图片
    await getIsUrlBackground(); //获取是否为url图片
    await getIsCustomerLocalBackground(); //获取是否为本地图片
    await getCourseBackgroundFilePath(); //获取本地图片路径
    await getCourseBackgroundInputUrl(); //获取背景url
    await getCourseBackgroundOpacity(); //获取背景透明度


    //打水功能相关功能信息加载
    await getWaterAccount();
    await getCoolWater();
    await getHotWater();
    await getCardNum();
    await getWaterSaler();
    await getWaterUserId();

    //一信通数据加载
    await getJustMessengerAccount();
    await getJustMessengerPassword();

    //初始化通知寄存版本号
    await getNoticeId();


    //初始化认证信息
    await getIsIdent();
    await getIdentMainColor();
    await getIdentMainTag();

    //初始化不更新的版本标记
    await getNoUpdateVersion();

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
      AccountData.headMode.value = mode;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取账号头像模式
  Future<int> getAccountHeadMode() async {
    final prefs = await SharedPreferences.getInstance();
    int? mode = await prefs.getInt('accountHeadMode');
    AccountData.headMode.value = mode??0;
    return mode??0;
  }


  //设置头像QQ
  setAccountHeadQQ(String qq) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountHeadQQ', qq).then((c){
      AccountData.head_qq.value = qq;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
    //print('设置的Cookie：${ContextDate.token}');
  }

  //获取账号头像QQ
  Future<String> getAccountHeadQQ() async {
    final prefs = await SharedPreferences.getInstance();
    String? qq = await prefs.getString('accountHeadQQ');
    AccountData.head_qq.value = qq??"2084069833";
    return qq??"2084069833";
  }

  //设置头像路径
  setAccountHeadFilePath(String filePath)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountHeadFilePath', filePath).then((c){
      AccountData.head_filePath.value= filePath;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
  }

  //获取账号头像路径
  Future<String> getAccountHeadFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('accountHeadFilePath');
    AccountData.head_filePath.value = path??"";
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
      WaterData.waterAccount.value = waterAccount;
    });
  }

  Future<String> getWaterAccount() async{
    final prefs = await SharedPreferences.getInstance();
    String? waterAccount = await prefs.getString('WaterAccount');
    WaterData.waterAccount.value = waterAccount??"";
    return waterAccount??"";
  }



  Future<void> setCoolWater(String coolWater) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('CoolWater', '${coolWater}').then((c){
      WaterData.coolWater.value = coolWater;
    });
    //('设置的Token：${WaterData.token}');
  }

  Future<String> getCoolWater() async{
    final prefs = await SharedPreferences.getInstance();
    String? coolWater = await prefs.getString('CoolWater');
    WaterData.coolWater.value = coolWater??"";
    return coolWater??"";
  }


  Future<void> setHotWater(String hotWater) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('HotWater', '${hotWater}').then((c){
      WaterData.hotWater.value = hotWater;
    });
  }

  Future<String> getHotWater() async{
    final prefs = await SharedPreferences.getInstance();
    String? hotWater = await prefs.getString('HotWater');
    WaterData.hotWater.value = hotWater??"";
    return hotWater??"";
  }

  Future<void> setCardNum(String cardNum) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('CardNum', '${cardNum}').then((c){
      WaterData.cardNum.value = cardNum;
    });
  }

  Future<String> getCardNum() async{
    final prefs = await SharedPreferences.getInstance();
    String? cardNum = await prefs.getString('CardNum');
    WaterData.cardNum.value = cardNum??"";
    return cardNum??"";
  }



  Future<void> setWaterSaler(String waterSaler) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('WaterSaler', '${waterSaler}').then((c){
      WaterData.waterSaler.value = waterSaler;
    });
  }

  Future<String> getWaterSaler() async{
    final prefs = await SharedPreferences.getInstance();
    String? waterSaler = await prefs.getString('WaterSaler');
    WaterData.waterSaler.value = waterSaler??"";
    return waterSaler??"";
  }


  Future<void> setWaterUserId(String userId) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('WaterUserId', '${userId}').then((c){
      WaterData.userId.value =userId;
    });
  }

  Future<String> getWaterUserId() async{
    final prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('WaterUserId');
    WaterData.userId.value = userId??"";
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

  //获取一信通的用户名称
  Future<String> getJustMessengerUsername() async{
    final prefs = await SharedPreferences.getInstance();
    String? justMessengerUsername = await prefs.getString('JustMessengerUsername');
    AccountData.justMessengerUsername.value = justMessengerUsername??"";
    return justMessengerUsername??"";
  }

  //设置一信通的用户名称
  Future<void> setJustMessengerUsername(String justMessengerUsername) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('JustMessengerUsername', justMessengerUsername).then((c){
      AccountData.justMessengerUsername.value = justMessengerUsername;
    });
  }


  //获取一信通的用户账号
  Future<String> getJustMessengerAccount() async{
    final prefs = await SharedPreferences.getInstance();
    String? justMessengerAccount = await prefs.getString('JustMessengerAccount');
    AccountData.justMessengerAccount.value = justMessengerAccount??"";
    return justMessengerAccount??"";
  }

  //设置一信通的用户账号
  Future<void> setJustMessengerAccount(String justMessengerAccount) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('JustMessengerAccount', justMessengerAccount).then((c){
      AccountData.justMessengerAccount.value = justMessengerAccount;
    });
  }


  //获取一信通的用户密码
  Future<String> getJustMessengerPassword() async{
    final prefs = await SharedPreferences.getInstance();
    String? justMessengerPassword = await prefs.getString('JustMessengerPassword');
    AccountData.justMessengerPassword.value = justMessengerPassword??"";
    return justMessengerPassword??"";
  }

  //设置一信通的用户密码
  Future<void> setJustMessengerPassword(String justMessengerPassword) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('JustMessengerPassword', justMessengerPassword).then((c){
      AccountData.justMessengerPassword.value = justMessengerPassword;
    });
  }


  //获取是否为彩色课表
  Future<bool> getColorClassSchedule() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isColorClassSchedule = await prefs.getBool('isColorClassSchedule');
    CourseData.isColorClassSchedule.value = isColorClassSchedule??false;
    return isColorClassSchedule??false;
  }

  //设置是否为彩色课表
  Future<void> setColorClassSchedule(bool isOpen) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isColorClassSchedule', isOpen).then((value) => CourseData.isColorClassSchedule.value = isOpen);
  }

  //获取是否为开启摇一摇
  Future<bool> getShakeToNowSchedule() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isShakeToNowSchedule = await prefs.getBool('isShakeToNowSchedule');
    CourseData.isShakeToNowSchedule.value = isShakeToNowSchedule??true;
    return isShakeToNowSchedule??true;
  }

  //设置是否为开启摇一摇
  Future<void> setShakeToNowSchedule(bool isOpen) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isShakeToNowSchedule', isOpen).then((value) => CourseData.isShakeToNowSchedule.value = isOpen);
  }

  //获取是否为开启午休分割线
  Future<bool> getNoonLineSwitch() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isNoonLineSwitch = await prefs.getBool('isNoonLineSwitch');
    CourseData.isNoonLineSwitch.value = isNoonLineSwitch??true;
    return isNoonLineSwitch??true;
  }

  //设置是否为开启午休分割线
  Future<void> setNoonLineSwitch(bool isOpen) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNoonLineSwitch', isOpen).then((value) => CourseData.isNoonLineSwitch.value = isOpen);
  }


//获取是否有认证
  Future<bool> getIsIdent() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isIdent = await prefs.getBool('isIdent');
    AccountData.isIdent.value = isIdent??false;
    return isIdent??false;
  }

  //设置是否有认证
  Future<void> setIsIdent(bool isIdent) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIdent', isIdent).then((value) => AccountData.isIdent.value = isIdent);
  }

  //获取主认证标签
  Future<String> getIdentMainTag() async{
    final prefs = await SharedPreferences.getInstance();
    String? identMainTag = await prefs.getString('identMainTag');
    AccountData.identMainTag.value = identMainTag??"";
    return identMainTag??"";
  }

  //设置主认证标签
  Future<void> setIdentMainTag(String identMainTag) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('identMainTag', identMainTag).then((value) => AccountData.identMainTag.value = identMainTag);
  }

  //获取主认证颜色
  Future<String> getIdentMainColor() async{
    final prefs = await SharedPreferences.getInstance();
    String? identMainColor = await prefs.getString('identMainColor');
    AccountData.identMainColor.value = identMainColor??"#f1f2f5";
    return identMainColor??"#f1f2f5";
  }

  //设置主认证颜色
  Future<void> setIdentMainColor(String identMainColor) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('identMainColor', identMainColor).then((value) => AccountData.identMainColor.value = identMainColor);
  }


  //获取不提示更新的版本
  Future<int> getNoUpdateVersion() async{
    final prefs = await SharedPreferences.getInstance();
    int? noUpdateVersion = await prefs.getInt('noUpdateVersion');
    AppUpdateData.noUpdateVersion.value = noUpdateVersion??0;
    return noUpdateVersion??0;
  }

  //设置不提示更新的版本
  Future<void> setNoUpdateVersion(int noUpdateVersion) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('noUpdateVersion', noUpdateVersion).then((value) => AppUpdateData.noUpdateVersion.value = noUpdateVersion);
  }

  //获取是否为纯色背景课表
  Future<bool> getIsPictureBackground() async{
    final prefs = await SharedPreferences.getInstance();
    bool? IsPictureBackground = await prefs.getBool('isPictureBackground');
    CourseData.isPictureBackground.value = IsPictureBackground??false;
    return IsPictureBackground??false;
  }

  //设置是否为纯色背景课表
  Future<void> setIsPictureBackground(bool isPictureBackground) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPictureBackground', isPictureBackground).then((value) => CourseData.isPictureBackground.value = isPictureBackground);
  }

  //获取是否为纯色背景课表
  Future<bool> getIsRandomQuadraticBackground() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isRandomQuadraticBackground = await prefs.getBool('isRandomQuadraticBackground');
    CourseData.isRandomQuadraticBackground.value = isRandomQuadraticBackground??false;
    return isRandomQuadraticBackground??false;
  }

  //设置是二次元随机背景课表
  Future<void> setIsRandomQuadraticBackground(bool isRandomQuadraticBackground) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRandomQuadraticBackground', isRandomQuadraticBackground).then((value) => CourseData.isRandomQuadraticBackground.value = isRandomQuadraticBackground);
  }

  //获取是否为本地背景课表
  Future<bool> getIsCustomerLocalBackground() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isCustomerLocalBackground = await prefs.getBool('isCustomerLocalBackground');
    CourseData.isCustomerLocalBackground.value = isCustomerLocalBackground??false;
    return isCustomerLocalBackground??false;
  }

  //设置是否为本地背景课表
  Future<void> setIsCustomerLocalBackground(bool isCustomerLocalBackground) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCustomerLocalBackground', isCustomerLocalBackground).then((value) => CourseData.isCustomerLocalBackground.value = isCustomerLocalBackground);
  }

  //获取是否为Url背景课表
  Future<bool> getIsUrlBackground() async{
    final prefs = await SharedPreferences.getInstance();
    bool? isUrlBackground = await prefs.getBool('isUrlBackground');
    CourseData.isUrlBackground.value = isUrlBackground??false;
    return isUrlBackground??false;
  }

  //设置是否为Url背景课表
  Future<void> setIsUrlBackground(bool isUrlBackground) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUrlBackground', isUrlBackground).then((value) => CourseData.isUrlBackground.value = isUrlBackground);
  }

  //设置背景图片本地路径
  setCourseBackgroundFilePath(String filePath)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('courseBackgroundFilePath', filePath).then((c){
      CourseData.courseBackgroundFilePath.value= filePath;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
  }

  //获取背景图片本地路径
  Future<String> getCourseBackgroundFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('courseBackgroundFilePath');
    CourseData.courseBackgroundFilePath.value = path??"";
    return path??"";
  }


  //设置背景url
  setCourseBackgroundInputUrl(String courseBackgroundInputUrl)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('courseBackgroundInputUrl', courseBackgroundInputUrl).then((c){
      CourseData.courseBackgroundInputUrl.value= courseBackgroundInputUrl;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
  }

  //获取背景url
  Future<String> getCourseBackgroundInputUrl() async {
    final prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('courseBackgroundInputUrl');
    CourseData.courseBackgroundInputUrl.value = path??"";
    return path??"";
  }

  //设置背景图片透明度
  setCourseBackgroundOpacity(double courseBackgroundOpacity)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('courseBackgroundOpacity', courseBackgroundOpacity).then((c){
      CourseData.courseBackgroundOpacity.value= courseBackgroundOpacity;
      //print('当前设定的Cookie：${ContextDate.cookie}');
    });
  }

  //获取背景图片透明度
  Future<double> getCourseBackgroundOpacity() async {
    final prefs = await SharedPreferences.getInstance();
    double? opacity = await prefs.getDouble('courseBackgroundOpacity');
    CourseData.courseBackgroundOpacity.value = opacity??0.5;
    return opacity??0.5;
  }
}