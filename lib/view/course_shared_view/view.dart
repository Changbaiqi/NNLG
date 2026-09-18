import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';

class CourseSharedViewPage extends StatelessWidget {
  CourseSharedViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedViewLogic>();
  final state = Get.find<CourseSharedViewLogic>().state;

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
                      '共享',
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
                                        color: textColor.withValues(alpha: .25),
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
                                        width: 1.5))),
                            onSubmitted: (value){
                              //检测输入框数据是否为空
                              if (state.searchTxtIsEmpty.value) {
                                state.isSearch.value = !state.isSearch.value;
                                return;
                              }

                              state.searchAccount(state.searchController.value.text);
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
              ? searchView(state.searchController.value.text)
              : shareView()),
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
   * [title]
   * [author] 长白崎
   * [description] TODO 显示当当前共享给的账号页面
   * [date] 20:43 2024/2/11
   * [param] null
   * [return]
   */
  Widget shareView() {
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
              itemCount: state.shareList.value.length,
              itemBuilder: (BuildContext contxt, int index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: accountCard(state.shareList.value[index]),
                      ),
                    ));
              },
            )),
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

  /// 右侧操作按钮（删除/分享）
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 13, 12, 13),
      child: Row(
        children: [
          Expanded(
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
                Text('学号：${json['shareAccount']}',
                    style: TextStyle(
                        fontSize: 12, color: textColor.withValues(alpha: .65))),
                const SizedBox(height: 3),
                Text('专业班级：${json['studentClass']}',
                    style: TextStyle(
                        fontSize: 12, color: textColor.withValues(alpha: .65))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _actionButton(
            icon: Icons.delete_outline_rounded,
            color: GlassTheme.scheme.error,
            onTap: () {
              state.deleteShareMeShare(json, json['shareAccount']);
            },
          ),
        ],
      ),
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
    final Color accent = GlassTheme.accentColor('main_course_view');
    final bool isShare = json['isShare'] == true;
    return GlassCard(
      page: 'main_course_view',
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.fromLTRB(16, 13, 12, 13),
      child: Row(
        children: [
          Expanded(
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
                          searchTxT, '${json['shareAccount']}'))),
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
          ),
          const SizedBox(width: 10),
          _actionButton(
            icon: isShare
                ? Icons.delete_outline_rounded
                : Icons.ios_share_rounded,
            color: isShare ? GlassTheme.scheme.error : accent,
            onTap: () {
              //如果分享了
              if (isShare) {
                print(json);
                state.deleteShareMeShare(
                    json, json['shareAccount']); //删除
              } else {
                // 如果没分享
                state.addShareMeShare(json, json['shareAccount']);
              }
            },
          ),
        ],
      ),
    );
  }

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
}
