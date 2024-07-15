import 'package:get/get.dart';

import '../../utils/FileUtils.dart';
import 'state.dart';

class SoftwareDevelopmentTestViewLogic extends GetxController {
  final SoftwareDevelopmentTestViewState state = SoftwareDevelopmentTestViewState();
  final tableJson = RxMap();

  @override
  void onInit() {
    FileUtils.loadJsonFromAssets("assets/files/scheduleJson.json").then((value){ tableJson.value=value;tableJson.refresh();});
  }
}
