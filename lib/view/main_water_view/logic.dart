

import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:math' hide log;

import 'package:callo/dao/entity/WaterFavoriteEntity.dart';
import 'package:callo/utils/WaterFavoriteUtil.dart';
import 'package:callo/view/router/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:callo/dao/WaterData.dart';
import 'package:callo/utils/FileUtils.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/LocationInfoUtil.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:callo/utils/WaterUtil.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

import 'state.dart';
class MainWaterViewLogic extends GetxController {
  final MainWaterViewState state = MainWaterViewState();
  BuildContext? context=null;

  //收藏功能
  final scaffoldKey = GlobalKey<ScaffoldState>(); //用于打开右侧收藏抽屉
  final favorites = <WaterFavoriteEntity>[].obs; //收藏的饮水机列表
  final favoritesLoading = false.obs;
  final isEndDrawerOpen = false.obs; //右侧收藏抽屉是否展开（用于拦截物理返回键）

  /// 读取收藏列表（按 校区/栋数/楼层 排序）
  Future<void> loadFavorites() async {
    try {
      favoritesLoading.value = true;
      favorites.value = await WaterFavoriteUtil.loadAll();
    } catch (e) {
      log('读取饮水机收藏失败: $e');
    } finally {
      favoritesLoading.value = false;
    }
  }

  /// 打开右侧收藏抽屉
  void openFavoriteDrawer() {
    loadFavorites();
    scaffoldKey.currentState?.openEndDrawer();
  }

