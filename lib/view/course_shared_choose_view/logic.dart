import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:callo/entity/model/ShareCourseAccountModel.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/router/Routes.dart';

import 'state.dart';

class CourseSharedChooseViewLogic extends GetxController {


  final CourseSharedChooseViewState state = CourseSharedChooseViewState();



  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 显示当当前共享给的账号页面
   * [date] 20:43 2024/2/11
   * [param] null
   * [return]
   */
  Widget shareChooseView() {
    return Container(
      child: Obx(() => state.isLoadingShareState.value
          ? Center(
        child: LottieBuilder.asset(
          'assets/images/shareLoadingLottie.json',
          height: 150,
          width: 150,
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.only(bottom: 16),
        itemCount: state.accountList.value.length,
        itemBuilder: (BuildContext contxt, int index) {
          return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                verticalOffset: 50.0,
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: accountCard(state.accountList.value[index]),
                ),
              ));
        },
      )),
    );
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 账号资料卡片
   * [date] 20:46 2024/2/11
   * [param] null
   * [return]
   */
  Widget accountCard(json) {
    final Color textColor = GlassTheme.textColor('main_course_view');
    return GlassCard(
      page: 'main_course_view',
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      onTap: () {
        Get.toNamed(Routes.CourseSharedShow, arguments: {'data': json});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('姓名：${json['studentName']}',
              style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
          const SizedBox(height: 5),
          Text('学号：${json['userAccount']}',
              style: TextStyle(
                  fontSize: 12, color: textColor.withValues(alpha: .65))),
          const SizedBox(height: 3),
          Text('专业班级：${json['studentClass']}',
              style: TextStyle(
                  fontSize: 12, color: textColor.withValues(alpha: .65))),
        ],
      ),
    );
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 搜索页面
   * [date] 20:43 2024/2/11
   * [param] null
   * [return]
   */
  Widget searchView(String searchTxt) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Obx(() => state.isSearchingState.value
          ? Center(
        child:
        LottieBuilder.asset('assets/images/searchLoadingLottie.json'),
      )
          : Obx(() => ListView.builder(
          padding: EdgeInsets.only(bottom: 16),
          scrollDirection: Axis.vertical,
          itemCount: state.searchList.value.length,
          itemBuilder: (BuildContext contxt, int index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Obx(() => searchCard(
                        searchTxt, state.searchList.value[index])),
                  ),
                ));
          }))),
    );
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 搜索卡片
   * [date] 20:34 2024/2/12
   * [param] isShare 是否分享过，true代表分享过了，false代表没分享过
   * [return]
   */
  Widget searchCard(String searchTxT, json) {
    final Color textColor = GlassTheme.textColor('main_course_view');
    return GlassCard(
      page: 'main_course_view',
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      onTap: () {
        Get.toNamed(Routes.CourseSharedShow, arguments: {'data': json});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '姓名：',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: textColor))
                ]..addAll(buildText(
                    searchTxT, '${json['studentName']}'))),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '学号：',
                      style: TextStyle(
                          fontSize: 12,
                          color: textColor.withValues(alpha: .65)))
                ]..addAll(buildText(
                    searchTxT, '${json['userAccount']}'))),
          ),
          const SizedBox(height: 3),
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '专业年级：',
                      style: TextStyle(
                          fontSize: 12,
                          color: textColor.withValues(alpha: .65)))
                ]..addAll(buildText(
                    searchTxT, '${json['studentClass']}'))),
          ),
        ],
      ),
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 构建查询粗字体
   * [date] 23:14 2024/2/27
   * [param] null
   * [return]
   */
  List<TextSpan> buildText(String searchTxT, String dataTxt) {
    final Color textColor = GlassTheme.textColor('main_course_view');
    final Color accent = GlassTheme.accentColor('main_course_view');
    List<TextSpan> list = [];
    List<String> strList = dataTxt.split('${searchTxT}');
    for (int i = 0; i < strList.length; ++i) {
      list.add(TextSpan(
          text: '${strList[i]}', style: TextStyle(color: textColor)));
      if (i != strList.length - 1)
        list.add(TextSpan(
            text: '${searchTxT}',
            style:
            TextStyle(color: accent, fontWeight: FontWeight.w900)));
    }
    return list;
  }

  @override
  void onInit() {
    state.initGetSharedAccountList();
    state.searchController.value.addListener(() {
      String txt = state.searchController.value.text;
      //如果文本为空
      if (txt.isEmpty)
        state.searchTxtIsEmpty.value = true;
      else
        state.searchTxtIsEmpty.value = false;
    });
  }
}
