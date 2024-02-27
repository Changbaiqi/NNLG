import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/utils/JustMessengerUtil.dart';
import 'package:nnlg/view/SchoolCardInformSet.dart';

import 'state.dart';

class MainCommunityViewLogic extends GetxController {
  final MainCommunityViewState state = MainCommunityViewState();
  BuildContext? context = null;

  final TextEditingController inputAccountController = TextEditingController();
  final TextEditingController inputPasswordController = TextEditingController();
  final seeNo_Off = false.obs;

  /**
   * Lottie网格布局子组件
   */
  Widget boxChildLottie(String imgFile, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(
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

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 测试宿舍选择弹窗
   * [date] 1:14 2024/2/26
   * [param] null
   * [return]
   */
  void _testPicker() {
    var multiData = {
      '桂林': {
        '7栋': [],
        '8栋': [],
        '9栋': [],
        '10A栋': [],
        '10B栋': [],
      }
    };
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 35; ++y)
        multiData['桂林']?['7栋']?.add('${x * 100 + y}');
    }
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 32; ++y)
        multiData['桂林']?['8栋']?.add('${x * 100 + y}');
    }
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 31; ++y)
        multiData['桂林']?['9栋']?.add('${x * 100 + y}');
    }

    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 13; ++y)
        multiData['桂林']?['10A栋']?.add('${x * 100 + y}');
    }

    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 13; ++y)
        multiData['桂林']?['10B栋']?.add('${x * 100 + y}');
    }

    Pickers.showMultiLinkPicker(context!, data: multiData, columeNum: 3);
  }




  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 登录一信通函数
   * [date] 1:08 2024/2/26
   * [param] null
   * [return]
   */
  loginJustMessage(String account,String password){
    JustMessengerUtil()
        .loginPost(account,password)
        .then((value) async{
      // print(value);
      if (value['resultCode'] != null) {
        if(value['message']=='Bad credentials'){
          Get.snackbar('提示', '密码错误',
              duration:const Duration(milliseconds: 1500));
          return;
        }
        Get.snackbar('提示', value['message'],
            duration:const Duration(milliseconds: 1500));
        return;
      }

      //装置token等参数
      AccountData.justMessengerAccess_Token.value =
      value['access_token'];
      AccountData.justMessengerRefresh_Toekn.value =
      value['refresh_token'];
      AccountData.justMessengerSchoolId.value = value['schoolId'];
      AccountData.justMessengerCompany.value = value['company'];
      AccountData.justMessengerExpires_in.value = value['expires_in'];
      AccountData.justMessengerToken_Type.value = value['token_type'];
      AccountData.justMessengerJti.value = value['jti'];

      //获取卡的信息
      await JustMessengerUtil().getJustMessengerCardMessage().then((value){
        //如果获取卡信息异常
        if(value['code']!=200){
          Get.snackbar('获取一信通信息提示', '${value['message']}',
              duration:const Duration(milliseconds: 1500));
          return;
        }

        state.justMessengerMoney.value = value['data'][0]['accountBlance'].toString(); //赋值金额
        state.justMessengerCardCode.value = value['data'][0]['crdId'];


      });
      // JustMessengerUtil().getMoney().then((value){
      //   // Get.snackbar("金额", '${value['data']}');
      //   state.justMessengerMoney.value = value['data'];
      // });

      Get.snackbar('提示', '登录成功',
          duration:const Duration(milliseconds: 1500));
      state.isLoginJustMessenger.value = true; //设置为成功登录状态
    });

  }



  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 没绑定时候的一信通卡片信息
   * [date] 22:51 2024/2/25
   * [param] null
   * [return]
   */
  noJustMessengerCard() {
    List<Widget> _seelist = [Image.asset('assets/images/close_eye.png',height: 25,width: 25,),Image.asset('assets/images/open_eye.png',height: 25,width: 25,)];
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              height: 55,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputAccountController,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        label: Text('账号'),
                        hintText: '请输入校园一信通账号/手机号',
                        enabledBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.all(
                          //     Radius.circular(100)
                          // )
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.all(
                          //     Radius.circular(100)
                          // )
                        ),
                      ),
                      /*onChanged: (account){
                  _account = account;
                },*/),
                  ),

                ],
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Container(
              height: 55,
              child: Row(
                children: [
                  Expanded(
                    child: Obx(()=>TextField(
                      controller: inputPasswordController,
                      obscureText: seeNo_Off.value,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        label: Text('密码'),
                        hintText: '请输入校园一信通密码',
                        enabledBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.all(
                          //     Radius.circular(100)
                          // )
                        ),
                        suffixIcon: IconButton(
                            onPressed: (){
                              seeNo_Off.value = !seeNo_Off.value;
                            },
                            icon: _seelist[seeNo_Off.value ? 0 : 1]),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.all(
                          //     Radius.circular(100)
                          // )
                        ),
                      ),
                      /*onChanged: (password){
                    _password = password;
                  },*/
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              width: MediaQuery.of(context!).size.width,
              height: 45,
              child: ElevatedButton(
                child: Text('校园一信通绑定'),
                onPressed: () {
                  //检测输入的内容是否为空
                  if(inputAccountController.text.isEmpty || inputPasswordController.text.isEmpty){
                    Get.snackbar("提示", "输入的内容不能为空",duration: const Duration(milliseconds: 1500));
                    return;
                  }

                  //登录
                  loginJustMessage(inputAccountController.text, inputPasswordController.text);
                  // _testPicker();

                },
              ),
            ),
          ),
        )
      ],
    );
  }

  /**
   * 绑定过后的一信通信息卡片
   */
  bindingJustMessengerCard() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('卡号：${state.justMessengerCardCode}'),
              Text('蒋林志'),
              Container(
                width: 60,
                height: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context!)
                        .push(MaterialPageRoute(builder: (builder) {
                      return SchoolCardInformSet();
                    }));
                  },
                  child: Text(
                    '设置',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            '￥ ${state.justMessengerMoney}',
            style: TextStyle(fontSize: 35),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              Text(
                '宿舍状态',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('绑定宿舍：'),
                  Text('8403'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('宿舍电费：'),
                  Text('40￥'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('预警金额：'), Text('20￥')],
              ),
              Container(
                width: MediaQuery.of(context!).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    // JustMessengerUtil().wxPay();
                  },
                  child: Text('刷新卡片信息'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void onInit() {
    getOnClickTotal();
  }
}
