/* FileName FileUtils
 *
 * @Author 20840
 * @Date 2024/7/14 23:27
 *
 * @Description TODO
 */
import 'dart:convert';
import 'package:flutter/services.dart';

class FileUtils{
  static Future<String> loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonString;
  }
}