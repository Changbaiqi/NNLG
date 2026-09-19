/* FileName WaterFavoriteUtil
 *
 * @Description 饮水机收藏：
 * 收藏当前绑定饮水机（同时扫描周边AP）、读取列表、
 * 导出JSON文件分享、从JSON文件导入
 */
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

import 'package:callo/dao/WaterData.dart';
import 'package:callo/dao/WaterFavoriteDao.dart';
import 'package:callo/dao/entity/WaterFavoriteEntity.dart';
import 'package:callo/utils/ShareDateUtil.dart';

class WaterFavoriteUtil {
  static WaterFavoriteDao get _dao => GetIt.I<WaterFavoriteDao>();

  /// 读取全部收藏（已按 校区/栋数/楼层 排序）
  static Future<List<WaterFavoriteEntity>> loadAll() async {
    return await _dao.findAll();
  }

  /// 收藏当前绑定的饮水机
  /// [campus][building][floor]：手动填写的分类
  /// 返回 null 表示成功，否则返回错误提示
  static Future<String?> addCurrent({
    required String campus,
    required String building,
    required String floor,
  }) async {
    //校区/栋数/楼层均为必填项（再兜底校验一次）
    if (campus.trim().isEmpty ||
        building.trim().isEmpty ||
        floor.trim().isEmpty) {
      return '校区/栋数/楼层均为必填项';
    }
    final String hot = WaterData.hotWater.value;
    final String cold = WaterData.coolWater.value;
    if (hot.isEmpty && cold.isEmpty) {
      return '请先绑定饮水机后再收藏';
    }
    //扫描周边AP：优先周边 NNLGXY 的AP，没有则取信号最强的前50个
    final Map<String, dynamic> scan = await scanAroundAps();
    final List aps = scan['aps'] as List;
    final WaterFavoriteEntity? exists = await _dao.findByDevice(hot, cold);
    //新收藏排在最后面
    final List<WaterFavoriteEntity> all = await loadAll();
    int maxOrder = 0;
    for (final WaterFavoriteEntity item in all) {
      if (item.sortOrder > maxOrder) maxOrder = item.sortOrder;
    }
    final WaterFavoriteEntity entity = WaterFavoriteEntity(
      id: exists?.id,
      campus: campus.trim(),
      building: building.trim(),
      floor: floor.trim(),
      label: buildLabel(hot, cold),
      hotDeviceId: hot,
      coldDeviceId: cold,
      apSource: '${scan['source']}',
      apJson: jsonEncode(aps),
      createdAt: DateTime.now(),
      sortOrder: exists?.sortOrder ?? maxOrder + 1,
    );
    if (exists?.id != null) {
      //同一台饮水机重复收藏时更新分类与AP
      await _dao.updateFavorite(entity);
    } else {
      await _dao.insertFavorite(entity);
    }
    return null;
  }

  /// 编辑一条收藏的名称/分类（设备信息、AP、排序保持不变）
  static Future<void> edit(
    WaterFavoriteEntity old, {
    required String campus,
    required String building,
    required String floor,
    required String label,
  }) async {
    await _dao.updateFavorite(old.copyWith(
      campus: campus.trim(),
      building: building.trim(),
      floor: floor.trim(),
      label: label.trim().isEmpty ? buildLabel(old.hotDeviceId, old.coldDeviceId) : label.trim(),
    ));
  }

  /// 重命名一个分类：
  /// [level] campus/building/floor，[campus]/[building] 为该分类的上级定位
  static Future<void> renameCategory({
    required String level,
    required String oldName,
    required String newName,
    String? campus,
    String? building,
  }) async {
    final String name = newName.trim();
    if (name.isEmpty || name == oldName) return;
    final List<WaterFavoriteEntity> list = await loadAll();
    final List<WaterFavoriteEntity> changed = <WaterFavoriteEntity>[];
    for (final WaterFavoriteEntity e in list) {
      bool match = false;
      if (level == 'campus') {
        match = e.campus == oldName;
      } else if (level == 'building') {
        match = e.campus == campus && e.building == oldName;
      } else {
        match =
            e.campus == campus && e.building == building && e.floor == oldName;
      }
      if (!match) continue;
      changed.add(e.copyWith(
        campus: level == 'campus' ? name : null,
        building: level == 'building' ? name : null,
        floor: level == 'floor' ? name : null,
      ));
    }
    if (changed.isEmpty) return;
    await _dao.updateFavorites(changed);
  }

