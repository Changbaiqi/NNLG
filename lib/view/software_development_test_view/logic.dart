import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:callo/utils/CourseUtil.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

import '../../utils/FileUtils.dart';
import 'state.dart';

class SoftwareDevelopmentTestViewLogic extends GetxController {
  final SoftwareDevelopmentTestViewState state = SoftwareDevelopmentTestViewState();
  final wiFiHunterResult = WiFiHunterResult().obs;
  final huntButtonColor = Colors.lightBlue.obs;
  final list = [].obs;
  Future<void> huntWiFis() async {
    // setState(() => huntButtonColor = Colors.red);

    try {
      wiFiHunterResult.value = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      print(exception.toString());
    }
    list.clear();
    for (int i = 0; i < wiFiHunterResult.value.results.length; i++) {
      if(wiFiHunterResult.value.results[i].frequency<5000) continue;
      if(wiFiHunterResult.value.results[i].ssid!="NNLGXY") continue; //过滤非NNLGXY名称的AP
      list.add({
        "SSID": wiFiHunterResult.value.results[i].ssid, //AP名称
        "Level": wiFiHunterResult.value.results[i].level,
        "BSSID": wiFiHunterResult.value.results[i].bssid,
        "Capabilities": wiFiHunterResult.value.results[i].capabilities,
        "Frequency": wiFiHunterResult.value.results[i].frequency.toString(),
        "Channel Width": wiFiHunterResult.value.results[i].channelWidth.toString(),
        "Timestamp": DateTime.fromMicrosecondsSinceEpoch(wiFiHunterResult.value.results[i].timestamp).toString()
      });
    }
    list.value.sort((a,b)=>b["Level"].compareTo(a["Level"]));
    // if (!mounted) return;
    wiFiHunterResult.refresh();
    list.refresh();
    huntButtonColor.value = Colors.lightBlue;
    // setState(() => huntButtonColor = Colors.lightBlue);
  }
  @override
  void onInit() {
    huntWiFis();

  }
}
