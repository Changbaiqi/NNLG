import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class CourseSharedChooseViewPage extends StatelessWidget {
  CourseSharedChooseViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedChooseViewLogic>();
  final state = Get.find<CourseSharedChooseViewLogic>().state;


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !state.isSearch.value,
          title: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedCrossFade(
                  firstChild: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('查询'),
                  ),
                  secondChild: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            controller: state.searchController.value,
                            decoration: InputDecoration(
                              hintText: '搜索',
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 50, 0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 2.0)),
                            ),
                            onSubmitted: (value) {
                              //检测输入框数据是否为空
                              if (state.searchTxtIsEmpty.value) {
                                state.isSearch.value = !state.isSearch.value;
                                return;
                              }

                              state.searchAccount(
                                  state.searchController.value.text);
                              state.searchController.refresh();
                            },
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: state.isSearch.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 100)),
              Align(
                child: IconButton(
                  icon: Icon(
                      (!state.searchTxtIsEmpty.value && state.isSearch.value) ||
                              (!state.isSearch.value)
                          ? Icons.search
                          : Icons.close),
                  onPressed: () {
                    //检测输入框数据是否为空
                    if (state.searchTxtIsEmpty.value) {
                      state.isSearch.value = !state.isSearch.value;
                      return;
                    }

                    state.searchAccount(state.searchController.value.text);
                    state.searchController.refresh();
                  },
                ),
                alignment: Alignment.centerRight,
              )
            ],
          ),
          elevation: 0,
        ),
        body: WillPopScope(
          child: Obx(() => state.isSearch.value
              ? logic.searchView(state.searchController.value.text)
              : logic.shareChooseView()),
          onWillPop: () async {
            if (state.isSearch.value) {
              state.searchController.value.text = '';
              state.searchList.value.clear();
              state.isSearch.value = false;
              return false;
            }
            Get.back(); //退出当前页面
            return false;
          },
        )));
  }

  /**
   * 每个选项的子项
   */
  Widget childView(accountDataJson) {
    // var json = jsonDecode(list[index]);
    return InkWell(
      child: Container(
        height: 90,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/user.jpg',
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('姓名：${accountDataJson['studentName']}'),
                    Text('班级：${accountDataJson['studentClass']}'),
                    Text('学号：${accountDataJson['userAccount']}')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Get.toNamed(Routes.CourseSharedShow,
            arguments: {'data': accountDataJson});
      },
    );
  }
}
