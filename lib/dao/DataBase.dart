
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

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 检测表是否存在，存在则true，不存在则false
   * [date] 23:50 2024/6/11
   * [param] null
   * [return]
   */
  static Future<bool> checkTable(String tableName) async{
    //得到数据库的路径
    var myDataBasePath = await DataBase.getDBPath();
    //打开数据库
    Database my_db = await openDatabase(myDataBasePath);
    //检测表是否存在，如果存在则跳过
    var list = await my_db.query('sqlite_master',
        where: """type='table' AND name='${tableName}'""");
    if(list==0) return false;
    return true;
  }


}