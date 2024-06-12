/* FileName DateTimeConverter
 *
 * @Author 20840
 * @Date 2024/6/12 9:05
 *
 * @Description TODO
 */
import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime?,int?>{

  @override
  DateTime? decode(int? databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue!);
  }

  @override
  int? encode(DateTime? value) {
    return value?.millisecondsSinceEpoch;
  }

}