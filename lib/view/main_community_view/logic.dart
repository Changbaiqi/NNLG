import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nnlg/utils/AccountUtil.dart';

import 'state.dart';

class MainCommunityViewLogic extends GetxController {
  final MainCommunityViewState state = MainCommunityViewState();
  BuildContext? context=null;


  /**
   * Lottie网格布局子组件
   */
  Widget boxChildLottie(String imgFile, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(imgFile,height: 25,width: 25,),
          Text(
            label,
            style: TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }

  /**
   * svg网格布局子组件
   */
  Widget boxChildSvg(String imgFile, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imgFile,
            height: 25,
            width: 25,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }

  /**
   * img网格布局子组件
   */
  Widget boxChildImg(String imgFile, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imgFile,
            height: 25,
            width: 25,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }



  /**
   * 用于初始化显示软件打开次数
   */
  getOnClickTotal() {
    AccountUtil().getOnclickTotal().then((value) {
      if (value['code'] == 200) {
          state.onClickTotal.value = value['msg'];
      }
    });
  }

  @override
  void onInit() {
    getOnClickTotal();
  }
}