  /// 统计某分类下的收藏数量（删除分类前的子数据检查）
  static Future<int> countCategory({
    required String level,
    required String name,
    String? campus,
    String? building,
  }) async {
    final List<WaterFavoriteEntity> list = await loadAll();
    int count = 0;
    for (final WaterFavoriteEntity e in list) {
      bool match = false;
      if (level == 'campus') {
        match = e.campus == name;
      } else if (level == 'building') {
        match = e.campus == campus && e.building == name;
      } else {
        match =
            e.campus == campus && e.building == building && e.floor == name;
      }
      if (match) ++count;
    }
    return count;
  }

  /// 按显示顺序排序（sortOrder 小的在前，相同按 id）
  static List<WaterFavoriteEntity> sortForDisplay(
      List<WaterFavoriteEntity> list) {
    final List<WaterFavoriteEntity> result = List.of(list);
    result.sort((a, b) {
      final int compare = a.sortOrder.compareTo(b.sortOrder);
      if (compare != 0) return compare;
      return (a.id ?? 0).compareTo(b.id ?? 0);
    });
    return result;
  }

  /// 按给定的顺序重新编号保存
  static Future<void> saveOrder(List<WaterFavoriteEntity> ordered) async {
    final List<WaterFavoriteEntity> changed = <WaterFavoriteEntity>[];
    for (int i = 0; i < ordered.length; ++i) {
      if (ordered[i].sortOrder == i) continue;
      changed.add(ordered[i].copyWith(sortOrder: i));
    }
    if (changed.isNotEmpty) await _dao.updateFavorites(changed);
  }

  /// 同分组（同校区/栋/楼层）内上下移动一条收藏
  /// [direction] -1 上移，1 下移；返回是否移动成功
  static Future<bool> moveItem(WaterFavoriteEntity item, int direction) async {
    final List<WaterFavoriteEntity> ordered = sortForDisplay(await loadAll());
    final List<int> indexes = <int>[];
    for (int i = 0; i < ordered.length; ++i) {
      final WaterFavoriteEntity e = ordered[i];
      if (e.campus == item.campus &&
          e.building == item.building &&
          e.floor == item.floor) {
        indexes.add(i);
      }
    }
    final int pos = indexes.indexWhere((i) => ordered[i].id == item.id);
    if (pos == -1) return false;
    final int target = pos + direction;
    if (target < 0 || target >= indexes.length) return false; //已到顶/底
    final int a = indexes[pos];
    final int b = indexes[target];
    final WaterFavoriteEntity temp = ordered[a];
    ordered[a] = ordered[b];
    ordered[b] = temp;
    await saveOrder(ordered);
    return true;
  }

  /// 拖动收藏到其他分类（可跨校区/栋数/楼层）：
  /// [before] 不为空时插到该条目前面，否则放到目标分组的最后
  static Future<void> moveTo({
    required WaterFavoriteEntity item,
    required String campus,
    required String building,
    required String floor,
    WaterFavoriteEntity? before,
  }) async {
    final List<WaterFavoriteEntity> ordered = sortForDisplay(await loadAll());
    final int from = ordered.indexWhere((e) => e.id == item.id);
    if (from == -1) return;
    final WaterFavoriteEntity moved = ordered
        .removeAt(from)
        .copyWith(campus: campus, building: building, floor: floor);
    int insertIndex;
    if (before != null) {
      final int pos = ordered.indexWhere((e) => e.id == before.id);
      insertIndex = pos == -1 ? ordered.length : pos;
    } else {
      //放到目标分组的最后面
      insertIndex = ordered.length;
      for (int i = ordered.length - 1; i >= 0; --i) {
        final WaterFavoriteEntity e = ordered[i];
        if (e.campus == campus &&
            e.building == building &&
            e.floor == floor) {
          insertIndex = i + 1;
          break;
        }
      }
    }
    ordered.insert(insertIndex, moved);
    await saveOrder(ordered);
  }

