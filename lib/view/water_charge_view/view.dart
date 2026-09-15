import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:callo/dao/WaterData.dart';
import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';

/// 打水充值（二维码）：毛玻璃 + 渐变风格
class WaterChargeViewPage extends StatelessWidget {
  WaterChargeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<WaterChargeViewLogic>();
  final state = Get.find<WaterChargeViewLogic>().state;

  static const String _page = 'main_water_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: text,
          iconTheme: IconThemeData(color: text),
          title: Text('账户充值',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: text)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            GlassCard(
              page: _page,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                children: [
                  //二维码需保持白底深色以保证可扫描性
                  RepaintBoundary(
                    key: state.repainKey,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onLongPress: () {
                        logic.capturePng();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: .12),
                                blurRadius: 16,
                                offset: const Offset(0, 8))
                          ],
                        ),
                        child: Column(
                          children: [
                            QrImageView(
                              data:
                                  "http://wx.happy-ti.com/wxpay/scanqrcode/addvalue.html?saler=${WaterData.waterSaler}&app=WECHAT&card_number=${WaterData.cardNum}&userid=18378099595&openid=${WaterData.waterAccount}",
                              size: 260,
                              eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Colors.black87),
                              dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Colors.black87),
                              embeddedImage:
                                  const AssetImage("images/NNLG.png"),
                            ),
                            const SizedBox(height: 8),
                            const Text('微信扫一扫充值',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '长按二维码可保存到相册，然后在微信中从相册选择该二维码扫码充值',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: text.withValues(alpha: .6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
