import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;

import 'state.dart';

class WaterChargeViewLogic extends GetxController {
  final WaterChargeViewState state = WaterChargeViewState();

  Future<Uint8List?> capturePng() async{

    try{
      RenderRepaintBoundary? boundary = state.repainKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes!));
      if(result != null && result != ""){
        //var str = Uri.decodeComponent(result);
        Get.snackbar('通知', '保存成功',duration: Duration(milliseconds: 1500));
      }else{
        Get.snackbar('通知', '保存失败',duration: Duration(milliseconds: 1500));
      }

      return pngBytes;
    }catch(e){
      print(e);
    }

    return null;

  }
}
