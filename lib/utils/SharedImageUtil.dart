/* FileName SharedImageUtil
 *
 * @Description 接收系统分享进来的图片，并可设为课表背景 / 桌面课表小组件背景
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';

class SharedImageUtil {
  static const MethodChannel _channel =
      MethodChannel('com.cbq.callocollege/share');

  static bool _pendingShow = false;
  static String? _pendingPath;

  /// 初始化：监听系统分享进来的图片（App 启动时调用一次）
  static void init() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'sharedImageReceived') {
        final String? path =
            call.arguments is String ? call.arguments as String : null;
        if (path == null || path.isEmpty) return null;
        if (Get.context != null) {
          _showDialog(path);
        } else {
          _pendingShow = true;
          _pendingPath = path;
          _scheduleFallback();
        }
      }
      return null;
    });
    // 冷启动：native 侧可能已收到分享意图
    _channel.invokeMethod<String>('consumeSharedImage').then((path) {
      if (path != null && path.isNotEmpty) {
        if (Get.context != null) {
          //等首屏稳定后再弹，避免和启动页抢焦点
          Future.delayed(const Duration(seconds: 2), () => _showDialog(path));
        } else {
          _pendingShow = true;
          _pendingPath = path;
          _scheduleFallback();
        }
      }
    }).catchError((e) {
      print('分享图片监听失败: $e');
    });
  }

  /// 冷启动兜底：界面就绪后再弹选择框
  static void _scheduleFallback({int attempt = 0}) {
    if (attempt > 6) return;
    Future.delayed(const Duration(seconds: 3), () {
      if (!_pendingShow) return;
      if (Get.context == null) {
        _scheduleFallback(attempt: attempt + 1);
        return;
      }
      _pendingShow = false;
      final String? path = _pendingPath;
      _pendingPath = null;
      if (path != null) _showDialog(path);
    });
  }

  /// 询问要把图片设置为哪种背景
  static Future<void> _showDialog(String path) async {
    final BuildContext? context = Get.context;
    if (context == null) return;
    final String? choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .32),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: GlassCard(
            page: 'course_set_view',
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 4),
                  child: Text(
                    '收到一张图片，要设置为哪种背景？',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_size_select_actual_rounded),
                  title: const Text('设为课表背景图'),
                  onTap: () => Navigator.pop(ctx, 'course'),
                ),
                ListTile(
                  leading: const Icon(Icons.widgets_rounded),
                  title: const Text('设为桌面课表小组件背景'),
                  onTap: () => Navigator.pop(ctx, 'widget'),
                ),
                ListTile(
                  leading: const Icon(Icons.close_rounded),
                  title: const Text('取消'),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (choice == null) return;
    if (choice == 'course') {
      await _applyCourseBackground(path);
    } else if (choice == 'widget') {
      await _applyWidgetBackground(path);
    }
  }

  /// 设为课表背景（未开启自定义背景会自动开启）
  static Future<void> _applyCourseBackground(String sourcePath) async {
    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String target = '${dir.path}/courseBackground_shared.jpg';
      await File(sourcePath).copy(target);
      //关闭其它背景来源，启用本地图片背景
      await ShareDateUtil().setIsRandomQuadraticBackground(false);
      await ShareDateUtil().setIsUrlBackground(false);
      await ShareDateUtil().setCourseBackgroundFilePath(target);
      await ShareDateUtil().setIsCustomerLocalBackground(true);
      //如果没开启"纯白背景/图片背景"则自动开启
      await ShareDateUtil().setIsPictureBackground(true);
      Get.snackbar('设置成功', '已设为课表背景图',
          duration: const Duration(milliseconds: 1500));
    } catch (e) {
      print('设置课表背景失败: $e');
      Get.snackbar('设置失败', '图片设置失败，请重试',
          duration: const Duration(milliseconds: 1500));
    }
  }

  /// 设为桌面课表小组件背景（未开启自定义背景会自动开启）
  static Future<void> _applyWidgetBackground(String sourcePath) async {
    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String target = '${dir.path}/courseWidgetBackground_shared.jpg';
      await File(sourcePath).copy(target);
      //关闭其它背景来源，启用本地图片背景
      await ShareDateUtil().setIsCourseWidgetRandomQuadraticBackground(false);
      await ShareDateUtil().setIsCourseWidgetUrlBackground(false);
      await ShareDateUtil().setCourseWidgetBackgroundFilePath(target);
      await ShareDateUtil().setIsCourseWidgetLocalBackground(true);
      //如果没开启"课表小组件自定义背景"则自动开启
      await ShareDateUtil().setIsCourseWidgetCustomBackground(true);
      Get.snackbar('设置成功', '已设为桌面小组件背景',
          duration: const Duration(milliseconds: 1500));
    } catch (e) {
      print('设置小组件背景失败: $e');
      Get.snackbar('设置失败', '图片设置失败，请重试',
          duration: const Duration(milliseconds: 1500));
    }
  }
}
