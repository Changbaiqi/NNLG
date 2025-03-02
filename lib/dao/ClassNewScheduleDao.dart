/* FileName ClassScheduleDao
 *
 * @Author 20840
 * @Date 2024/6/12 0:28
 *
 * @Description TODO
 */
import 'package:floor/floor.dart';
import 'package:callo/dao/entity/ClassScheduleEntity.dart';

import 'entity/ClassNewScheduleEntity.dart';

@dao
abstract class ClassNewScheduleDao{

  @Query('SELECT * FROM ClassNewScheduleEntity')
  Future<List<ClassNewScheduleEntity>> findAllClassNewSchedule();

  @Query('SELECT * FROM ClassNewScheduleEntity WHERE studentId= :studentId and semester= :semester ORDER BY dateTime DESC')
  Future<List<ClassNewScheduleEntity>> findAllClassNewScheduleForStudentIdAndSemester(String studentId,String semester);

  @Query('SELECT * FROM ClassNewScheduleEntity WHERE uid= :uid LIMIT 1')
  Future<ClassNewScheduleEntity?> findClassNewScheduleForUid(String uid);

  @Query('SELECT * FROM ClassNewScheduleEntity WHERE studentId= :studentId AND semester= :semester ORDER BY dateTime DESC LIMIT 1')
  Future<ClassNewScheduleEntity?> findNewestClassNewSchedule(String studentId,String semester);

  @Query('SELECT * FROM ClassNewScheduleEntity WHERE uid= :uid')
  Future<List<ClassNewScheduleEntity>> findClassNewScheduleListForUid(String uid);

  @insert
  Future<void> insertClassNewSchedule(ClassNewScheduleEntity classNewScheduleEntity);

  @delete
  Future<int> deleteClassNewSchedule(ClassNewScheduleEntity classNewScheduleEntity);
}