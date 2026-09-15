import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/entity/model/ShareCourseAccountModel.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

class CourseSharedChooseViewPage extends StatelessWidget {
  CourseSharedChooseViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedChooseViewLogic>();
  final state = Get.find<CourseSharedChooseViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    final Color textColor = GlassTheme.textColor('main_course_view');
    return Obx(() => GlassBackground(
        page: 'main_course_view',
        child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: !state.isSearch.value,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: textColor,
          title: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedCrossFade(
                  firstChild: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '查询',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: textColor),
                    ),
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
                            style: TextStyle(fontSize: 14, color: textColor),
                            cursorColor:
                                GlassTheme.accentColor('main_course_view'),
                            decoration: InputDecoration(
                              hintText: '搜索',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withValues(alpha: .45)),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 0, 50, 0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                      color:
                                          textColor.withValues(alpha: .25),
                                      width: 1.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                      color:
                                          textColor.withValues(alpha: .18),
                                      width: 1.2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                      color: GlassTheme.accentColor(
                                          'main_course_view'),
                                      width: 1.5)),
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
        ))));
  }

  /**
   * 每个选项的子项
   */
  Widget childView(accountDataJson) {
    final Color textColor = GlassTheme.textColor('main_course_view');
    return GlassCard(
      page: 'main_course_view',
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      onTap: () {
        Get.toNamed(Routes.CourseSharedShow,
            arguments: {'data': accountDataJson});
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/user.jpg',
              width: 34,
              height: 34,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('姓名：${accountDataJson['studentName']}',
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: textColor)),
                const SizedBox(height: 4),
                Text('学号：${accountDataJson['userAccount']}',
                    style: TextStyle(
                        fontSize: 12,
                        color: textColor.withValues(alpha: .65))),
                const SizedBox(height: 2),
                Text('专业班级：${accountDataJson['studentClass']}',
                    style: TextStyle(
                        fontSize: 12,
                        color: textColor.withValues(alpha: .65))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
