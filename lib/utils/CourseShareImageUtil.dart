/* FileName CourseShareImageUtil
 *
 * @Description 课表图片分享：把课表面积与当前背景图合成为一张图片
 * （课表外的背景图不在 RepaintBoundary 内，需要手动合成；
 *  同时课表整体比可视区域高，需要截取完整表格而不是可视区域）
 */
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/ColorExtractor.dart';

class CourseShareImageUtil {
  /// 画页面底色 + 课表背景图（cover 铺满 + 设置里的背景透明度）
  static Future<void> _paintBackground(
      ui.Canvas canvas, double width, double height) async {
    final Rect rect = Rect.fromLTWH(0, 0, width, height);
    //1) 页面底色（无背景图时就是主题底色）
    canvas.drawRect(rect, Paint()..color = CustomThemeData.pageColor);

    //2) 课表背景图：cover 铺满
    final Uint8List? bgBytes = await ColorExtractor.backgroundBytes();
    if (bgBytes == null) return;
    final ui.Codec codec = await ui.instantiateImageCodec(bgBytes);
    final ui.Image bgImage = (await codec.getNextFrame()).image;
    final double scale = max(width / bgImage.width, height / bgImage.height);
    final double drawW = bgImage.width * scale;
    final double drawH = bgImage.height * scale;
    final double opacity =
        CourseData.courseBackgroundOpacity.value.clamp(0.0, 1.0);
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = Colors.white.withValues(alpha: opacity),
    );
    canvas.drawImageRect(
      bgImage,
      Rect.fromLTWH(0, 0, bgImage.width.toDouble(), bgImage.height.toDouble()),
      Rect.fromLTWH((width - drawW) / 2, (height - drawH) / 2, drawW, drawH),
      Paint()..filterQuality = FilterQuality.medium,
    );
    canvas.restore();
    bgImage.dispose();
  }

  /// 课表长按分享/保存：
  /// [headerBoundary] 课表外层的星期栏（只取顶部 [headerHeight] 逻辑像素），
  /// [tableBoundary] 完整课表（比可视区域高，必须用它才能截全），
  /// 合成顺序：背景图 → 星期栏 → 完整课表
  static Future<Uint8List?> captureWeekWithBackground({
    required RenderRepaintBoundary headerBoundary,
    required RenderRepaintBoundary tableBoundary,
    double headerHeight = 50,
  }) async {
    try {
      final double dpr = ui.window.devicePixelRatio;
      final ui.Image header = await headerBoundary.toImage(pixelRatio: dpr);
      final ui.Image table = await tableBoundary.toImage(pixelRatio: dpr);
      if (table.width <= 0 || table.height <= 0) return null;

      final double headerPx =
          (headerHeight * dpr).clamp(0, header.height.toDouble()).toDouble();
      final double width =
          max(header.width, table.width).toDouble();
      final double height = headerPx + table.height;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas =
          ui.Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

      //1) 背景
      await _paintBackground(canvas, width, height);
      //2) 星期栏（只取顶部 headerPx）
      canvas.drawImageRect(
        header,
        Rect.fromLTWH(0, 0, header.width.toDouble(), headerPx),
        Rect.fromLTWH(0, 0, header.width.toDouble(), headerPx),
        Paint(),
      );
      //3) 完整课表（半透明面板会自然叠在背景上）
      canvas.drawImage(table, Offset(0, headerPx), Paint());
      header.dispose();
      table.dispose();

      return _encode(recorder, width, height);
    } catch (e) {
      print('合成课表分享图失败: $e');
      return null;
    }
  }

  /// 通用：捕获单个区域并按设置叠加背景图
  static Future<Uint8List?> captureWithBackground(
      RenderRepaintBoundary boundary) async {
    try {
      final double dpr = ui.window.devicePixelRatio;
      final ui.Image shot = await boundary.toImage(pixelRatio: dpr);
      final double width = shot.width.toDouble();
      final double height = shot.height.toDouble();
      if (width <= 0 || height <= 0) return null;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas =
          ui.Canvas(recorder, Rect.fromLTWH(0, 0, width, height));
      await _paintBackground(canvas, width, height);
      canvas.drawImage(shot, Offset.zero, Paint());
      shot.dispose();

      return _encode(recorder, width, height);
    } catch (e) {
      print('合成课表分享图失败: $e');
      return null;
    }
  }

  static Future<Uint8List?> _encode(
      ui.PictureRecorder recorder, double width, double height) async {
    final ui.Image merged =
        await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? data =
        await merged.toByteData(format: ui.ImageByteFormat.png);
    merged.dispose();
    return data?.buffer.asUint8List();
  }

  /// 把 PNG 写入临时目录并返回路径
  static Future<String> writeTempPng(Uint8List bytes) async {
    final Directory tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) {
      await tempDir.create(recursive: true);
    }
    final File file = File(
        '${tempDir.path}/course_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
