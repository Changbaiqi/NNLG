import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class AccountData{
  static String studentName = "长白崎";
  static String studentID = "11451419";
  static String studentMajor = "计算机科学与技术";
  static final headMode = 0.obs; //0为默认图片，1为QQ图片，2为本地
  static final head_qq="".obs;
  static final head_filePath="".obs;
  static final isIdent = false.obs; //是否有认证标识
  static final identMainTag= "".obs; //主认证标识标签
  static final identMainColor="".obs; //主认证标识颜色
  static final identList= [].obs; //认证项目总表

  //一信通
  static final justMessengerUsername = "".obs; //用户名称
  static final justMessengerAccount = "".obs; //用户账号
  static final justMessengerPassword = "".obs; //用户密码
  static final justMessengerAccess_Token = "".obs; //token
  static final justMessengerRefresh_Toekn = "".obs; //不知道啥玩意
  static final justMessengerSchoolId="".obs; //学校id
  static final justMessengerCompany = "".obs;
  static final justMessengerToken_Type = "".obs;
  static final justMessengerExpires_in = 0.obs;
  static final justMessengerJti = "".obs;
  static final justMessengerMoney = "".obs; //水卡余额
  static final justMessengerCardCode = "".obs; //水卡的ID
  static final isLoginJustMessenger = false.obs; //一信通当前是否登录成功的状态
  static final justMessengerUserName = "".obs;

  static final dormCampus = "".obs; //校区
  static final dormLoudongId = "".obs; //宿舍楼栋
  static final dormRoom = "".obs; //房间ID
  static final powerMoney = "".obs; //电费金额

  static IOWebSocketChannel? channel=null;
}