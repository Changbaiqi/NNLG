/* FileName ClassScheduleEntity
 *
 * @Author 20840
 * @Date 2024/6/12 0:23
 *
 * @Description TODO
 */
import 'package:floor/floor.dart';

@entity
class ClassScheduleEntity{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? studentId;
  final String? semester;
  String? uid;
  DateTime? dateTime;
  String? md5;
  String? json;
  ClassScheduleEntity({this.id,this.studentId,this.semester,this.uid,this.dateTime,this.md5,this.json});
}