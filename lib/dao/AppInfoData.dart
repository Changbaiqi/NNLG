import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoData{
  static String? appName;
  static String? packageName;
  static String? version;
  static String? buildNumber;
  static int? versionNumber;

  //版本递增标识编号
  static init() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppInfoData.appName = packageInfo.appName;
    AppInfoData.packageName = packageInfo.packageName;
    AppInfoData.version = packageInfo.version;
    AppInfoData.buildNumber = packageInfo.buildNumber;
    AppInfoData.versionNumber = int.parse(packageInfo.buildNumber);
    Get.snackbar("版本测试", '${packageInfo.buildNumber}');
    // print(AppInfoData.versionNumber);
  }

  @override
  String toString() {
    return 'AppInfoData{}';
  }
}