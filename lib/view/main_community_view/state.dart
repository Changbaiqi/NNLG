import 'package:get/get.dart';

class MainCommunityViewState {
  final onClickTotal = 0.obs;

  final isLoginJustMessenger = false.obs; //是否登录了一信通
  final justMessengerMoney = "".obs; // 一信通所剩金额
  final justMessengerCardCode = "".obs; //一信通卡号
  final justMessengerUserName = "".obs; //一信通对应用户名称
  final isBindDorm = false.obs; //是否绑定了宿舍
  final dormDong = "".obs; //宿舍楼栋
  final dormRoom ="".obs; //宿舍房号
  

  MainCommunityViewState() {
    ///Initialize variables
  }
}
