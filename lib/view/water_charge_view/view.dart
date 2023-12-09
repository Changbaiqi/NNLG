import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/WaterData.dart';
import 'package:qr_flutter/qr_flutter.dart';


import 'logic.dart';

class WaterChargeViewPage extends StatelessWidget {
  WaterChargeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<WaterChargeViewLogic>();
  final state = Get.find<WaterChargeViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('充值'),),
      body: Container(
        child: QtCteater(),
      ),
    );
  }


  Widget QtCteater(){

    return Container(
      child: Column(
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: RepaintBoundary(
              key: state.repainKey,
              child: Card(
                child: Column(
                  children: [
                    InkWell(
                      child: QrImageView(
                        data: "http://wx.happy-ti.com/wxpay/scanqrcode/addvalue.html?saler=${WaterData.waterSaler}&app=WECHAT&card_number=${WaterData.cardNum}&userid=18378099595&openid=${WaterData.waterAccount}"
                        ,size: 300
                        ,embeddedImage: AssetImage("images/NNLG.png"),),
                      onLongPress: (){
                        //ToastUtil.show('测试');
                        logic.capturePng();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text('长按上述二维码保存至本地后然后通过微信扫码功能扫描保存的二维码即可'),
                    )
                  ],
                ),
              ),
            ),),



        ],
      ),
    );

  }


}
