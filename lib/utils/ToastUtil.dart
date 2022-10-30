
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil{

  static show(text,{showTime,showLocal,showWebTime,bColor,textColor,textSize}){

    Fluttertoast.showToast(
        msg: text ?? '',
        toastLength:  showTime ?? Toast.LENGTH_SHORT,
        gravity: showLocal ?? ToastGravity.TOP,
        timeInSecForIosWeb: showWebTime ?? 1,
        backgroundColor: bColor ?? Colors.black45,
        textColor: textColor ?? Colors.white,
        fontSize: textSize ?? 16.0
    );

  }

}