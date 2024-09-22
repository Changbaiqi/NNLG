import 'package:get/get.dart';

import '../../utils/FileUtils.dart';
import 'state.dart';

class AboutMeViewLogic extends GetxController {
  final AboutMeViewState state = AboutMeViewState();

  //加载markdown文件
  loadAboutMeMarkDown(){
    FileUtils.loadJsonFromAssets('assets/files/aboutMe.md').then((value) => state.aboutMeText.value=value);
    
  }
  @override
  void onInit() {
    loadAboutMeMarkDown();
  }
}
