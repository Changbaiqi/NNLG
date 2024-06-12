/* FileName ClassScheduleData
 *
 * @Author 20840
 * @Date 2024/6/12 0:21
 *
 * @Description TODO
 */

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:nnlg/dao/ClassScheduleDao.dart';
import 'package:nnlg/dao/entity/ClassScheduleEntity.dart';
import 'package:nnlg/dao/entity/DateTimeConverter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'ClassScheduleDatabase.g.dart'; // 生成的代码会在那里
@TypeConverters([DateTimeConverter])
@Database(version: 4, entities: [ClassScheduleEntity])
abstract class ClassScheduleDatabase extends FloorDatabase {
  ClassScheduleDao get classScheduleDao;
}