import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CustomThemeData.dart';
import 'package:nnlg/utils/CustomerThemeUtil.dart';
import 'package:nnlg/utils/PowerDormUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';

import '../../dao/LoginData.dart';
import '../../utils/MainUserUtil.dart';

class showBindPowerDialog extends Dialog{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        // color: Colors.white,
        color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List)
      ),
      child: showBindPowerDialogMain(),
    );
  }





}




class showBindPowerDialogMain extends StatefulWidget {
  const showBindPowerDialogMain({Key? key}) : super(key: key);

  @override
  State<showBindPowerDialogMain> createState() => _showBindPowerDialogMainState();
}

class _showBindPowerDialogMainState extends State<showBindPowerDialogMain> {




  FixedExtentScrollController _controller = FixedExtentScrollController();



  bool _sw = false; //预警开关
  // String? _selectDong; //栋号选择

  final selectData = <dynamic>['无','无','无'].obs;
  //房号输入
  // TextEditingController _roomEdit = TextEditingController();
  //邮箱输入
  TextEditingController _emailEdit = TextEditingController();
  //预警金额
  TextEditingController _dormEdit = TextEditingController();
  var future;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List),
      resizeToAvoidBottomInset: false,
      body: MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: FutureBuilder(
        future: future,
        builder: (context,snapshot){

          print(snapshot.connectionState);
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('加载中...',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),);
          }else{
            return _loadAC();
          }

        },
      ),),
    );
  }

    Future _loadData() async {
    //检测远程端是否登录
    if(ContextDate.ContextVIPTken==''){
      await MainUserUtil()
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
    }

    return PowerDormUtil().getBindDorm().then((value){
      print('${value}');
      if(value['code']==200){


        // this._selectDong = _showValue[value['data']['power_bind_dong']];
        selectData.value[0] = value['data']['power_bind_campus'].toString();
        selectData.value[1]=value['data']['power_bind_dong'].toString();
        // this._roomEdit.text = value['data']['power_bind_room'];
        selectData.value[2]=value['data']['power_bind_room'].toString();
        this._emailEdit.text= value['data']['power_bind_email'];
        this._sw = value['data']['power_dorm_sw']==1?true:false;
        this._dormEdit.text ="${value['data']['power_min_money']}";
        //this._dormEdit.text= '12.1';
        //
        return '成功';
      }else if(value['code']==400){
        ToastUtil.show(value['msg']);
      }

    });
    // return Future.delayed(Duration(seconds: 3),(){
    //   return "cc";
    // });
  }

  Widget _loadAC(){
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text('宿舍电费预警',style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ],
          ),
          Column(
            children: [
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('校区',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
                      Text('${selectData[0]}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),)
                    ],
                  ),
                  Column(
                    children: [
                      Text('楼栋',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
                      Text('${selectData[1]}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),)
                    ],
                  ),
                  Column(
                    children: [
                      Text('房号',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
                      Text('${selectData[2]}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),)
                    ],
                  )
                ],
              )),
             Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Container(
               height: 35,
               width: 250,
               child:  ElevatedButton(onPressed: (){dormPicker();},style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['foregroundColor'] as List))), child: Text('选择预警宿舍',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),)),
             ),)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                child: Text('E-mail：',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _emailEdit,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),
                  decoration: InputDecoration(
                    label: Text('绑定邮箱',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
                    hintText: '请输入预警信息接收的邮箱',
                    hintStyle: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['hintTextColor'] as List))
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                child: Text('预警金额：',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _dormEdit,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['hintTextColor'] as List)),
                    label: Text('预警金额',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
                    hintText: '请输入触发预警的金额',
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('是否开启预警：',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
              StatefulBuilder(builder: (context,setState){

                return Switch(value: _sw, onChanged: (bool value){
                      _sw=value;
                      setState((){});
                  });
              })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 120,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['foregroundColor'] as List))
                  ),
                  child: Text('确认',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
                  onPressed: (){
                    if(_checkAll()){

                      PowerDormUtil().setBindDorm(selectData.value[0],selectData.value[1], selectData.value[2],
                          _emailEdit.text, double.parse(_dormEdit.text==null?"10":"${_dormEdit.text}"), _sw?1:0).then((value){
                         if(value['code']==200){
                           ToastUtil.show('设置成功');
                         } else if(value['code']==400){
                           ToastUtil.show('设置失败');
                         }
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              Container(
                width: 120,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['foregroundColor'] as List))
                  ),
                  child: Text('取消',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List)),),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /**
   * 综合检测条件合格
   */
  bool _checkAll(){
    // String? roomT = _roomEdit.text;
    String? emailT = _emailEdit.text;
    String? dormT = _dormEdit.text;
    //检查是否选择了楼栋
    //print('${_selectDong}');
    // if( _selectDong==null){
    //   ToastUtil.show('请选择楼栋');
    //   return false;
    // }
    //检查是否输入了房号
    // if(roomT== null || roomT.isEmpty || roomT==''){
    //   ToastUtil.show('请输入房号');
    //   return false;
    // }
    if(selectData[0]=='无' || selectData[1]=='无' || selectData[2]=='无'){
      ToastUtil.show('请选择预警宿舍');
      return false;
    }
    //检查是否填写了邮箱
    if(emailT== null || emailT.isEmpty|| emailT==''){
      ToastUtil.show('请输入邮箱不能为空');
      return false;
    }
    //检查邮箱格式
    if(!_checkEmail(emailT)){
      ToastUtil.show('请输入正确的邮箱');
      return false;
    }

    //检查是否输入了金额
    if(dormT== null || dormT.isEmpty || dormT==''){
      ToastUtil.show('请输入预警金额');
      return false;
    }

    return true;
  }

  /**
   * 检验是否为邮箱
   */
  bool _checkEmail(String input){
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(regexEmail).hasMatch(input);
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 宿舍选择弹窗
   * [date] 1:14 2024/2/26
   * [param] null
   * [return]
   */
  List<dynamic> dormPicker()  {
    var multiData = {
      '桂林': {
        '7栋': [],
        '8栋': [],
        '9栋': [],
        '10A栋': [],
        '10B栋': [],
        '12栋': [],
        '13栋': [],
        '14A栋': [],
        '14B栋': [],
      },
      '南宁': {
        '13-1栋': [],
        '13-2栋': [],
        '15-1栋': [],
        '15-2栋': [],
        '17栋': [],
        '18栋': [],
        '19栋': [],
        '20栋': [],
        '21栋': [],
      }
    };
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 35; ++y) {
        multiData['桂林']?['7栋']?.add('${x * 100 + y}');
        multiData['桂林']?['8栋']?.add('${x * 100 + y}');
        multiData['桂林']?['9栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10A栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10B栋']?.add('${x * 100 + y}');
        multiData['桂林']?['12栋']?.add('${x * 100 + y}');
      }
    }
    //桂林13栋
    for (int j = 1; j <= 9; ++j)
      for (int i = 1; i <= 8; ++i)
        multiData['桂林']?['13栋']?.add('${j * 100 + i}');
    for (int i = 1001; i <= 1008; ++i) multiData['桂林']?['13栋']?.add('${i}');
    for (int i = 1101; i <= 1108; ++i) multiData['桂林']?['13栋']?.add('${i}');
    for (int i = 1001; i <= 1008; ++i) multiData['桂林']?['13栋']?.add('${i}');
    //桂林14A栋
    for (int j = 1; j <= 6; ++j)
      for (int i = 1; i <= 64; ++i)
        multiData['桂林']?['14A栋']?.add('${j * 1000 + i}');
    //桂林14B栋
    for (int i = 1066; i <= 1141; ++i) multiData['桂林']?['14B栋']?.add('${i}');
    for (int j = 2; j <= 6; ++j)
      for (int i = 64; i <= 139; ++i)
        multiData['桂林']?['14B栋']?.add('${j * 1000 + i}');

    //南宁校区----



    //13-2栋
    for (int j = 1; j <= 9; ++j){
      for (int i = 40; i <= 88; ++i) {
        multiData['南宁']?['13-2栋']?.add('${j * 100 + i}');
      }
    }
    for (int i = 38; i <= 288; ++i) {
      multiData['南宁']?['13-2栋']?.add('${1000 + i}');
    }
    //15-1
    for (int j = 1; j <= 6; ++j) {
      for (int i = 1; i <= 47; ++i) {
        multiData['南宁']?['15-1栋']?.add('${j * 100 + i}');
      }
    }
    //15-2栋
    for (int i = 33; i <= 68; ++i){ multiData['南宁']?['15-2栋']?.add('${100 + i}');}
    for (int j = 2; j <= 6; ++j){
      for (int i = 49; i <= 84; ++i) {
        multiData['南宁']?['15-2栋']?.add('${j * 100 + i}');
      }
    }

    //13-1、17、20、21栋
    for (int j = 1; j <= 9; ++j) {
      for (int i = 1; i <= 36; ++i) {
        multiData['南宁']?['13-1栋']?.add('${j * 100 + i}');
        multiData['南宁']?['17栋']?.add('${j * 100 + i}');
        multiData['南宁']?['20栋']?.add('${j * 100 + i}');
        multiData['南宁']?['21栋']?.add('${j * 100 + i}');
      }
    }
    for (int i = 1; i <= 236; ++i) {
      multiData['南宁']?['13-1栋']?.add('${1000 + i}');
      multiData['南宁']?['17栋']?.add('${1000 + i}');
      multiData['南宁']?['20栋']?.add('${1000 + i}');
      multiData['南宁']?['21栋']?.add('${1000 + i}');
    }
    //18、19栋
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 47; ++y) {
        multiData['南宁']?['18栋']?.add('${x * 100 + y}');
        multiData['南宁']?['19栋']?.add('${x * 100 + y}');
      }
    }

    Pickers.showMultiLinkPicker(context, data: multiData,selectData: selectData,pickerStyle: PickerStyle(
      backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List),
      textColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List),
      headDecoration: BoxDecoration(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List))
    ), columeNum: 3,onConfirm: (p,covariant) async{

      selectData.value = p ;
      selectData.refresh();
    });
    return selectData;
  }

  @override
  void initState() {
    future = _loadData();
  }
}

