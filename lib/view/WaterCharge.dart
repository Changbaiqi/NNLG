import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nnlg/dao/WaterData.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:qr_flutter/qr_flutter.dart';



//充值界面
class WaterCharge extends StatefulWidget {
  const WaterCharge({Key? key}) : super(key: key);

  @override
  State<WaterCharge> createState() => _WaterChargeState();
}

class _WaterChargeState extends State<WaterCharge> {
  GlobalKey repainKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('充值'),),
      body: Container(
        child: QtCteater(),
      ),
    );
  }

  Future<Uint8List?> capturePng() async{

    try{
      RenderRepaintBoundary? boundary = repainKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes!));
      if(result != null && result != ""){
        //var str = Uri.decodeComponent(result);
        ToastUtil.show('保存成功');


      }else{
        ToastUtil.show('保存失败');
      }

      return pngBytes;
    }catch(e){
      print(e);
    }

    return null;

  }

  Widget QtCteater(){

    return Container(
      child: Column(
        children: [

          Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: RepaintBoundary(
              key: repainKey,
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
                        capturePng();

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



