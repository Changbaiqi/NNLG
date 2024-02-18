import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/status.dart';

import 'logic.dart';

class CourseSharedViewPage extends StatelessWidget {
  CourseSharedViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedViewLogic>();
  final state = Get.find<CourseSharedViewLogic>().state;

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
                    child: Text('共享'),
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 0, 50, 0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: Colors.black38, width: 2.0)),),
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
          elevation: 0,
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
        )));
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
   * [description] TODO 账号资料卡片
   * [date] 20:46 2024/2/11
   * [param] null
   * [return]
   */
  Widget accountCard(json) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Card(
        child: Container(
            // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 85,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('姓名：${json['studentName']}'),
                          Text('学号：${json['shareAccount']}'),
                          Text('专业班级：${json['studentClass']}'),
                        ],
                      ),
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 88,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight:
                                                Radius.circular(10))))),
                            onPressed: () {
                              state.deleteShareMeShare(
                                  json, json['shareAccount']);
                            },
                            child: Icon(Icons.delete)),
                      )
                    ],
                  ),
                )
              ],
            )),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Card(
        child: Container(
            // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 85,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 88,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(
                                  json['isShare']
                                      ? Colors.red
                                      : Colors.blueAccent),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))))),
                          onPressed: () {
                            //如果分享了
                            if (json['isShare']) {
                              print(json);
                              state.deleteShareMeShare(
                                  json, json['shareAccount']); //删除
                            } else {
                              // 如果没分享
                              state.addShareMeShare(json, json['shareAccount']);
                            }
                          },
                          child: json['isShare']
                              ? Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                                children: [
                              TextSpan(
                                  text: '姓名：',
                                  style: TextStyle(color: Colors.black))
                            ]..addAll(buildText(
                                    searchTxT, '${json['studentName']}'))),
                          ),
                          RichText(
                            text: TextSpan(
                                children: [
                              TextSpan(
                                  text: '学号：',
                                  style: TextStyle(color: Colors.black))
                            ]..addAll(buildText(
                                    searchTxT, '${json['shareAccount']}'))),
                          ),
                          RichText(
                            text: TextSpan(
                                children: [
                              TextSpan(
                                  text: '专业年级：',
                                  style: TextStyle(color: Colors.black))
                            ]..addAll(buildText(
                                    searchTxT, '${json['studentClass']}'))),
                          ),
                          // Text('姓名：${json['studentName'] ?? ''}'),
                          // Text('学号：${json['shareAccount'] ?? ''}'),
                          // Text('专业班级：${json['studentClass'] ?? ''}'),
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }

  List<TextSpan> buildText(String searchTxT, String dataTxt) {
    List<TextSpan> list = [];
    List<String> strList = dataTxt.split('${searchTxT}');
    for (int i = 0; i < strList.length; ++i) {
      list.add(TextSpan(
          text: '${strList[i]}', style: TextStyle(color: Colors.black)));
      if (i != strList.length - 1)
        list.add(TextSpan(
            text: '${searchTxT}',
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w900)));
    }
    return list;
  }
}
