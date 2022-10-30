import 'package:flutter/material.dart';

class setXiaoBeiPlayTimeSheet{

  BuildContext? context;
  TimeOfDay _timeOfDay = TimeOfDay.now();

  setXiaoBeiPlayTimeSheet(context){
    this.context = context;
  }


  Future show(){
    return _setTime();
  }


  //用来设置打卡时间的
  Future _setTime() async{

    final TimeOfDay? picked = await showTimePicker(
      context: context!,
      initialTime: _timeOfDay,
      cancelText: "取消",
      helpText:'请设定每天想要打卡的时间',
      confirmText: '确定',
      errorInvalidText: '请输入正确的时间',
      hourLabelText: '时',
      minuteLabelText: '分',
    );

    return picked;
  }



}