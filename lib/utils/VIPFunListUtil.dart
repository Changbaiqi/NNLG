import 'package:dio/dio.dart';
import 'package:callo/dao/ContextData.dart';


class VIPFunListUtil {

  BaseOptions _options = BaseOptions();

  VIPFunListUtil() {
    _options.baseUrl = ContextDate.VIPContextUrl;
  }



}