import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:callo/dao/WaterData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

import 'state.dart';

class SoftwareDevelopmentTestViewLogic extends GetxController {
  final SoftwareDevelopmentTestViewState state = SoftwareDevelopmentTestViewState();
  final wiFiHunterResult = WiFiHunterResult().obs;
  final huntButtonColor = GlassTheme.scheme.primary.obs;

  /// 全部扫描结果（列表展示用）
  final allAps = [].obs;

  /// 符合饮水机条件的 NNLGXY 5G 频段AP（Copy 用）
  final list = [].obs;

  final isHunting = false.obs; //是否正在扫描
  final huntMessage = '点击「Hunt Networks」开始扫描'.obs; //扫描状态提示

  Future<void> huntWiFis() async {
    if (isHunting.value) return; //避免重复点击
    isHunting.value = true;
    huntMessage.value = '正在扫描周围的WiFi...';
    try {
      //扫描WiFi需要位置权限且定位服务已开启（Android 6+），否则系统会返回空结果
      if (!await checkLocationReady()) return;
      //插件在扫描被系统限流/失败时不会返回结果，加超时避免按钮点了没反应
      final WiFiHunterResult? result = await WiFiHunter.huntWiFiNetworks
          .timeout(const Duration(seconds: 10));
      wiFiHunterResult.value = result ?? WiFiHunterResult();
      fillLists();
      huntMessage.value = allAps.isEmpty
          ? '扫描完成：没有扫描到任何AP（请确认定位服务与位置权限已开启）'
          : '扫描完成：共 ${allAps.length} 个AP，其中 NNLGXY(5G) ${list.length} 个';
    } on TimeoutException {
      huntMessage.value = '扫描超时：请确认已开启「定位服务」并授予位置权限';
      ToastUtil.show('WiFi扫描超时，请确认已开启定位服务与位置权限');
    } on PlatformException catch (e) {
      final String msg = '${e.message}'.toLowerCase().contains('throttl')
          ? '扫描太频繁（系统限制：2分钟内最多4次），请稍后再试'
          : '扫描失败：${e.message}';
      huntMessage.value = msg;
      ToastUtil.show(msg);
    } catch (e) {
      huntMessage.value = '扫描失败：$e';
      ToastUtil.show('扫描失败：$e');
    } finally {
      isHunting.value = false;
      log('WiFi扫描：$huntMessage');
    }
  }

  /// 把扫描结果转成列表数据：
  /// allAps = 全部AP（展示用）；list = NNLGXY 5G（复制用）
  void fillLists() {
    allAps.clear();
    list.clear();
    for (int i = 0; i < wiFiHunterResult.value.results.length; i++) {
      final result = wiFiHunterResult.value.results[i];
      final bool isTarget =
          result.ssid == "NNLGXY" && result.frequency >= 5000;
      final Map<String, dynamic> item = {
        "SSID": result.ssid.isEmpty ? "(隐藏网络)" : result.ssid,
        "Level": result.level,
        "BSSID": result.bssid,
        "Capabilities": result.capabilities,
        "Frequency": result.frequency.toString(),
        "Channel Width": result.channelWidth.toString(),
        "Timestamp":
            DateTime.fromMicrosecondsSinceEpoch(result.timestamp).toString(),
        "isTarget": isTarget,
      };
      allAps.add(item);
      if (isTarget) list.add(item); //过滤非NNLGXY的AP
    }
    allAps.value.sort((a, b) => b["Level"].compareTo(a["Level"]));
    list.value.sort((a, b) => b["Level"].compareTo(a["Level"]));
    allAps.refresh();
    list.refresh();
  }

  /// 复制饮水机调试用的payload
  Future<void> copyPayload() async {
    final Map<String, dynamic> map = {
      "hotDeviceId": WaterData.hotWater.value,
      "coldDeviceId": WaterData.coolWater.value,
      "inform": {"label": "测试"},
      "ap": list.map((element) => "${element['BSSID']}").toList(),
    };
    try {
      await Clipboard.setData(ClipboardData(text: jsonEncode(map)));
      ToastUtil.show('已复制（NNLGXY ${list.length} 个AP的BSSID）');
    } catch (e) {
      ToastUtil.show('复制失败：$e');
    }
  }

  /// 检查定位服务与位置权限（扫描WiFi必须，否则扫描结果为空）
  Future<bool> checkLocationReady() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      huntMessage.value = '请先开启手机「定位服务」（扫描WiFi需要）';
      ToastUtil.show('请先开启手机定位服务');
      await Geolocator.openLocationSettings();
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      huntMessage.value = '需要位置权限才能扫描WiFi，请在系统设置中授予';
      ToastUtil.show('需要位置权限才能扫描WiFi');
      return false;
    }
    return true;
  }
}
