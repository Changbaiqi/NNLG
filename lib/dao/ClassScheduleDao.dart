/* FileName ClassScheduleDao
 *
 * @Author 20840
 * @Date 2024/6/12 0:28
 *
 * @Description TODO
 */
import 'package:floor/floor.dart';
import 'package:nnlg/dao/entity/ClassScheduleEntity.dart';

@dao
abstract class ClassScheduleDao{
  @Query('SELECT * FROM ClassScheduleEntity')
  Future<List<ClassScheduleEntity>> findAllClassSchedule();

  @Query('SELECT * FROM ClassScheduleEntity WHERE studentId= :studentId and semester= :semester')
  Future<List<ClassScheduleEntity>> findAllClassScheduleForStudentIdAndSemester(String studentId,String semester);

  @Query('SELECT * FROM ClassScheduleEntity WHERE uid= :uid LIMIT 1')
  Future<ClassScheduleEntity?> findClassScheduleForUid(String uid);

  @Query('SELECT * FROM ClassScheduleEntity WHERE studentId= :studentId AND semester= :semester ORDER BY dateTime DESC LIMIT 1')
  Future<ClassScheduleEntity?> findNewestClassSchedule(String studentId,String semester);

  @Query('SELECT * FROM ClassScheduleEntity WHERE uid= :uid')
  Future<List<ClassScheduleEntity>> findClassScheduleListForUid(String uid);

  @insert
  Future<void> insertClassSchedule(ClassScheduleEntity classScheduleEntity);

  @delete
  Future<int> deleteClassSchedule(ClassScheduleEntity classScheduleEntity);
}