  /// 检查收藏所需的扫描权限（定位服务 + 位置/附近WiFi权限）：
  /// 未授权时触发系统权限申请；被拒绝则弹窗引导去设置手动开启，
  /// 返回 true 表示权限已就绪、可以继续收藏
  Future<bool> ensureScanPermissionForFavorite() async {
    //1.定位服务未开启
    if (!await Geolocator.isLocationServiceEnabled()) {
      final bool? go = await showPermissionDialog(
        title: '需要开启定位服务',
        content:
            '收藏饮水机需要扫描周边的WiFi/AP信息：\n\n收藏时会记录该饮水机周边的AP，配合「自动探测」功能，'
                '当你走到附近时就能自动绑定离你最近的饮水机。\n\n请先开启手机「定位服务」后再收藏。',
        confirmText: '去开启',
      );
      if (go == true) await Geolocator.openLocationSettings();
      return false;
    }
    //2.位置权限（扫描WiFi/AP必须）
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //未授权：触发系统权限申请弹窗
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final bool? go = await showPermissionDialog(
        title: '需要位置/附近WiFi权限',
        content:
            '收藏饮水机需要扫描周边的WiFi/AP信息：\n\n收藏时会记录该饮水机周边的AP，配合「自动探测」功能，'
                '当你走到附近时就能自动绑定离你最近的饮水机。\n\n你已拒绝授权，请到「设置 → 权限」中手动允许本应用的'
                '位置权限（附近设备/WiFi）后再收藏。',
        confirmText: '去设置',
      );
      if (go == true) await Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  /// 权限说明弹窗（返回 true 表示用户点了我确认去开启/去设置）
  Future<bool?> showPermissionDialog({
    required String title,
    required String content,
    String confirmText = '去设置',
  }) {
    return showDialog<bool>(
        context: context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (dialogContext) {
          final Color text = GlassTheme.textColor('main_water_view');
          return MediaQuery(
              data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 28),
                child: GlassCard(
                  page: 'main_water_view',
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassSectionTitle(
                          page: 'main_water_view', title: title),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: TextStyle(
                            fontSize: 12.5,
                            height: 1.6,
                            color: text.withValues(alpha: .8)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              text: '取消',
                              page: 'main_water_view',
                              height: 44,
                              colors: [
                                text.withValues(alpha: .35),
                                text.withValues(alpha: .22)
                              ],
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GradientButton(
                              text: confirmText,
                              page: 'main_water_view',
                              height: 44,
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '未授予权限将无法收藏饮水机',
                        style: TextStyle(
                            fontSize: 11, color: text.withValues(alpha: .5)),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  /// 收藏当前绑定的饮水机（弹窗填写 校区/栋数/楼层）
  Future<void> favoriteCurrent() async {
    if (WaterData.hotWater.value.isEmpty &&
        WaterData.coolWater.value.isEmpty) {
      ToastUtil.show('请先绑定饮水机后再收藏');
      return;
    }
    //收藏前先检查扫描周边AP所需的权限，未授权则无法收藏
    if (!await ensureScanPermissionForFavorite()) return;
    //用最近一次收藏的信息作为默认值
    final WaterFavoriteEntity? last =
        favorites.isNotEmpty ? favorites.last : null;
    final TextEditingController campusController =
        TextEditingController(text: last?.campus ?? "");
    final TextEditingController buildingController =
        TextEditingController(text: last?.building ?? "");
    final TextEditingController floorController =
        TextEditingController(text: last?.floor ?? "");
    final bool? confirm = await showDialog<bool>(
        context: context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (dialogContext) {
          final Color text = GlassTheme.textColor('main_water_view');
          final Color accent = GlassTheme.accentColor('main_water_view');
          //校区/栋数/楼层均为必填项，校验不通过时在输入框下方提示
          String? campusError;
          String? buildingError;
          String? floorError;
          return StatefulBuilder(
              builder: (stateContext, setDialogState) => MediaQuery(
                  data: MediaQuery.of(Get.context!)
                      .copyWith(textScaleFactor: 1.0),
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 28),
                    child: GlassCard(
                      page: 'main_water_view',
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassSectionTitle(
                              page: 'main_water_view', title: '收藏饮水机'),
                          const SizedBox(height: 4),
                          Text(
                            '校区/栋数/楼层为必填项，确认时会扫描周边AP用于定位该饮水机',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: text.withValues(alpha: .6)),
                          ),
                          const SizedBox(height: 12),
                          _favField('校区 *', '如：屏风校区', campusController,
                              text, accent,
                              errorText: campusError,
                              onChanged: (v) {
                            if (campusError != null && v.trim().isNotEmpty) {
                              setDialogState(() => campusError = null);
                            }
                          }),
                          const SizedBox(height: 10),
                          _favField('栋数 *', '如：3栋', buildingController, text,
                              accent,
                              errorText: buildingError,
                              onChanged: (v) {
                            if (buildingError != null && v.trim().isNotEmpty) {
                              setDialogState(() => buildingError = null);
                            }
                          }),
                          const SizedBox(height: 10),
                          _favField('楼层 *', '如：3楼', floorController, text,
                              accent,
                              errorText: floorError,
                              onChanged: (v) {
                            if (floorError != null && v.trim().isNotEmpty) {
                              setDialogState(() => floorError = null);
                            }
                          }),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  text: '取消',
                                  page: 'main_water_view',
                                  height: 44,
                                  colors: [
                                    text.withValues(alpha: .35),
                                    text.withValues(alpha: .22)
                                  ],
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GradientButton(
                                  text: '确认收藏',
                                  page: 'main_water_view',
                                  height: 44,
                                  onPressed: () {
                                    final String campus =
                                        campusController.text.trim();
                                    final String building =
                                        buildingController.text.trim();
                                    final String floor =
                                        floorController.text.trim();
                                    setDialogState(() {
                                      campusError = campus.isEmpty
                                          ? '请输入校区（必填）'
                                          : null;
                                      buildingError = building.isEmpty
                                          ? '请输入栋数（必填）'
                                          : null;
                                      floorError = floor.isEmpty
                                          ? '请输入楼层（必填）'
                                          : null;
                                    });
                                    //必填项未填写完整时不关闭弹窗
                                    if (campus.isEmpty ||
                                        building.isEmpty ||
                                        floor.isEmpty) {
                                      return;
                                    }
                                    Navigator.pop(dialogContext, true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
        });
    if (confirm != true) {
      campusController.dispose();
      buildingController.dispose();
      floorController.dispose();
      return;
    }
    ToastUtil.show('正在扫描周边AP并收藏...');
    final String? error = await WaterFavoriteUtil.addCurrent(
      campus: campusController.text,
      building: buildingController.text,
      floor: floorController.text,
    );
    campusController.dispose();
    buildingController.dispose();
    floorController.dispose();
    if (error != null) {
      ToastUtil.show(error);
      return;
    }
    ToastUtil.show('收藏成功');
    await loadFavorites();
  }

  Widget _favField(String label, String hint, TextEditingController controller,
      Color text, Color accent,
      {String? errorText, ValueChanged<String>? onChanged}) {
    final Color error = GlassTheme.scheme.error;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: text, fontSize: 13.5),
      decoration: InputDecoration(
        labelText: label,
        //必填项未填写时的错误提示
        errorText: errorText,
        errorStyle: TextStyle(fontSize: 11, color: error),
        labelStyle: TextStyle(color: text.withValues(alpha: .6)),
        hintText: hint,
        hintStyle: TextStyle(color: text.withValues(alpha: .35)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: text.withValues(alpha: .18))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accent, width: 1.4)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: error, width: 1.4)),
      ),
    );
  }

  /// 编辑收藏（名称/校区/栋数/楼层）
  Future<void> editFavorite(WaterFavoriteEntity entity) async {
    final TextEditingController labelController =
        TextEditingController(text: entity.label);
    final TextEditingController campusController =
        TextEditingController(text: entity.campus);
    final TextEditingController buildingController =
        TextEditingController(text: entity.building);
    final TextEditingController floorController =
        TextEditingController(text: entity.floor);
    String? campusError;
    String? buildingError;
    String? floorError;
    final bool? confirm = await showDialog<bool>(
        context: context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (dialogContext) {
          final Color text = GlassTheme.textColor('main_water_view');
          final Color accent = GlassTheme.accentColor('main_water_view');
          return StatefulBuilder(
              builder: (stateContext, setDialogState) => MediaQuery(
                  data: MediaQuery.of(Get.context!)
                      .copyWith(textScaleFactor: 1.0),
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 28),
                    child: GlassCard(
                      page: 'main_water_view',
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassSectionTitle(
                              page: 'main_water_view', title: '编辑收藏'),
                          const SizedBox(height: 4),
                          Text(
                            '名称留空时会根据设备自动命名',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: text.withValues(alpha: .6)),
                          ),
                          const SizedBox(height: 12),
                          _favField('名称', entity.label, labelController, text,
                              accent),
                          const SizedBox(height: 10),
                          _favField('校区 *', '如：屏风校区', campusController,
                              text, accent,
                              errorText: campusError,
                              onChanged: (v) {
                            if (campusError != null && v.trim().isNotEmpty) {
                              setDialogState(() => campusError = null);
                            }
                          }),
                          const SizedBox(height: 10),
                          _favField('栋数 *', '如：3栋', buildingController, text,
                              accent,
                              errorText: buildingError,
                              onChanged: (v) {
                            if (buildingError != null && v.trim().isNotEmpty) {
                              setDialogState(() => buildingError = null);
                            }
                          }),
                          const SizedBox(height: 10),
                          _favField('楼层 *', '如：3楼', floorController, text,
                              accent,
                              errorText: floorError,
                              onChanged: (v) {
                            if (floorError != null && v.trim().isNotEmpty) {
                              setDialogState(() => floorError = null);
                            }
                          }),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  text: '取消',
                                  page: 'main_water_view',
                                  height: 44,
                                  colors: [
                                    text.withValues(alpha: .35),
                                    text.withValues(alpha: .22)
                                  ],
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GradientButton(
                                  text: '保存',
                                  page: 'main_water_view',
                                  height: 44,
                                  onPressed: () {
                                    final String campus =
                                        campusController.text.trim();
                                    final String building =
                                        buildingController.text.trim();
                                    final String floor =
                                        floorController.text.trim();
                                    setDialogState(() {
                                      campusError = campus.isEmpty
                                          ? '请输入校区（必填）'
                                          : null;
                                      buildingError = building.isEmpty
                                          ? '请输入栋数（必填）'
                                          : null;
                                      floorError = floor.isEmpty
                                          ? '请输入楼层（必填）'
                                          : null;
                                    });
                                    if (campus.isEmpty ||
                                        building.isEmpty ||
                                        floor.isEmpty) {
                                      return;
                                    }
                                    Navigator.pop(dialogContext, true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
        });
    if (confirm != true) {
      labelController.dispose();
      campusController.dispose();
      buildingController.dispose();
      floorController.dispose();
      return;
    }
    await WaterFavoriteUtil.edit(
      entity,
      campus: campusController.text,
      building: buildingController.text,
      floor: floorController.text,
      label: labelController.text,
    );
    labelController.dispose();
    campusController.dispose();
    buildingController.dispose();
    floorController.dispose();
    ToastUtil.show('已保存');
    await loadFavorites();
  }

  /// 重命名分类（校区/栋数/楼层）
  Future<void> renameCategoryDialog(String level, String oldName,
      {String? campus, String? building}) async {
    final String levelName =
        level == 'campus' ? '校区' : (level == 'building' ? '栋数' : '楼层');
    final TextEditingController controller =
        TextEditingController(text: oldName);
    String? error;
    final bool? confirm = await showDialog<bool>(
        context: context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (dialogContext) {
          final Color text = GlassTheme.textColor('main_water_view');
          final Color accent = GlassTheme.accentColor('main_water_view');
          return StatefulBuilder(
              builder: (stateContext, setDialogState) => MediaQuery(
                  data: MediaQuery.of(Get.context!)
                      .copyWith(textScaleFactor: 1.0),
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 28),
                    child: GlassCard(
                      page: 'main_water_view',
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassSectionTitle(
                              page: 'main_water_view',
                              title: '重命名$levelName'),
                          const SizedBox(height: 4),
                          Text(
                            '该分类下的所有收藏都会一起改名',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: text.withValues(alpha: .6)),
                          ),
                          const SizedBox(height: 12),
                          _favField('$levelName *', oldName, controller, text,
                              accent,
                              errorText: error,
                              onChanged: (v) {
                            if (error != null && v.trim().isNotEmpty) {
                              setDialogState(() => error = null);
                            }
                          }),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  text: '取消',
                                  page: 'main_water_view',
                                  height: 44,
                                  colors: [
                                    text.withValues(alpha: .35),
                                    text.withValues(alpha: .22)
                                  ],
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GradientButton(
                                  text: '保存',
                                  page: 'main_water_view',
                                  height: 44,
                                  onPressed: () {
                                    if (controller.text.trim().isEmpty) {
                                      setDialogState(
                                          () => error = '请输入名称（必填）');
                                      return;
                                    }
                                    Navigator.pop(dialogContext, true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
        });
    if (confirm != true) {
      controller.dispose();
      return;
    }
    await WaterFavoriteUtil.renameCategory(
      level: level,
      oldName: oldName,
      newName: controller.text,
      campus: campus,
      building: building,
    );
    controller.dispose();
    ToastUtil.show('已重命名');
    await loadFavorites();
  }

  /// 删除分类：分类下有子数据（收藏）时不允许删除，提示先删除子数据
  Future<void> deleteCategory(String level, String name,
      {String? campus, String? building}) async {
    final int count = await WaterFavoriteUtil.countCategory(
        level: level, name: name, campus: campus, building: building);
    if (count > 0) {
      await showTipDialog(
        title: '无法删除分类',
        content:
            '「$name」下还有 $count 条收藏，请先删除该分类下的子数据后再删除分类。',
      );
      return;
    }
    //分类由收藏数据生成，没有子数据时分类本身已经不存在了
    ToastUtil.show('该分类下已没有数据');
  }

  /// 通用提示弹窗（单个「知道了」按钮）
  Future<void> showTipDialog(
      {required String title, required String content}) {
    return showDialog(
        context: context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (dialogContext) {
          final Color text = GlassTheme.textColor('main_water_view');
          return MediaQuery(
              data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 28),
                child: GlassCard(
                  page: 'main_water_view',
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassSectionTitle(
                          page: 'main_water_view', title: title),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: TextStyle(
                            fontSize: 12.5,
                            height: 1.6,
                            color: text.withValues(alpha: .8)),
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        text: '知道了',
                        page: 'main_water_view',
                        height: 44,
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  /// 正在拖动的收藏（拖动时显示可放置区域）
  final draggingFavorite = Rx<WaterFavoriteEntity?>(null);

  /// 侧滑栏中被收起的分类
  /// key：campus:校区 / building:校区|栋数 / floor:校区|栋数|楼层
  final collapsedCategories = <String>[].obs;

  /// 分类是否已收起（读取 value 以建立响应式依赖）
  bool isCategoryCollapsed(String key) =>
      collapsedCategories.value.contains(key);

  /// 展开/收起分类
  void toggleCategory(String key) {
    if (collapsedCategories.contains(key)) {
      collapsedCategories.remove(key);
    } else {
      collapsedCategories.add(key);
    }
  }

  /// 把收藏拖动到其他分类（可跨校区/栋数/楼层）
  /// [before] 不为空时插到该条目前面，否则放到目标分组最后
  Future<void> moveFavoriteToGroup(WaterFavoriteEntity item,
      {required String campus,
      required String building,
      required String floor,
      WaterFavoriteEntity? before}) async {
    if (before != null && before.id == item.id) return;
    final bool groupChanged = item.campus != campus ||
        item.building != building ||
        item.floor != floor;
    if (!groupChanged && before == null) return; //没有变化
    //移动后展开目标分类，方便直接看到结果
    for (final String key in [
      'campus:$campus',
      'building:$campus|$building',
      'floor:$campus|$building|$floor'
    ]) {
      if (collapsedCategories.contains(key)) collapsedCategories.remove(key);
    }
    await WaterFavoriteUtil.moveTo(
        item: item,
        campus: campus,
        building: building,
        floor: floor,
        before: before);
    if (groupChanged) {
      ToastUtil.show('已移动到 $campus $building $floor');
    }
    await loadFavorites();
  }

  /// 上下移动一条收藏
  Future<void> moveFavorite(WaterFavoriteEntity entity, int direction) async {
    final bool ok = await WaterFavoriteUtil.moveItem(entity, direction);
    if (!ok) {
      ToastUtil.show(direction < 0 ? '已经是最前面了' : '已经是最后面了');
      return;
    }
    await loadFavorites();
  }

  /// 上下移动一个分类
  Future<void> moveCategory(String level, String name,
      {String? campus, String? building, required int direction}) async {
    final bool ok = await WaterFavoriteUtil.moveCategory(
      level: level,
      name: name,
      campus: campus,
      building: building,
      direction: direction,
    );
    if (!ok) {
      ToastUtil.show(direction < 0 ? '已经是最前面了' : '已经是最后面了');
      return;
    }
    await loadFavorites();
  }

  /// 使用收藏的饮水机（设为当前绑定）
  Future<void> applyFavorite(WaterFavoriteEntity entity) async {
    await WaterFavoriteUtil.apply(entity);
    ToastUtil.show(
        '已绑定：${entity.campus} ${entity.building} ${entity.floor} ${entity.label}');
  }

  /// 删除一条收藏（带确认）
  Future<void> deleteFavorite(WaterFavoriteEntity entity) async {
    final bool? confirm = await showDialog<bool>(
        context: context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (dialogContext) {
          final Color text = GlassTheme.textColor('main_water_view');
          return MediaQuery(
              data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                child: GlassCard(
                  page: 'main_water_view',
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassSectionTitle(
                          page: 'main_water_view', title: '删除收藏'),
                      const SizedBox(height: 6),
                      Text(
                        '确定删除「${entity.campus} ${entity.building} ${entity.floor} ${entity.label}」这条收藏吗？',
                        style: TextStyle(
                            fontSize: 13, color: text.withValues(alpha: .8)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              text: '取消',
                              page: 'main_water_view',
                              height: 42,
                              colors: [
                                text.withValues(alpha: .35),
                                text.withValues(alpha: .22)
                              ],
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GradientButton(
                              text: '删除',
                              page: 'main_water_view',
                              height: 42,
                              colors: const [
                                Color(0xFFE53935),
                                Color(0xFFEF5350)
                              ],
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
    if (confirm != true) return;
    await WaterFavoriteUtil.remove(entity);
    ToastUtil.show('已删除');
    await loadFavorites();
  }

  /// 导出收藏为JSON并分享
  Future<void> exportFavorites() async {
    final String? error = await WaterFavoriteUtil.exportAndShare();
    if (error != null) ToastUtil.show(error);
  }

  /// 从JSON文件导入收藏
  Future<void> importFavorites() async {
    final String message = await WaterFavoriteUtil.importFromFile();
    if (message.isEmpty) return; //用户取消了选择
    ToastUtil.show(message);
    await loadFavorites();
  }


  updateMessage({money,divice}){
    state.money.value=money??"";
    state.divice.value = divice??"";
  }


  Future<void> onRefresh() async {
    await WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
      //刷新信息
      updateMessage(money: value);
    });

  }





  //绑定显示
  bingShow() {
    String _url = "";

    showDialog(
        useRootNavigator: false,
        context: context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (builder) {
          final Color text = GlassTheme.textColor('main_water_view');
          final Color accent = GlassTheme.accentColor('main_water_view');
          return MediaQuery(
              data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                child: GlassCard(
                  page: 'main_water_view',
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassSectionTitle(
                          page: 'main_water_view', title: '绑定打水账号'),
                      const SizedBox(height: 6),
                      Text(
                        '请输入微信扫码后的链接',
                        style: TextStyle(
                            fontSize: 12,
                            color: text.withValues(alpha: .6)),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        style: TextStyle(color: text, fontSize: 13.5),
                        decoration: InputDecoration(
                          labelText: '链接',
                          labelStyle: TextStyle(
                              color: text.withValues(alpha: .6)),
                          hintText: '请输入链接',
                          hintStyle: TextStyle(
                              color: text.withValues(alpha: .35)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: text.withValues(alpha: .18))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: accent, width: 1.4)),
                        ),
                        onChanged: (v) {
                          _url = v;
                        },
                      ),
                      const SizedBox(height: 14),
                      GradientButton(
                        text: '绑定',
                        page: 'main_water_view',
                        height: 44,
                        onPressed: () {
                          Get.snackbar("提示", "正在绑定,请稍后.....",
                              duration: const Duration(milliseconds: 1500));
                          WaterUtil().bindAccount(_url).then((value) {
                            if (value != "") {
                              state.bingCard.value = WaterData.cardNum.value;
                              Get.snackbar("提示", "绑定成功",
                                  duration:
                                      const Duration(milliseconds: 1500));
                              Navigator.pop(builder);
                              //更新数据
                              WaterUtil()
                                  .getMenoy(WaterData.waterAccount.value,
                                      WaterData.waterSaler.value)
                                  .then((value) {
                                updateMessage(money: value);
                              });
                            } else {
                              Get.snackbar("提示", "输入的链接有误",
                                  duration:
                                      const Duration(milliseconds: 1500));
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              text: '查看教程',
                              page: 'main_water_view',
                              height: 42,
                              colors: const [
                                Color(0xFF546E7A),
                                Color(0xFF90A4AE)
                              ],
                              onPressed: () {
                                Navigator.pop(builder!);
                                Get.toNamed(Routes.WaterHelp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GradientButton(
                              text: '取消',
                              page: 'main_water_view',
                              height: 42,
                              colors: [
                                text.withValues(alpha: .35),
                                text.withValues(alpha: .22)
                              ],
                              onPressed: () {
                                Navigator.pop(builder!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  //用于冷水关闭
  coolCloseWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.coolWater.isNotEmpty) {
        WaterUtil().closeWater(WaterData.coolWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
          //用于刷新金额
          Timer(Duration(seconds: 1),(){
            WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
              //刷新信息
              updateMessage(money: value);
            });
          });

        });
      }
      else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }




  //用于热水打卡
  hotOpenWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.hotWater.isNotEmpty) {
        WaterUtil().openWater(WaterData.hotWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
        });
      }else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }




  //用于热水关闭
  hotCloseWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.hotWater.isNotEmpty) {
        WaterUtil().closeWater(WaterData.hotWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          // Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
          ToastUtil.show('${value['message']}');
          //用于刷新金额
          Timer(Duration(seconds: 1),(){
            WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
              //刷新信息
              updateMessage(money: value);
            });
          });


        });

      }
      else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }



  //用于冷水打卡
  coolOpenWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.coolWater.isNotEmpty) {
        WaterUtil().openWater(WaterData.coolWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          // Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
          ToastUtil.show('${value['message']}');
        });

      }
      else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }


  /// 位置服务
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      /// 手机GPS服务是否已启用。
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        //定位服务未启用，要求用户启用定位服务
        var res = await Geolocator.openLocationSettings();
        if (!res) {
          /// 被拒绝
          return;
        }
      }
      /// 是否允许app访问地理位置
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        /// 之前访问设备位置的权限被拒绝，重新申请权限
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          // ToastUtil.show('饮水机探测需要您的定位权限才能定位周围饮水机否则无法正常使用');
          Get.snackbar("提示", "自动探测功能需要获取你当前位置和周围设备的信息才能知道，若拒绝权限申请将无法正常使用此功能。",
              duration: Duration(milliseconds: 5000));
          /// 再次被拒绝。根据Android指南，你的应用现在应该显示一个解释性UI。
          return;
        }
      } else if (permission == LocationPermission.deniedForever) {
        Get.snackbar("提示", "请到“设置->权限”授予本软件位置定位权限",
            duration: Duration(milliseconds: 2000));
        /// 之前权限被永久拒绝，打开app权限设置页面
        // await Geolocator.openAppSettings();
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  //根据气压计算海拔高度
  calculateAltitude(double pressure){
    final double P0 = 1013.25; //海平面标准气压
    final double R = 287.05; //气体常数
    final double T0= 288.15; //海平面温度
    final double g = 9.80665; //重力加速度
    return (P0-pressure)*R*T0/(g*P0);
  }

  void test()async{


    Timer.periodic(Duration(seconds: 2), (timer) async{

      var locationInfo =await LocationInfoUtil.getLocationInfo();
      state.longitude.value = locationInfo['longitude'];
      state.latitude.value = locationInfo['latitude'];
      state.altitude.value = locationInfo['altitude'];
      state.sensor.value = locationInfo['sensor'];
      state.sensorAltitude1.value = calculateAltitude(state.sensor.value);
      state.sensorAltitude2.value = 44330000*(1.0-(pow(state.sensor.value/1013.25, 1.0/5255.0)));
    });
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 获取最强信号的前4个AP的MAC地址
   * [date] 20:33 2024/9/19
   * [param] null
   * [return]
   */
  getAPTopList() async{

    await _determinePosition();
      // setState(() => huntButtonColor = Colors.red);
    var wiFiHunterResult = WiFiHunterResult();
      try {
        wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
      } on PlatformException catch (exception) {
        ToastUtil.show('您点击定位过于频繁（限制两分钟4次定位频率）');
        print(exception.toString());
      }
      List result = [];
      for (int i = 0; i < wiFiHunterResult.results.length; i++) {
        if(wiFiHunterResult.results[i].frequency<5000) continue; //过滤频率低于5KHZ的
        if(wiFiHunterResult.results[i].ssid!="NNLGXY") continue; //过滤非NNLGXY名称的AP
          result.add({
            "SSID": wiFiHunterResult.results[i].ssid, //AP名称
            "Level": wiFiHunterResult.results[i].level, //信号强度
            "BSSID": wiFiHunterResult.results[i].bssid, //MAC地址
            "Capabilities": wiFiHunterResult.results[i].capabilities, //不懂啥玩意
            "Frequency": wiFiHunterResult.results[i].frequency.toString(), //频率
            "Channel Width": wiFiHunterResult.results[i].channelWidth.toString(), //信道
            "Timestamp": wiFiHunterResult.results[i].timestamp.toString() //时间
          });
      }
      result.sort((a,b)=>b["Level"].compareTo(a["Level"])); //根据信号强度排序
    return result;
  }

  /**
   * [title] 通过AP探测对应饮水机位置
   * [description] 先用扫描到的AP匹配内置饮水机列表(localWaterList.json)，
   * 没有匹配到再继续匹配用户收藏的饮水机（收藏时保存的周边AP），
   * 匹配到收藏的饮水机会自动切换绑定到对应的饮水机
   * [return] 匹配结果：{label, hotDeviceId, coldDeviceId, fromFavorite, favorite}
   */
  Future<Map<String, dynamic>?> detectWater() async {
    List resultAp = await getAPTopList(); //获取AP列表，以信号强度排序
    if (resultAp.isEmpty) return null;

    //1.先匹配内置饮水机列表
    final dynamic localInformList = jsonDecode(
        (await FileUtils.loadJsonFromAssets('assets/files/localWaterList.json')));
    int maxComp = 0;
    int index = -1; //最大匹配AP数量，匹配编号
    for (int i = 0; i < localInformList.length; ++i) {
      final int resCompNum = countApMatch(
          resultAp, List<String>.from(localInformList[i]['ap'] ?? []));
      if (maxComp < resCompNum) {
        maxComp = resCompNum;
        index = i;
      }
    }
    if (index != -1) {
      final Map entry = localInformList[index];
      return {
        'label': '${entry['inform']?['label'] ?? ''}',
        'hotDeviceId': '${entry['hotDeviceId'] ?? ''}',
        'coldDeviceId': '${entry['coldDeviceId'] ?? ''}',
        'fromFavorite': false,
        'favorite': null,
      };
    }

    //2.内置列表没有匹配到：继续匹配收藏的饮水机
    final List<WaterFavoriteEntity> favorites = await WaterFavoriteUtil.loadAll();
    WaterFavoriteEntity? matched;
    int favoriteMaxComp = 0;
    for (final WaterFavoriteEntity favorite in favorites) {
      //没有绑定设备的收藏无法用于自动绑定
      if (favorite.hotDeviceId.isEmpty && favorite.coldDeviceId.isEmpty) {
        continue;
      }
      final List<String> bssids = favoriteBssids(favorite);
      //没有记录AP（AP数为0）的收藏无法参与匹配
      if (bssids.isEmpty) continue;
      final int comp = countApMatch(resultAp, bssids);
      if (favoriteMaxComp < comp) {
        favoriteMaxComp = comp;
        matched = favorite;
      }
    }
    if (matched == null || favoriteMaxComp == 0) return null;
    return {
      'label':
          '${matched.campus} ${matched.building} ${matched.floor} ${matched.label}',
      'hotDeviceId': matched.hotDeviceId,
      'coldDeviceId': matched.coldDeviceId,
      'fromFavorite': true,
      'favorite': matched,
    };
  }

  /// 统计扫描到的AP与目标BSSID列表相同的数量
  int countApMatch(List resultAp, List<String> bssids) {
    if (bssids.isEmpty) return 0;
    int count = 0;
    for (int j = 0; j < resultAp.length; ++j) {
      for (int z = 0; z < bssids.length; ++z) {
        if (resultAp[j]['BSSID'] == bssids[z]) ++count;
      }
    }
    return count;
  }

  /// 从收藏保存的AP JSON里取出BSSID列表
  List<String> favoriteBssids(WaterFavoriteEntity favorite) {
    try {
      final dynamic value = jsonDecode(favorite.apJson);
      if (value is! List) return [];
      final List<String> result = [];
      for (final dynamic item in value) {
        if (item is String) {
          result.add(item);
        } else if (item is Map && item['BSSID'] != null) {
          result.add('${item['BSSID']}');
        }
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  @override
  void onInit() {
    // ShareDateUtil().getTestList();
    // _determinePosition();
    // test();


    WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
        state.money.value = value;
    });
    if(WaterData.cardNum.isNotEmpty&& WaterData.cardNum!=null)
      state.bingCard.value = WaterData.cardNum.value;
    //读取收藏的饮水机列表
    loadFavorites();
  }
}
