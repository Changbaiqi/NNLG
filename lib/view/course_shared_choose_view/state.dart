import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart';
import 'package:nnlg/web/ShareCourseWeb.dart';

class CourseSharedChooseViewState {

  final accountList = [].obs;


  final isSearch = false.obs; //是否是搜索模式

  final searchController = TextEditingController().obs;

  final searchTxtIsEmpty = true.obs; //监听搜索框内容是否为空
  final shareList = [].obs; //展示分享的列表数据
  final shareListSet = HashSet().obs; //展示分享的对应学号Set数据
  final searchList = [].obs; //展示搜索的列表数据

  final isSearchingState = false.obs; //是否正在搜索中

  final isLoadingShareState = false.obs; //是否处于加载共享列表中

  final gloablKey = GlobalKey<AnimatedListState>().obs; //动画控制

  CourseSharedChooseViewState() {
    ///Initialize variables
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 用于初始化获取共享课表的账号数据
   * [date] 3:46 2024/2/11
   * [param] null
   * [return]
   */
  initGetSharedAccountList() async {
    await ShareCourseWeb().getShareAccountList().then((model) {
      if (model['code']!= 200)
        Get.snackbar(
          "异常通知",
          "${model['message']}",
          duration: Duration(milliseconds: 1500),
        );
      accountList.value = model['data']['shareAccountList'];
    });
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 搜索
   * [date] 20:41 2024/2/12
   * [param] null
   * [return]
   */
  searchAccount(String searchKey) async {
    isSearchingState.value = true; //状态设置为搜索中
    searchList.value.clear(); //清空搜索

    accountList.value.forEach((e) {
      if(e['studentName'].contains('${searchKey}') || e['userAccount'].contains('${searchKey}') || e['studentClass'].contains('${searchKey}')){
        searchList.add(e);
      }
    });
    searchList.refresh();
    isSearchingState.value = false; //取消搜索中
  }


}
