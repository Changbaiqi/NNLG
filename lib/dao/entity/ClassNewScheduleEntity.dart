/* FileName ClassNewScheduleEntity
 *
 * @Author 20840
 * @Date 2024/7/17 22:52
 *
 * @Description TODO
 */

import 'package:floor/floor.dart';

@entity
class ClassNewScheduleEntity{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? studentId;
  final String? semester;
  String? uid;
  DateTime? dateTime;
  String? md5;
  String? json;
  ClassNewScheduleEntity({this.id,this.studentId,this.semester,this.uid,this.dateTime,this.md5,this.json});
}