import 'dart:developer';

import 'package:flutter_pickers/pickers.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/utils/PowerDormUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';

import 'state.dart';
/**
 * [title] 
 * [author] 长白崎
 * [description] //TODO 宿舍选择
 * [date] 20:31 2024/9/3
 */
class CardMessageSetViewLogic extends GetxController {
  final CardMessageSetViewState state = CardMessageSetViewState();
  final selectData = [].obs;
  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 测试宿舍选择弹窗
   * [date] 1:14 2024/2/26
   * [param] null
   * [return]
   */
  List<dynamic> dormPicker()  {

    var multiData = {
      '桂林': {
        '7栋': [],
        '8栋': [],
        '9栋': [],
        '10A栋': [],
        '10B栋': [],
        '12栋': [],
        '13栋': [],
        '14A栋': [],
        '14B栋': [],
      },
      '南宁': {
        '13-1栋': [],
        '13-2栋': [],
        '15-1栋': [],
        '15-2栋': [],
        '17栋': [],
        '18栋': [],
        '19栋': [],
        '20栋': [],
        '21栋': [],
      }
    };
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 35; ++y) {
        multiData['桂林']?['7栋']?.add('${x * 100 + y}');
        multiData['桂林']?['8栋']?.add('${x * 100 + y}');
        multiData['桂林']?['9栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10A栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10B栋']?.add('${x * 100 + y}');
        multiData['桂林']?['12栋']?.add('${x * 100 + y}');
        multiData['桂林']?['13栋']?.add('${x * 100 + y}');
        multiData['桂林']?['14A栋']?.add('${x * 100 + y}');
        multiData['桂林']?['14B栋']?.add('${x * 100 + y}');
      }
    }
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 47; ++y) {
        multiData['南宁']?['13-1栋']?.add('${x * 100 + y}');
        multiData['南宁']?['13-2栋']?.add('${x * 100 + y}');
        multiData['南宁']?['15-1栋']?.add('${x * 100 + y}');
        multiData['南宁']?['15-2栋']?.add('${x * 100 + y}');
        multiData['南宁']?['17栋']?.add('${x * 100 + y}');
        multiData['南宁']?['18栋']?.add('${x * 100 + y}');
        multiData['南宁']?['19栋']?.add('${x * 100 + y}');
        multiData['南宁']?['20栋']?.add('${x * 100 + y}');
        multiData['南宁']?['21栋']?.add('${x * 100 + y}');
      }
    }

    Pickers.showMultiLinkPicker(Get.context!, data: multiData,selectData: selectData, columeNum: 3,onConfirm: (p,covariant) async{
      selectData.value = p;
      ShareDateUtil().setDormCampus(selectData[0]);
      ShareDateUtil().setDormLoudongId(selectData[1]);
      ShareDateUtil().setDormRoom(selectData[2]);
      AccountData.powerMoney.value = await PowerDormUtil().getDormPower(selectData[0], selectData[1], selectData[2]);
    });
    return selectData;
  }

  @override
  Future<void> onInit() async {
    if(AccountData.dormCampus.value!="" && AccountData.dormLoudongId.value!="" && AccountData.dormRoom .value!="") {
      selectData.add(AccountData.dormCampus.value);
      selectData.add(AccountData.dormLoudongId.value);
      selectData.add(AccountData.dormRoom.value);
      PowerDormUtil().getDormPower(selectData[0], selectData[1], selectData[2]).then((v){
        AccountData.powerMoney.value = v;
      });
    }
  }
}
