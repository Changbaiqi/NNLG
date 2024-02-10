import 'package:package_info_plus/package_info_plus.dart';

class AppInfoData{
  static String? appName;
  static String? packageName;
  static String? version;
  static String? buildNumber;
  //版本递增标识编号
  static int versionNumber=8;

  static init() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppInfoData.appName = packageInfo.appName;
    AppInfoData.packageName = packageInfo.packageName;
    AppInfoData.version = packageInfo.version;
    AppInfoData.buildNumber = packageInfo.buildNumber;
  }

  @override
  String toString() {
    return 'AppInfoData{}';
  }
}