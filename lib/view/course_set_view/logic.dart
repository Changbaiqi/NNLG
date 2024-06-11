import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  void onInit() {
    backGroundUrlController.text = CourseData.courseBackgroundInputUrl.value;
  }

  @override
  void onClose() {
    ShareDateUtil().setCourseBackgroundInputUrl(backGroundUrlController.text);
  }
}
