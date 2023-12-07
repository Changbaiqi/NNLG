import 'dart:async';


import 'package:get/get.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/LoginUtil.dart';
import 'package:nnlg/utils/MainUserUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'state.dart';

class StartViewLogic extends GetxController {
  final StartViewState state = StartViewState();

  @override
  void onInit() {
    toClick();
    ShareDateUtil().initLoading().then((value) async {
      //print('${CourseData.nowWeek}');

      if(LoginData.autoLogin.value && LoginData.account.isNotEmpty && LoginData.password.isNotEmpty ){


        //自动登录用的
        LoginUtil.turnSubmit(LoginData.account,LoginData.password).then((value){
          //debugPrint(value);

          //记住账号密码
          LoginUtil().LoginPost(value).then((value) async {
            if(value==302){
              ToastUtil.show('登录成功');

              //进行完课表拉取后然后进行对应课表数据拉取刷新
              Future.wait([
                CourseUtil().getSemesterCourseList(),
                CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList.value}")
              ]).then((value){
              });


              //服务器功能上线
              MainUserUtil()
                  .vipLogin('${LoginData.account}',
                  '${LoginData.password}')
                  .then((value) {
                if (value["code"] == 400) {
                  ToastUtil.show('${value["msg"]}');
                  return;
                }

                if (value["code"] == 200) {
                  ContextDate.ContextVIPTken = value["token"];
                }
              });

              toMain();
            }else{

              ToastUtil.show('登录失败，请检查一下账号或密码是否正确');
              toLogin();
            }
          });

        });

      }else{
        toLogin();
      }

    });
  }




  void toLogin()  {
    Timer timer = Timer(Duration(seconds: 1), () {
      Get.offNamed(Routes.Login);
    });
  }

  void toMain() {
    Timer timer = Timer(Duration(seconds: 1), () {
      Get.offNamed(Routes.Main);
    });
  }

  /**
   * 用于统计软件点击次数
   */
  void toClick(){
    AccountUtil().toOnclickTotal();
  }
}