  /// 上移/下移一个分类（campus/building/floor 三个层级）
  /// 返回是否移动成功
  static Future<bool> moveCategory({
    required String level,
    required String name,
    String? campus,
    String? building,
    required int direction,
  }) async {
    final List<WaterFavoriteEntity> ordered = sortForDisplay(await loadAll());
    //1.按 校区→栋→楼层 建立层级结构（保持当前顺序）
    final Map<String, Map<String, Map<String, List<WaterFavoriteEntity>>>> tree =
        {};
    for (final WaterFavoriteEntity e in ordered) {
      tree
          .putIfAbsent(e.campus, () => {})
          .putIfAbsent(e.building, () => {})
          .putIfAbsent(e.floor, () => [])
          .add(e);
    }
    //2.在对应层级交换相邻分类
    if (level == 'campus') {
      if (!swapKey(tree, name, direction)) return false;
    } else if (level == 'building') {
      final Map<String, Map<String, List<WaterFavoriteEntity>>>? buildings =
          tree[campus];
      if (buildings == null || !swapKey(buildings, name, direction)) {
        return false;
      }
    } else {
      final Map<String, List<WaterFavoriteEntity>>? floors =
          tree[campus]?[building];
      if (floors == null || !swapKey(floors, name, direction)) return false;
    }
    //3.按新顺序展开成扁平列表后保存
    final List<WaterFavoriteEntity> result = <WaterFavoriteEntity>[];
    for (final buildings in tree.values) {
      for (final floors in buildings.values) {
        for (final items in floors.values) {
          result.addAll(items);
        }
      }
    }
    await saveOrder(result);
    return true;
  }

  /// 交换 Map 中相邻两个 key 的顺序（只改顺序不改内容）
  static bool swapKey<T>(Map<String, T> map, String name, int direction) {
    final List<String> keys = map.keys.toList();
    final int pos = keys.indexOf(name);
    if (pos == -1) return false;
    final int target = pos + direction;
    if (target < 0 || target >= keys.length) return false;
    final List<String> newKeys = List.of(keys);
    newKeys[pos] = keys[target];
    newKeys[target] = keys[pos];
    final Map<String, T> reordered = {};
    for (final String key in newKeys) {
      reordered[key] = map[key] as T;
    }
    map
      ..clear()
      ..addAll(reordered);
    return true;
  }

  /// 把收藏设置为当前绑定的饮水机
  static Future<void> apply(WaterFavoriteEntity entity) async {
    await ShareDateUtil().setHotWater(entity.hotDeviceId);
    await ShareDateUtil().setCoolWater(entity.coldDeviceId);
  }

  /// 删除一条收藏
  static Future<void> remove(WaterFavoriteEntity entity) async {
    await _dao.deleteFavorite(entity);
  }

  /// 扫描周边AP：
  /// 1.优先收集周边 NNLGXY 的AP（饮水机热点）
  /// 2.没有 NNLGXY 的AP时，取信号最强的前50个AP
  static Future<Map<String, dynamic>> scanAroundAps() async {
    final Map<String, dynamic> res = {'source': '', 'aps': <dynamic>[]};
    try {
      //扫描WiFi需要定位服务与位置权限
      if (!await locationReady()) return res;
      final WiFiHunterResult? result = await WiFiHunter.huntWiFiNetworks
          .timeout(const Duration(seconds: 12));
      if (result == null) return res;
      final List<Map<String, dynamic>> all = [];
      final List<Map<String, dynamic>> nnl = [];
      for (final r in result.results) {
        final Map<String, dynamic> item = {
          'SSID': r.ssid,
          'BSSID': r.bssid,
          'Level': r.level,
          'Frequency': r.frequency,
          'Timestamp': r.timestamp,
        };
        all.add(item);
        if (r.ssid == 'NNLGXY') nnl.add(item);
      }
      all.sort((a, b) => (b['Level'] as int).compareTo(a['Level'] as int));
      if (nnl.isNotEmpty) {
        res['source'] = 'NNLGXY';
        res['aps'] = nnl;
      } else {
        res['source'] = 'TOP50';
        res['aps'] = all.take(50).toList();
      }
    } on TimeoutException {
      log('收藏扫描AP超时');
    } catch (e) {
      //扫描被系统限流或权限异常时忽略，收藏本身不受影响
      log('收藏扫描AP失败: $e');
    }
    return res;
  }

