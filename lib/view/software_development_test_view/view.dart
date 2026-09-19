import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              margin: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(logic.huntButtonColor.value)),
                  //扫描中禁用按钮避免重复点击
                  onPressed:
                      logic.isHunting.value ? null : () => logic.huntWiFis(),
                  child: Text(
                      logic.isHunting.value ? '正在扫描...' : 'Hunt Networks')),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                logic.huntMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(logic.huntButtonColor.value)),
                  onPressed: () => logic.copyPayload(),
                  child: const Text('Copy')),
            ),
            //扫描结果列表（展示全部AP，NNLGXY 5G 的会标记出来）
            if (logic.allAps.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '共 ${logic.allAps.length} 个AP（NNLGXY(5G) ${logic.list.length} 个）',
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            if (logic.allAps.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 12.0, right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(logic.allAps.length, (index) {
                    final ap = logic.allAps.value[index];
                    final bool isTarget = ap["isTarget"] == true;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        leading: Text('${ap["Level"]} dbm'),
                        title: Row(
                          children: [
                            Flexible(child: Text('${ap["SSID"]}')),
                            if (isTarget) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'NNLGXY·5G',
                                  style: TextStyle(fontSize: 10.5),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('BSSID : ${ap["BSSID"]}'),
                              Text('Capabilities : ${ap["Capabilities"]}'),
                              Text('Frequency : ${ap["Frequency"]}'),
                              Text('Channel Width : ${ap["Channel Width"]}'),
                              Text('Timestamp : ${ap["Timestamp"]}'),
                            ]),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      )),
    );
  }
}
