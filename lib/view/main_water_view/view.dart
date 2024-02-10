import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/WaterData.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/WaterUtil.dart';
import 'package:nnlg/view/ScanKit_Water.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class MainWaterViewPage extends StatelessWidget {
  MainWaterViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainWaterViewLogic());
  final state = Get.find<MainWaterViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: Drawer(
          width: 200,
          child: Center(
            child: Text('加载中...'),
          )),
      body: RefreshIndicator(
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Obx(() => Column(
                            children: [
                              Text(
                                '${(state.money.value == "" || state.money.value == null) ? "0.00" : state.money.value}￥',
                                style: TextStyle(
                                    fontSize: 50, color: Colors.orange),
                              ),
                              Text('当前所选设备编号：${state.divice.value ?? "未知"}')
                            ],
                          )),
                    ),
                  ),
                  Container(
                    height: 539,
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: this._coolWaterSw(),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: this._hostWaterSw(),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: bingWater(),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: bingAccount(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                  )
                ],
              );
            }),
        onRefresh: logic.onRefresh,
      ),
    );
  }

  Widget _coolWaterSw() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('开',style: TextStyle(fontSize: 20,color: Colors.black54)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150)))),
            onPressed: () {
              logic.coolOpenWaterButtonCheck();
            },
          ),
        ),
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('关',style: TextStyle(fontSize: 20,color: Colors.black54),),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150)))),
            onPressed: () {
              logic.coolCloseWaterButtonCheck();
            },
          ),
        )
      ],
    );
  }

  Widget _hostWaterSw() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('开',style: TextStyle(fontSize: 20,color: Colors.black54)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(150),
                ))),
            onPressed: () {
              logic.hotOpenWaterButtonCheck();
            },
          ),
        ),
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('关',style: TextStyle(fontSize: 20,color: Colors.black54)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150)))),
            onPressed: () {
              logic.hotCloseWaterButtonCheck();
            },
          ),
        )
      ],
    );
  }

  Widget bingAccount() {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
                '账号：${state.bingCard.value.isEmpty ? "未绑定" : state.bingCard.value}'),
          ),
          Row(
            children: [
              Visibility(
                  visible: WaterData.waterAccount.value.isEmpty ||
                          WaterData.waterAccount.value == ""
                      ? false
                      : true,
                  //检查账号是否为空
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.WaterCharge);
                        },
                        child: Text('充值')),
                  )),
              ElevatedButton(
                  onPressed: () {
                    if (WaterData.waterAccount.value.isEmpty) {
                      logic..bingShow();
                    } else {
                      ShareDateUtil().setWaterUnBind().then((value) {
                        state.bingCard.value = "";
                        Get.snackbar("提示", "解绑成功",
                            duration: Duration(milliseconds: 1500));
                      });
                    }
                  },
                  child: Obx(() => Text(
                      '${WaterData.waterAccount.value.isEmpty ? "绑定" : "解绑"}')))
            ],
          )
        ],
      ),
    );
  }

  Widget bingWater() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 60,
          width: 100,
          child: ElevatedButton(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.camera_alt), Text('绑定')],
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
            onPressed: () async {
              String result = await Navigator.push(logic.context!,
                  MaterialPageRoute(builder: (builder) {
                //return ScanQR_Water();
                return ScanKit_Water();
              }));
              //ToastUtil().show(result);
              WaterUtil().bindCoolWater(result);
            },
          ),
        ),
        Container(
          height: 60,
          width: 100,
          child: ElevatedButton(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.camera_alt), Text('绑定')],
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
            onPressed: () async {
              String result = await Navigator.push(logic.context!,
                  MaterialPageRoute(builder: (builder) {
                return ScanKit_Water();
              }));
              WaterUtil().bindHotWater(result); //绑定热水
            },
          ),
        )
      ],
    );
  }
}
