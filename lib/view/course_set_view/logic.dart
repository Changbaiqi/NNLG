import 'dart:developer';
import 'dart:io';

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
      File _imgPath = File(pickerImages.path);
      await getApplicationDocumentsDirectory().then((value) async {
        _imgPath.copy(value.path + "/user.jpg");
        // print("读取：" + AccountData.head_filePath.value);
        // print("地址：" + value.path + "/user.jpg");
        await ShareDateUtil()
            .setCourseBackgroundFilePath(value.path + "/user.jpg");
      });

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
