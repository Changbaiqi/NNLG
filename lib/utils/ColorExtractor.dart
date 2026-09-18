/* FileName ColorExtractor
 *
 * @Description 从课表背景图片中提取主题种子色（Material You 风格自动取色）
 */
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:callo/dao/CourseData.dart';

class ColorExtractor {
  //与课表随机二次元背景一致的接口
  static const String _randomUrl =
      'https://img.xjh.me/random_img.php?type=bg&ctype=nature&return=302';

  /// 读取当前课表背景图的字节（随机链接 / 自定义URL / 本地图片）
  static Future<Uint8List?> backgroundBytes() async {
    try {
      if (!CourseData.isPictureBackground.value) return null;
      if (CourseData.isRandomQuadraticBackground.value) {
        return _download(_randomUrl);
      }
      if (CourseData.isUrlBackground.value) {
        final String url =
            CourseData.courseBackgroundInputUrl.value.trim();
        if (url.isEmpty) return null;
        return _download(url);
      }
      if (CourseData.isCustomerLocalBackground.value) {
        final String path = CourseData.courseBackgroundFilePath.value;
        if (path.isEmpty) return null;
        final File file = File(path);
        if (!await file.exists()) return null;
        return await file.readAsBytes();
      }
    } catch (e) {
      print('背景图读取失败: $e');
    }
    return null;
  }

  static Future<Uint8List?> _download(String url) async {
    final Response<List<int>> response = await Dio().get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        receiveTimeout: const Duration(seconds: 15),
        connectTimeout: const Duration(seconds: 10),
      ),
    );
    final List<int>? data = response.data;
    if (data == null || data.isEmpty) return null;
    return Uint8List.fromList(data);
  }

  /// 解析图片并提取种子色（失败返回 null）
  static Future<Color?> extractSeed(Uint8List bytes) async {
    try {
      //降采样到 48 宽，足够取色且开销很小
      final ui.Codec codec =
          await ui.instantiateImageCodec(bytes, targetWidth: 48);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ByteData? byteData =
          await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
      frame.image.dispose();
      if (byteData == null) return null;
      return seedFromRgba(byteData.buffer.asUint8List());
    } catch (e) {
      print('背景取色失败: $e');
      return null;
    }
  }

  /// 从 RGBA 像素中提取种子色（纯函数，便于测试）
  /// 策略：过滤过暗/过亮/透明像素，按饱和度平方加权求平均，
  /// 再适当提高饱和度，保证近灰图片也能得到像样的主题色
  static Color? seedFromRgba(Uint8List pixels) {
    double r = 0, g = 0, b = 0, weightSum = 0;
    for (int i = 0; i + 3 < pixels.length; i += 4) {
      final int a = pixels[i + 3];
      if (a < 128) continue;
      final int pr = pixels[i], pg = pixels[i + 1], pb = pixels[i + 2];
      final double maxC = max(pr, max(pg, pb)).toDouble();
      final double minC = min(pr, min(pg, pb)).toDouble();
      final double saturation = maxC == 0 ? 0 : (maxC - minC) / maxC;
      final double luminance =
          (0.2126 * pr + 0.7152 * pg + 0.0722 * pb) / 255;
      //跳过过暗/过亮的像素（多数是背景/水印）
      if (luminance < 0.08 || luminance > 0.95) continue;
      final double weight = 0.15 + saturation * saturation * 2.0;
      r += pr * weight;
      g += pg * weight;
      b += pb * weight;
      weightSum += weight;
    }
    if (weightSum <= 0) return null;
    Color seed = Color.fromARGB(
      255,
      (r / weightSum).round().clamp(0, 255),
      (g / weightSum).round().clamp(0, 255),
      (b / weightSum).round().clamp(0, 255),
    );
    //过于灰的图片：提高饱和度并收拢明度，让主题色更鲜明
    final HSLColor hsl = HSLColor.fromColor(seed);
    if (hsl.saturation < .35) {
      seed = hsl
          .withSaturation(.55)
          .withLightness(hsl.lightness.clamp(.35, .65))
          .toColor();
    }
    return seed;
  }
}
