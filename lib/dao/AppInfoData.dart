import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoData{
  static final  appName = "".obs;
  static final packageName = "".obs;
  static final version = "".obs;
  static final buildNumber = "".obs;
  static final versionNumber = 0.obs;

  //版本递增标识编号
  static init() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppInfoData.appName.value = packageInfo.appName;
    AppInfoData.packageName.value = packageInfo.packageName;
    AppInfoData.version.value = packageInfo.version;
    AppInfoData.buildNumber.value = packageInfo.buildNumber;
    // AppInfoData.versionNumber.value = 3;
    AppInfoData.versionNumber.value = int.parse(packageInfo.buildNumber);
    // Get.snackbar("版本测试", '${packageInfo.buildNumber}');
    // print(AppInfoData.versionNumber);
  }

  @override
  String toString() {
    return 'AppInfoData{}';
  }
}