  /// 定位服务与位置权限是否就绪（扫描WiFi必须）
  static Future<bool> locationReady() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      log('定位检查失败: $e');
      return false;
    }
  }

  /// 导出为JSON文件并调起系统分享，返回 null 表示成功
  static Future<String?> exportAndShare() async {
    try {
      final List<WaterFavoriteEntity> list = await loadAll();
      if (list.isEmpty) return '还没有收藏的饮水机';
      final Map<String, dynamic> data = {
        'type': 'callo_water_favorites',
        'version': 1,
        'exportTime': DateTime.now().toIso8601String(),
        'count': list.length,
        'favorites': list.map(_toJson).toList(),
      };
      final Directory dir = await getTemporaryDirectory();
      final File file = File(
          '${dir.path}/water_favorites_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(
          const JsonEncoder.withIndent('  ').convert(data));
      await Share.shareXFiles([XFile(file.path)], text: '饮水机收藏导出');
      return null;
    } catch (e) {
      log('导出收藏失败: $e');
      return '导出失败：$e';
    }
  }

  /// 从JSON文件导入收藏（重复的会跳过），返回结果提示；
  /// 用户取消选择时返回空字符串
  static Future<String> importFromFile() async {
    try {
      final FilePickerResult? picked = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['json'], withData: true);
      if (picked == null || picked.files.isEmpty) return ''; //用户取消
      final PlatformFile file = picked.files.first;
      final Uint8List bytes = file.bytes ??
          (file.path != null
              ? await File(file.path!).readAsBytes()
              : Uint8List(0));
      if (bytes.isEmpty) return '读取文件失败';
      final dynamic data = jsonDecode(utf8.decode(bytes));
      final List items =
          data is List ? data : ((data['favorites'] as List?) ?? []);
      if (items.isEmpty) return '文件里没有收藏数据';
      final List<WaterFavoriteEntity> exists = await loadAll();
      final Set<String> keys = exists.map(_key).toSet();
      final List<WaterFavoriteEntity> toInsert = [];
      final int indexBase = exists.length; //导入的数据排到最后面
      for (int i = 0; i < items.length; ++i) {
        final dynamic item = items[i];
        if (item is! Map) continue;
        final dynamic order = item['sortOrder'];
        final WaterFavoriteEntity entity = WaterFavoriteEntity(
          campus: '${item['campus'] ?? ''}',
          building: '${item['building'] ?? ''}',
          floor: '${item['floor'] ?? ''}',
          label: '${item['label'] ?? ''}',
          hotDeviceId: '${item['hotDeviceId'] ?? ''}',
          coldDeviceId: '${item['coldDeviceId'] ?? ''}',
          apSource: '${item['apSource'] ?? ''}',
          apJson: jsonEncode(item['aps'] ?? []),
          createdAt: DateTime.now(),
          sortOrder: order is int ? indexBase + order : indexBase + i,
        );
        if (keys.contains(_key(entity))) continue; //重复跳过
        keys.add(_key(entity));
        toInsert.add(entity);
      }
      if (toInsert.isEmpty) return '没有新的收藏可导入';
      await _dao.insertFavorites(toInsert);
      return '成功导入 ${toInsert.length} 条';
    } catch (e) {
      log('导入收藏失败: $e');
      return '导入失败：$e';
    }
  }

  static String buildLabel(String hot, String cold) {
    if (hot.isNotEmpty && cold.isNotEmpty) return '冷热一体机';
    if (hot.isNotEmpty) return '热水机';
    if (cold.isNotEmpty) return '冷水机';
    return '饮水机';
  }

  static Map<String, dynamic> _toJson(WaterFavoriteEntity e) => {
        'campus': e.campus,
        'building': e.building,
        'floor': e.floor,
        'label': e.label,
        'hotDeviceId': e.hotDeviceId,
        'coldDeviceId': e.coldDeviceId,
        'apSource': e.apSource,
        'aps': _safeDecode(e.apJson),
        'createdAt': e.createdAt?.toIso8601String(),
        'sortOrder': e.sortOrder,
      };

  static String _key(WaterFavoriteEntity e) =>
      '${e.campus}|${e.building}|${e.floor}|${e.hotDeviceId}|${e.coldDeviceId}';

  static List _safeDecode(String json) {
    try {
      final dynamic value = jsonDecode(json);
      return value is List ? value : [];
    } catch (e) {
      return [];
    }
  }
}
