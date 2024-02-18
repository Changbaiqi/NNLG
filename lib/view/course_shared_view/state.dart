import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/web/ShareCourseWeb.dart';

class CourseSharedViewState {

  final isSearch = false.obs; //是否是搜索模式

  final searchController = TextEditingController().obs;

  final searchTxtIsEmpty = true.obs; //监听搜索框内容是否为空
  final shareList = [].obs; //展示分享的列表数据
  final shareListSet = HashSet().obs; //展示分享的对应学号Set数据
  final searchList = [].obs; //展示搜索的列表数据

  final isSearchingState = false.obs; //是否正在搜索中

  final isLoadingShareState = false.obs; //是否处于加载共享列表中

  final gloablKey = GlobalKey<AnimatedListState>().obs; //动画控制

  CourseSharedViewState() {
    ///Initialize variables
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 获取自己分享给别人课表的账号列表
   * [date] 21:57 2024/2/12
   * [param] null
   * [return]
   */
  getShareAccountList() async{
    isLoadingShareState.value = true;
    shareList.value.clear();
    shareList.refresh();
    await ShareCourseWeb().getShareMeShareList().then((value){
      if(value['code']!=200){
        Get.snackbar("请求错误", "${value['message']}",
            duration: Duration(milliseconds: 1500));
        return;
      }

      //赋值列表
      shareList.value = value['data']['shareAccountList'];
      //重置HashSet
      shareListSet.value.clear();
      shareList.value.forEach((element) { shareListSet.value.add('${element['shareAccount']}');});
      isLoadingShareState.value = false;
      shareList.refresh();
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
  searchAccount(String seachKey) async{
    isSearchingState.value = true; //状态设置为搜索中
    searchList.value.clear(); //清空搜索
    await ShareCourseWeb().searchShareCourseData(seachKey).then((value){
      //如果请求失败
      if(value['code']!=200){
        Get.snackbar("请求错误", "${value['message']}",
            duration: Duration(milliseconds: 1500));
        return;
      }

      value['data']['searchList'].forEach((e){ shareListSet.value.contains('${e['shareAccount']}')?e['isShare']=true:e['isShare']=false;});
      searchList.value = value['data']['searchList'];

      searchList.refresh();
    });
    isSearchingState.value = false; //取消搜索中
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 删除账号
   * [date] 22:32 2024/2/12
   * [param] null
   * [return]
   */
  deleteShareMeShare(jsonData, String studentId) async {
    await ShareCourseWeb().deleteShareMeShare(studentId).then((value){
      print(studentId);
      //如果请求失败
      if(value['code']!=200){
        Get.snackbar("操作提示", "${value['message']}",
            duration: Duration(milliseconds: 1500));
        return;
      }

      // 删除数据
      shareList.value.removeWhere((element) => element['shareAccount']=='${studentId}');
      // shareList.value.remove(jsonData);
      shareListSet.value.remove('${studentId}');
      jsonData['isShare']= false;
      shareList.refresh();
      shareListSet.refresh();
      searchTxtIsEmpty.refresh();

      Get.snackbar("操作提示", "${value['message']}",
          duration: Duration(milliseconds: 1500));
    });
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 添加账号
   * [date] 22:32 2024/2/12
   * [param] null
   * [return]
   */
  addShareMeShare(jsonData, String studentId) async {
    await ShareCourseWeb().addShareMeShare(studentId).then((value){
      //如果请求失败
      if(value['code']!=200){
        Get.snackbar("操作提示", "${value['message']}",
            duration: Duration(milliseconds: 1500));
        return;
      }

      // 添加数据
      shareList.value.add(jsonData);
      shareListSet.value.add('${studentId}');
      jsonData['isShare'] = true;
      shareList.refresh();
      shareListSet.refresh();
      searchTxtIsEmpty.refresh();

      Get.snackbar("操作提示", "${value['message']}",
          duration: Duration(milliseconds: 1500));
    });
  }


}
