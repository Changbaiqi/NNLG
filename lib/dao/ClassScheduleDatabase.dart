/* FileName ClassScheduleData
 *
 * @Author 20840
 * @Date 2024/6/12 0:21
 *
 * @Description TODO
 */

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:callo/dao/ClassScheduleDao.dart';
import 'package:callo/dao/ClassNewScheduleDao.dart';
import 'package:callo/dao/entity/ClassNewScheduleEntity.dart';
import 'package:callo/dao/entity/ClassScheduleEntity.dart';
import 'package:callo/dao/entity/DateTimeConverter.dart';
import 'package:callo/dao/entity/StringListConverter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'ClassScheduleDatabase.g.dart'; // 生成的代码会在那里
@TypeConverters([DateTimeConverter,StringListConverter])
@Database(version: 6, entities: [ClassScheduleEntity,ClassNewScheduleEntity])
abstract class ClassScheduleDatabase extends FloorDatabase {
  ClassScheduleDao get classScheduleDao;
  ClassNewScheduleDao get classNewScheduleDao;
}