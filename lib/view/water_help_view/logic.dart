import 'package:get/get.dart';

import 'package:callo/utils/FileUtils.dart';

import 'state.dart';

class WaterHelpViewLogic extends GetxController {
  final WaterHelpViewState state = WaterHelpViewState();

  ///读取打水教程markdown
  loadWaterCourse() async {
    try {
      final String text =
          await FileUtils.loadJsonFromAssets('assets/files/waterCourse.md');
      state.text.value = text;
    } catch (e) {
      print('读取打水教程失败: $e');
      state.text.value = '教程加载失败，请稍后重试';
    }
  }

  @override
  void onInit() {
    loadWaterCourse();
  }
}
