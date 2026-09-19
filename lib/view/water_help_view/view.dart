import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';
import 'state.dart';

/// 打水教程：读取 assets/files/waterCourse.md（毛玻璃 + 渐变风格）
class WaterHelpViewPage extends StatelessWidget {
  WaterHelpViewPage({Key? key}) : super(key: key);

  final WaterHelpViewLogic logic = Get.put(WaterHelpViewLogic());
  final WaterHelpViewState state = Get.find<WaterHelpViewLogic>().state;

  static const String _page = 'main_water_view';

  /// 教程图片所在目录（markdown 里是 ./xxx.jpeg 这种相对路径）
  static const String _assetDir = 'assets/files/';

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
          title: Text('教程',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: text)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: [
            GlassCard(
              page: _page,
              padding: const EdgeInsets.all(6),
              child: Obx(() => MarkdownWidget(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    data: state.text.value,
                    config: MarkdownConfig(configs: [
                      PConfig(textStyle: TextStyle(color: text)),
                      //图片：支持 markdown 里的相对路径（本地 assets）与网络图片
                      ImgConfig(builder: _buildImage),
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /// 自定义图片渲染：
  /// ./xxx.jpeg 这类相对路径按 assets/files/ 目录下的本地图片加载，
  /// http(s) 开头仍走网络加载
  Widget _buildImage(String url, Map<String, String> attributes) {
    final String src = url.trim();
    //图片宽度：屏幕宽度 - 页面/卡片/markdown的内边距
    final double width =
        (MediaQuery.of(Get.context!).size.width - 64).clamp(80.0, 900.0);
    final Widget errorWidget = Container(
      width: width,
      height: 120,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image_outlined,
          color: GlassTheme.textColor(_page).withValues(alpha: .45)),
    );
    if (src.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          src,
          width: width,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) => errorWidget,
        ),
      );
    }
    //本地图片：./water_guide_1.jpeg -> assets/files/water_guide_1.jpeg
    String asset = src.startsWith('./') ? src.substring(2) : src;
    if (!asset.startsWith('assets/')) asset = '$_assetDir$asset';
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        asset,
        width: width,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      ),
    );
  }
}
