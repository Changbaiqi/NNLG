/* FileName WaterFavoriteEntity
 *
 * @Description 收藏的饮水机：按 校区/栋数/楼层 分类存储，
 * 同时保存绑定时扫描到的周边AP（BSSID）用于定位
 */

import 'package:floor/floor.dart';

@Entity(tableName: 'WaterFavoriteEntity')
class WaterFavoriteEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String campus; //校区
  final String building; //栋数
  final String floor; //楼层
  final String label; //饮水机名称/备注
  final String hotDeviceId; //热水设备号
  final String coldDeviceId; //冷水设备号
  final String apSource; //AP来源：NNLGXY=周边NNLGXY的AP，TOP50=信号最强的前50个
  final String apJson; //扫描到的AP列表JSON
  DateTime? createdAt; //收藏时间
  final int sortOrder; //展示顺序（越小越靠前，分类顺序由组内条目的最小顺序决定）

  WaterFavoriteEntity({
    this.id,
    required this.campus,
    required this.building,
    required this.floor,
    this.label = '',
    this.hotDeviceId = '',
    this.coldDeviceId = '',
    this.apSource = '',
    this.apJson = '[]',
    this.createdAt,
    this.sortOrder = 0,
  });

  WaterFavoriteEntity copyWith({
    int? id,
    String? campus,
    String? building,
    String? floor,
    String? label,
    String? hotDeviceId,
    String? coldDeviceId,
    String? apSource,
    String? apJson,
    DateTime? createdAt,
    int? sortOrder,
  }) {
    return WaterFavoriteEntity(
      id: id ?? this.id,
      campus: campus ?? this.campus,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      label: label ?? this.label,
      hotDeviceId: hotDeviceId ?? this.hotDeviceId,
      coldDeviceId: coldDeviceId ?? this.coldDeviceId,
      apSource: apSource ?? this.apSource,
      apJson: apJson ?? this.apJson,
      createdAt: createdAt ?? this.createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
