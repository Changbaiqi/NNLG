
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
class DataBase{
  static final String DataBaseName = 'data.db';
  //创建聊天信息数据库
  static Future<String> getDBPath() async {
    //在文档目录建立
    var document = await getApplicationDocumentsDirectory();
    //获取路径
    String path = join(document.path,DataBaseName);
    //如果数据库不存在那么就自动创建
    var _directory = Directory(dirname(path));
    bool exists = await _directory.exists();

    if(!exists){
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }


}