import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/PowerDormUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';

import '../../dao/LoginData.dart';
import '../../utils/MainUserUtil.dart';

class showBindPowerDialog extends Dialog{

  final List<String> _animals = ['7栋','8栋', '9栋','10A栋', '10B栋'];
  String? _selectRoom;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
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

  final List<String> _dong = ['7栋','8栋', '9栋','10A栋', '10B栋'];

  bool _sw = false; //预警开关
  String? _selectDong; //栋号选择

  //房号输入
  TextEditingController _roomEdit = TextEditingController();
  //邮箱输入
  TextEditingController _emailEdit = TextEditingController();
  //预警金额
  TextEditingController _dormEdit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _loadData(),
        builder: (context,snapshot){

          print(snapshot.connectionState);
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('加载中...'),);
          }else{
            return _loadAC();
          }

        },
      ),
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


        this._selectDong = value['data']['power_bind_dong'];
        this._roomEdit.text = value['data']['power_bind_room'];
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
            child: Text('宿舍电费预警',style: TextStyle(fontSize: 20),),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 50,
                child: StatefulBuilder(
                  builder: (context,setState){
                    return DropdownButton<String>(
                        value: _selectDong,
                        items: _dong.map((e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(e),
                            ))).toList(),
                        onChanged: (value) {
                            _selectDong = value;
                            setState((){});
                        });
                  },
                ),
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _roomEdit,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))//设置只能输入数字
                  ],
                  decoration: InputDecoration(
                    label: Text('房号'),
                    hintText: '请输入除栋号后的房号',
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                child: Text('E-mail：'),
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _emailEdit,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text('绑定邮箱'),
                    hintText: '请输入预警信息接收的邮箱',
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
                child: Text('预警金额：'),
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _dormEdit,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  decoration: InputDecoration(
                    label: Text('预警金额'),
                    hintText: '请输入触发预警的金额',
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('是否开启预警：'),
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
                  child: Text('确认'),
                  onPressed: (){
                    if(_checkAll()){

                      PowerDormUtil().setBindDorm(_selectDong!, _roomEdit.text,
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
                      backgroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                  child: Text('取消',style: TextStyle(color: Colors.black45),),
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
    String? roomT = _roomEdit.text;
    String? emailT = _emailEdit.text;
    String? dormT = _dormEdit.text;
    //检查是否选择了楼栋
    //print('${_selectDong}');
    if( _selectDong==null){
      ToastUtil.show('请选择楼栋');
      return false;
    }
    //检查是否输入了房号
    if(roomT== null || roomT.isEmpty || roomT==''){
      ToastUtil.show('请输入房号');
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





}

