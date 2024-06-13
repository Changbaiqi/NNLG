import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/ClassScheduleDao.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/entity/ClassScheduleEntity.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'state.dart';

class CourseSetViewLogic extends GetxController {
  final CourseSetViewState state = CourseSetViewState();
  final ImagePicker picker = ImagePicker();
  final TextEditingController backGroundUrlController = TextEditingController();


  Future<String> getFileHash(String filePath) async {
    final file = File(filePath);
    final fileLength = file.lengthSync();

    final fileBytes = file.readAsBytesSync().buffer.asUint8List();
    final hash = md5.convert(fileBytes.buffer.asUint8List()).toString();
    return hash;
  }

  /**
   * [title] 获取设置本地背景图片
   * [author] 长白崎
   * [description] //TODO
   * [date] 0:43 2024/6/10
   * [param] null
   * [return]
   */
  Future getImage() async {
    final pickerImages = await picker.pickImage(source: ImageSource.gallery);
    // if (mounted) {
    if (pickerImages != null) {
      if(CourseData.courseBackgroundFilePath.value!="") await File(CourseData.courseBackgroundFilePath.value).delete();
      String fileName = await getFileHash(pickerImages.path);
      File _imgPath = File(pickerImages.path);
      await getApplicationDocumentsDirectory().then((value) async {
        _imgPath.copy(value.path + '/courseBackground_${fileName}.jpg');
        // print("读取：" + AccountData.head_filePath.value);
        // print("地址：" + value.path + "/user.jpg");
        await ShareDateUtil()
            .setCourseBackgroundFilePath(value.path + '/courseBackground_${fileName}.jpg');
      });
      Get.snackbar(
        "课表通知",
        "选择图片成功",
        duration: Duration(
            milliseconds: 1500),
      );
      //Navigator.pop(context,pickerImages.path);
    } else {
      print('没有照片可以选择');
    }
  }


  //刷新课表
  Future<void> onRefresh() async {

    //同步拉取教务系统课表
    List<String> newestCourse = await CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList.value}");
    //课表缓存逻辑执行
    await cacheClassSchedule(AccountData.studentID, CourseData.nowCourseList.value, newestCourse);
    //首次获取课表逻辑
    await firstClassScheduleLogic(AccountData.studentID, CourseData.nowCourseList.value, newestCourse);
    //拉取显示最新课表逻辑
    await newestClassScheduleLogic(AccountData.studentID, CourseData.nowCourseList.value, newestCourse);
    // ShareDateUtil().setWeekCourseList(newestCourse); //设置课表
  }

  //用于缓存课表的
  cacheClassSchedule(String studentId, String semester, List<String> classSchedule) async {
    //获取最新课表数据
    ClassScheduleEntity? newestClassSchedule = await GetIt.I<ClassScheduleDao>()
        .findNewestClassSchedule(
        AccountData.studentID, CourseData.nowCourseList.value);
    String scheduleMd5 = md5
        .convert(utf8.encode(jsonEncode(classSchedule).toString()))
        .toString(); //课表数据的md5码
    //如果没有任何一条记录那么直接先插入现在的数据
    if (newestClassSchedule == null) {
      //存入
      await GetIt.I<ClassScheduleDao>().insertClassSchedule(ClassScheduleEntity(
          uid: Uuid().v1(),
          //UUID生成
          studentId: AccountData.studentID,
          //用户学号
          semester: CourseData.nowCourseList.value,
          //课表学期
          dateTime: DateTime.now(),
          //更新时间
          md5: scheduleMd5,
          //课表数据的md5值
          list: classSchedule) //课表数据
      );
      return; //如果不存在最新的那么直接退出
    }

    //如果内容相同那么久不用更新了，说明当前就已经是最新课表
    if (scheduleMd5 == newestClassSchedule.md5) return;

    log(newestClassSchedule.id.toString());
    log(newestClassSchedule.uid.toString());
    log(newestClassSchedule.dateTime.toString());
    log(newestClassSchedule.md5.toString());

    //如果数据不相同那么存入
    await GetIt.I<ClassScheduleDao>().insertClassSchedule(ClassScheduleEntity(
        uid: Uuid().v1(),
        //UUID生成
        studentId: AccountData.studentID,
        //用户学号
        semester: CourseData.nowCourseList.value,
        //课表学期
        dateTime: DateTime.now(),
        //更新时间
        md5: scheduleMd5,
        //课表数据的md5值
        list: classSchedule) //课表数据
    );

    // log(newestClassSchedule.json.toString());
    // GetIt.I<ClassScheduleDao>().deleteClassSchedule(newestClassSchedule);
    // var list = await GetIt.I<ClassScheduleDao>().findAllClassSchedule();
    // for(var classSchedule in list){
    //   log('${classSchedule.id.toString()}-${classSchedule.dateTime}-${classSchedule.uid}-${classSchedule.json}');
    //   int num =await GetIt.I<ClassScheduleDao>().deleteClassSchedule(classSchedule!);
    //   log('删除了：$num');
    // }
  }

  //首次课表获取逻辑
  firstClassScheduleLogic(String studentId,String semester,List<String> classSchedule) async{
    //获取最新课表数据
    ClassScheduleEntity? newestClassSchedule = await GetIt.I<ClassScheduleDao>()
        .findNewestClassSchedule(
        AccountData.studentID, CourseData.nowCourseList.value);
    if(CourseData.showClassScheduleUUID.value==""){ //如果最新课表数据为空那么说明为第一次获取课表
      ShareDateUtil().setShowClassScheduleUUID((newestClassSchedule?.uid)!); //设置当前课表显示的UUID
      ShareDateUtil().setWeekCourseList(classSchedule); //直接显示这个课表
    }
  }

  //最新课表显示逻辑
  newestClassScheduleLogic(String studentId, String semester, List<String> classSchedule) async {
    //获取最新课表数据
    ClassScheduleEntity? newestClassSchedule = await GetIt.I<ClassScheduleDao>()
        .findNewestClassSchedule(
        AccountData.studentID, CourseData.nowCourseList.value);
    ShareDateUtil().setShowClassScheduleUUID((newestClassSchedule?.uid)!); //设置当前课表显示的UUID
    ShareDateUtil().setWeekCourseList(classSchedule); //直接显示这个课表
  }

  //显示指定UUID课表逻辑
  showClassScheduleForUUID(String UUID)async{
    ClassScheduleEntity? classSchedule = await GetIt.I<ClassScheduleDao>()
        .findClassScheduleForUid(UUID);
    ShareDateUtil().setShowClassScheduleUUID((classSchedule?.uid)!); //设置当前课表显示的UUID
    ShareDateUtil().setWeekCourseList((classSchedule?.list)!); //直接显示这个课表
  }



  @override
  void onInit() {
    backGroundUrlController.text = CourseData.courseBackgroundInputUrl.value;
  }

  @override
  void onClose() {
    ShareDateUtil().setCourseBackgroundInputUrl(backGroundUrlController.text);
  }
}
