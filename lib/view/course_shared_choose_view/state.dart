import 'package:get/get.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart';
import 'package:nnlg/web/ShareCourseWeb.dart';

class CourseSharedChooseViewState {

  final accountList = [].obs;
  CourseSharedChooseViewState() {
    ///Initialize variables
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 用于初始化获取共享课表的账号数据
   * [date] 3:46 2024/2/11
   * [param] null
   * [return]
   */
  initGetSharedAccountList() async {
    await ShareCourseWeb().getShareAccountList().then((ShareCourseAccountModel model){
      if(model.code!=200)
        Get.snackbar(
          "异常通知",
          "${model.message}",
          duration: Duration(milliseconds: 1500),
        );
      accountList.value = model.data!.shareAccountList!;
    });
  }
}
