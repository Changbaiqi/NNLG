import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/view/module/ClassScheduleWidget.dart';

import 'logic.dart';

class SoftwareDevelopmentTestViewPage extends StatelessWidget {
  SoftwareDevelopmentTestViewPage({Key? key}) : super(key: key);

  final logic = Get.find<SoftwareDevelopmentTestViewLogic>();
  final state = Get.find<SoftwareDevelopmentTestViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFiHunter example app'),
      ),
      body: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(logic.huntButtonColor.value)),
                  onPressed: () => logic.huntWiFis(),
                  child: const Text('Hunt Networks')
              ),
            ),
            logic.wiFiHunterResult.value.results.isNotEmpty ? Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 30.0, right: 30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(logic.list.length, (index) {
                    if(logic.wiFiHunterResult.value.results[index].frequency<5000)return Container(height: 0,);
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                          leading: Text(logic.list.value[index]["Level"].toString() + ' dbm'),
                          title: Text(logic.wiFiHunterResult.value.results[index].ssid),
                          subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('BSSID : ' + logic.list.value[index]["BSSID"]),
                                Text('Capabilities : ' + logic.list.value[index]["Capabilities"]),
                                Text('Frequency : ' + logic.list.value[index]["Frequency"]),
                                Text('Channel Width : ' + logic.list.value[index]["Channel Width"]),
                                Text('Timestamp : ' + logic.list.value[index]["Timestamp"])

                              ]
                          )
                      ),
                    );
                  }
                  )
              ),
            ) : Container()
          ],
        ),
      )),
    );
  }
}
