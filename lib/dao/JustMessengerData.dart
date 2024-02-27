/* FileName JustMessengerData
 *
 * @Author 20840
 * @Date 2024/2/28 1:33
 *
 * @Description TODO
 */
import 'package:sqflite/sqflite.dart';

import 'DataBase.dart';

class JustMessengerData{
  static void initJustMessengerData() async{
    //得到数据库的路径
    var myDataBasePath = await DataBase.getDBPath();
    //打开数据库
    Database my_db = await openDatabase(myDataBasePath);

    //检测表是否存在，如果存在则跳过
    var list = await my_db.query('sqlite_master',
        where: """type='table' AND name='JustMessengerData'""");
    print(list);
    if (list.length == 0) {
      print('聊天记录寄存表不存在，正在创建寄存表');
      //创建表
      await my_db.execute('''
    CREATE TABLE JustMessengerData(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hbid INTEGER,
    msg_type TEXT,
    message TEXT,
    sendTime DATETIME
    )
    ''');
    }
    //关闭数据库
    await my_db.close();
  }
}