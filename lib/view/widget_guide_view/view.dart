import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:callo/utils/FileUtils.dart';
import 'package:callo/utils/GlassUI.dart';

/// 桌面小组件添加教程：markdown 内容来自 assets/files/smallElementCourse.md
class WidgetGuideViewPage extends StatelessWidget {
  const WidgetGuideViewPage({Key? key}) : super(key: key);

  static const String _page = 'main_course_view';
  static const String _mdPath = 'assets/files/smallElementCourse.md';

  @override
  Widget build(BuildContext context) {
    final Color textColor = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: textColor,
          iconTheme: IconThemeData(color: textColor),
          title: Text('添加桌面小组件教程',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: textColor)),
        ),
        body: FutureBuilder<String>(
          future: FileUtils.loadJsonFromAssets(_mdPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: accent),
                ),
              );
            }
            final String markdown = (snapshot.data ?? '').trim();
            if (markdown.isEmpty) {
              return Center(
                child: Text('教程加载失败，请稍后再试',
                    style: TextStyle(
                        fontSize: 13, color: textColor.withValues(alpha: .6))),
              );
            }
            return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  GlassCard(
                    page: _page,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: MarkdownWidget(
                      data: markdown,
                      shrinkWrap: true,
                      config: MarkdownConfig(configs: [
                        PConfig(
                            textStyle: TextStyle(
                                fontSize: 13.5,
                                height: 1.8,
                                color: textColor.withValues(alpha: .92))),
                        H1Config(
                            style: TextStyle(
                                fontSize: 19,
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                color: textColor)),
                        H2Config(
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                color: textColor)),
                        H3Config(
                            style: TextStyle(
                                fontSize: 14.5,
                                height: 1.6,
                                fontWeight: FontWeight.w600,
                                color: textColor)),
                        LinkConfig(
                            style: TextStyle(
                                fontSize: 13.5,
                                color: accent,
                                decoration: TextDecoration.underline,
                                decorationColor: accent)),
                        CodeConfig(
                            style: TextStyle(
                                fontSize: 13,
                                backgroundColor:
                                    textColor.withValues(alpha: .08))),
                        ImgConfig(
                            builder: (url, attributes) =>
                                _buildImage(url, textColor)),
                      ]),
                    ),
                  ),
                ],
              );
          },
        ),
      ),
    );
  }

  /// 图片加载：网络图片直接加载；本地图片按 assets/files/ 解析，
  /// 兼容 ./、/、assets/ 等前缀写法，找不到时依次回退
  Widget _buildImage(String url, Color textColor) {
    final String raw = url.trim();
    if (raw.startsWith('http')) {
      return _wrapImage(Image.network(raw,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _imageError(raw, textColor)));
    }

    final List<String> candidates = <String>[];
    void add(String path) {
      if (path.isNotEmpty && !candidates.contains(path)) candidates.add(path);
    }

    String stripped = raw;
    while (stripped.startsWith('./') || stripped.startsWith('/')) {
      stripped = stripped.startsWith('./')
          ? stripped.substring(2)
          : stripped.substring(1);
    }
    if (stripped.startsWith('assets/')) {
      add(stripped);
      add('assets/files/${stripped.split('/').last}');
    } else {
      add('assets/files/$stripped');
      add(stripped);
    }

    Widget buildAt(int index) {
      if (index >= candidates.length) return _imageError(raw, textColor);
      return Image.asset(candidates[index],
          fit: BoxFit.cover,
          //按宽度降采样解码，避免整屏截图占用过多内存
          cacheWidth: 720,
          errorBuilder: (_, __, ___) => buildAt(index + 1));
    }

    return _wrapImage(buildAt(0));
  }

  Widget _wrapImage(Widget image) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image,
      ),
    );
  }

  Widget _imageError(String url, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text('图片加载失败：$url',
          style: TextStyle(
              fontSize: 12, color: textColor.withValues(alpha: .6))),
    );
  }
}
