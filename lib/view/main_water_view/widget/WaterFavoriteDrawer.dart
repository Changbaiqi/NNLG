import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/dao/WaterData.dart';
import 'package:callo/dao/entity/WaterFavoriteEntity.dart';
import 'package:callo/utils/GlassUI.dart';

import '../logic.dart';

/// 右侧收藏抽屉：按 校区 → 栋数 → 楼层 分组展示收藏的饮水机
/// 支持：按住条目左侧标志拖动到其他分类（可跨校区/栋数/楼层）、
/// 编辑/删除条目、分类重命名/上下移动/删除、导入导出
class WaterFavoriteDrawer extends StatelessWidget {
  const WaterFavoriteDrawer({Key? key}) : super(key: key);

  static const String _page = 'main_water_view';

  @override
  Widget build(BuildContext context) {
    final MainWaterViewLogic logic = Get.find<MainWaterViewLogic>();
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return Drawer(
      width: MediaQuery.of(context).size.width * .88,
      backgroundColor: GlassTheme.surface(_page),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('收藏的饮水机',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: text)),
                        const SizedBox(height: 2),
                        Obx(() => Text(
                            '共 ${logic.favorites.length} 台（按校区/栋/楼层分类）',
                            style: TextStyle(
                                fontSize: 11,
                                color: text.withValues(alpha: .55)))),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: '从JSON文件导入',
                    onPressed: logic.importFavorites,
                    icon: Icon(Icons.file_download_outlined, color: text),
                  ),
                  IconButton(
                    tooltip: '导出JSON并分享',
                    onPressed: logic.exportFavorites,
                    icon: Icon(Icons.ios_share_rounded, color: text),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: text),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: text.withValues(alpha: .12)),
            Expanded(
              child: Obx(() {
                if (logic.favoritesLoading.value && logic.favorites.isEmpty) {
                  return Center(
                      child: CircularProgressIndicator(color: accent));
                }
                final List<WaterFavoriteEntity> list = logic.favorites;
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        '还没有收藏的饮水机\n\n在下方点击「收藏」按钮\n填写 校区/栋数/楼层 即可保存',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.7,
                            color: text.withValues(alpha: .6)),
                      ),
                    ),
                  );
                }
                //按 校区 → 栋数 → 楼层 分组
                final Map<String, Map<String, Map<String, List<WaterFavoriteEntity>>>>
                    grouped = {};
                for (final WaterFavoriteEntity e in list) {
                  grouped
                      .putIfAbsent(e.campus, () => {})
                      .putIfAbsent(e.building, () => {})
                      .putIfAbsent(e.floor, () => [])
                      .add(e);
                }
                final List<Widget> children = [];
                grouped.forEach((campus, buildings) {
                  //校区
                  final String campusKey = 'campus:$campus';
                  children.add(_header(campus, Icons.location_city_rounded,
                      text, accent,
                      logic: logic,
                      level: 'campus',
                      collapsed: logic.isCategoryCollapsed(campusKey),
                      onToggle: () => logic.toggleCategory(campusKey)));
                  if (logic.isCategoryCollapsed(campusKey)) return; //收起时不渲染子分类
                  buildings.forEach((building, floors) {
                    //栋数
                    final String buildingKey = 'building:$campus|$building';
                    children.add(_header(
                        building,
                        Icons.apartment_rounded,
                        text.withValues(alpha: .85),
                        text,
                        small: true,
                        logic: logic,
                        level: 'building',
                        campus: campus,
                        collapsed: logic.isCategoryCollapsed(buildingKey),
                        onToggle: () => logic.toggleCategory(buildingKey)));
                    if (logic.isCategoryCollapsed(buildingKey)) {
                      return; //收起时不渲染子分类
                    }
                    floors.forEach((floor, items) {
                      //楼层
                      final String floorKey = 'floor:$campus|$building|$floor';
                      children.add(_header(floor, Icons.layers_rounded,
                          text.withValues(alpha: .85), text,
                          small: true,
                          logic: logic,
                          level: 'floor',
                          campus: campus,
                          building: building,
                          collapsed: logic.isCategoryCollapsed(floorKey),
                          onToggle: () => logic.toggleCategory(floorKey)));
                      if (logic.isCategoryCollapsed(floorKey)) {
                        return; //收起时不渲染条目
                      }
                      children.add(_group(items, context, logic, text, accent,
                          campus: campus, building: building, floor: floor));
                    });
                  });
                });
                return ListView(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 24),
                  children: children,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// 分组标题：校区/栋数/楼层
  /// 左侧为展开/收起按钮，可接收拖动的收藏，带 ⋮ 菜单
  Widget _header(String title, IconData icon, Color color, Color accent,
      {bool small = false,
      required MainWaterViewLogic logic,
      required String level,
      String? campus,
      String? building,
      bool collapsed = false,
      VoidCallback? onToggle}) {
    final Widget row = Padding(
      padding: EdgeInsets.fromLTRB(small ? 8 : 2, small ? 8 : 12, 4, 4),
      child: Row(
        children: [
          //展开/收起按钮
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                collapsed
                    ? Icons.keyboard_arrow_right_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: small ? 16 : 20,
                color: color,
              ),
            ),
          ),
          Icon(icon, size: small ? 14 : 16, color: accent),
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Text(title,
                  style: TextStyle(
                      fontSize: small ? 12.5 : 14,
                      fontWeight: small ? FontWeight.w600 : FontWeight.w700,
                      color: color)),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: '分类操作',
            padding: EdgeInsets.zero,
            icon: Icon(Icons.more_vert_rounded,
                size: small ? 16 : 18, color: color.withValues(alpha: .7)),
            onSelected: (value) {
              if (value == 'rename') {
                logic.renameCategoryDialog(level, title,
                    campus: campus, building: building);
              } else if (value == 'up') {
                logic.moveCategory(level, title,
                    campus: campus, building: building, direction: -1);
              } else if (value == 'down') {
                logic.moveCategory(level, title,
                    campus: campus, building: building, direction: 1);
              } else if (value == 'delete') {
                logic.deleteCategory(level, title,
                    campus: campus, building: building);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'rename', child: Text('重命名')),
              const PopupMenuItem(value: 'up', child: Text('上移')),
              const PopupMenuItem(value: 'down', child: Text('下移')),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                child: Text('删除分类',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        ],
      ),
    );
    //拖动条目到分类标题上：移动到该分类
    return DragTarget<WaterFavoriteEntity>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        final WaterFavoriteEntity item = details.data;
        if (level == 'campus') {
          //保持原来的栋数/楼层
          logic.moveFavoriteToGroup(item,
              campus: title, building: item.building, floor: item.floor);
        } else if (level == 'building') {
          logic.moveFavoriteToGroup(item,
              campus: campus ?? item.campus,
              building: title,
              floor: item.floor);
        } else {
          logic.moveFavoriteToGroup(item,
              campus: campus ?? item.campus,
              building: building ?? item.building,
              floor: title);
        }
      },
      builder: (context, candidate, rejected) {
        final bool hovering = candidate.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: hovering
              ? BoxDecoration(
                  color: accent.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent),
                )
              : null,
          child: row,
        );
      },
    );
  }

  /// 一个楼层分组：条目列表 + 末尾放置区
  Widget _group(List<WaterFavoriteEntity> items, BuildContext context,
      MainWaterViewLogic logic, Color text, Color accent,
      {required String campus,
      required String building,
      required String floor}) {
    return Column(
      children: [
        for (int i = 0; i < items.length; ++i)
          _tile(context, logic, items[i], text, accent),
        _groupEndTarget(logic,
            campus: campus,
            building: building,
            floor: floor,
            text: text,
            accent: accent),
      ],
    );
  }

  /// 分组末尾的放置区（拖动时出现）：把条目放到该分组最后面
  Widget _groupEndTarget(MainWaterViewLogic logic,
      {required String campus,
      required String building,
      required String floor,
      required Color text,
      required Color accent}) {
    //只有正在拖动时才显示
    if (logic.draggingFavorite.value == null) return const SizedBox(height: 2);
    return DragTarget<WaterFavoriteEntity>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) => logic.moveFavoriteToGroup(details.data,
          campus: campus, building: building, floor: floor),
      builder: (context, candidate, rejected) {
        final bool hovering = candidate.isNotEmpty;
        return Container(
          height: 32,
          margin: const EdgeInsets.symmetric(vertical: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: hovering ? accent.withValues(alpha: .16) : null,
            border: Border.all(
                color: hovering ? accent : accent.withValues(alpha: .35),
                width: hovering ? 1.6 : 1),
          ),
          child: Text(
            '放到「$floor」最后',
            style: TextStyle(fontSize: 11, color: text.withValues(alpha: .6)),
          ),
        );
      },
    );
  }

  /// 单台饮水机条目：
  /// 长按左侧标志可拖动到其他分类或插到其他条目前面；
  /// 当前绑定的条目用主色容器高亮并标注「当前绑定」
  Widget _tile(BuildContext context, MainWaterViewLogic logic,
      WaterFavoriteEntity e, Color text, Color accent) {
    final ColorScheme scheme = GlassTheme.scheme;
    //当前绑定：设备号任一匹配即认为这条收藏包含当前使用的饮水机
    final String currentHot = WaterData.hotWater.value;
    final String currentCold = WaterData.coolWater.value;
    final bool isCurrent =
        (e.hotDeviceId.isNotEmpty && e.hotDeviceId == currentHot) ||
            (e.coldDeviceId.isNotEmpty && e.coldDeviceId == currentCold);
    int apCount = 0;
    try {
      final dynamic value = jsonDecode(e.apJson);
      if (value is List) apCount = value.length;
    } catch (e) {
      apCount = 0;
    }
    final String devices = [
      if (e.hotDeviceId.isNotEmpty) '热:${e.hotDeviceId}',
      if (e.coldDeviceId.isNotEmpty) '冷:${e.coldDeviceId}',
    ].join('  ');

    final Widget card = Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      //当前绑定：主色容器底 + 主色描边
      color: isCurrent ? scheme.primaryContainer : null,
      shape: isCurrent
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: scheme.primary, width: 1.2))
          : null,
      child: ListTile(
        dense: true,
        //长按拖动排序 / 拖动到其他分类
        leading: LongPressDraggable<WaterFavoriteEntity>(
          data: e,
          onDragStarted: () => logic.draggingFavorite.value = e,
          onDragEnd: (_) => logic.draggingFavorite.value = null,
          feedback: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: scheme.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop_rounded, size: 16, color: accent),
                  const SizedBox(width: 6),
                  Text(e.label, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
          childWhenDragging: Icon(Icons.drag_indicator_rounded,
              color: text.withValues(alpha: .2)),
          child: Icon(Icons.drag_indicator_rounded,
              color: text.withValues(alpha: .45)),
        ),
        title: Row(
          children: [
            Icon(
              isCurrent ? Icons.check_circle_rounded : Icons.water_drop_rounded,
              size: 16,
              color: isCurrent ? scheme.primary : accent,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(e.label,
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          isCurrent ? FontWeight.w700 : FontWeight.w600)),
            ),
            if (isCurrent) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '当前绑定',
                  style: TextStyle(fontSize: 10, color: scheme.onPrimary),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          '${devices.isEmpty ? "未绑定设备" : devices}\nAP：$apCount 个（${e.apSource.isEmpty ? "未记录" : e.apSource}）',
          style: const TextStyle(fontSize: 11, height: 1.5),
        ),
        isThreeLine: true,
        //⋮ 菜单：编辑/删除
        trailing: PopupMenuButton<String>(
          tooltip: '操作',
          icon: Icon(Icons.more_vert_rounded,
              color: text.withValues(alpha: .6), size: 20),
          onSelected: (value) {
            if (value == 'edit') {
              logic.editFavorite(e);
            } else if (value == 'delete') {
              logic.deleteFavorite(e);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('编辑')),
            PopupMenuItem(
              value: 'delete',
              child: Text('删除',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        ),
        onTap: () async {
          await logic.applyFavorite(e);
          if (context.mounted) Navigator.pop(context); //切换后关闭抽屉
        },
      ),
    );

    //拖动到其他条目上：插到该条目前面（并移动到它所在的分类）
    return DragTarget<WaterFavoriteEntity>(
      onWillAcceptWithDetails: (details) => details.data.id != e.id,
      onAcceptWithDetails: (details) => logic.moveFavoriteToGroup(details.data,
          campus: e.campus,
          building: e.building,
          floor: e.floor,
          before: e),
      builder: (context, candidate, rejected) {
        final bool hovering = candidate.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: hovering
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent, width: 1.6),
                )
              : null,
          child: card,
        );
      },
    );
  }
}
