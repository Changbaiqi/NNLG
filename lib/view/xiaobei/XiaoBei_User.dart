import 'package:flutter/material.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/XiaoBeiData.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/utils/XiaoBeiUserUtil.dart';
import 'package:nnlg/view/xiaobei/XiaoBei_Login.dart';

class XiaoBei_User extends StatefulWidget {
  const XiaoBei_User({Key? key}) : super(key: key);

  @override
  State<XiaoBei_User> createState() => _XiaoBei_UserState();
}

class _XiaoBei_UserState extends State<XiaoBei_User> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          XiaoBei_User_MessageCard(),
          XiaoBei_User_Notice()
        ],
      ),
    );
  }
}


//用户信息卡片------------------------------------------------
class XiaoBei_User_MessageCard extends StatefulWidget {
  const XiaoBei_User_MessageCard({Key? key}) : super(key: key);

  @override
  State<XiaoBei_User_MessageCard> createState() => _XiaoBei_User_MessageCardState();
}

class _XiaoBei_User_MessageCardState extends State<XiaoBei_User_MessageCard> {

  String? name='点击此处绑定账号';
  String? openTime = '开通时间：0000年00月00日 至 9999年99月99日';

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        height: 180,
        child: Stack(
          children: [

            InkWell(
              child: Container(
                margin: EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0),
                height: 150,
                width: MediaQuery.of(context).size.width/1,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0,7.0),
                          blurRadius: 14.0,
                          spreadRadius: 0,
                          color:Color(0xFFdfdfdf)
                      )
                    ]
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 15,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.asset('images/user.jpg',height: 80,width: 80,),
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${name}',style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                )
                              ],
                            ),

                          ],
                        ))
                  ],
                ),
              ),
              onTap: (){
                if(name=="点击此处绑定账号"){
                  XiaoBei_Login xl = XiaoBei_Login(context);
                  xl.show();
                  xl.show().then((value){
                    if(value["code"]==200){
                      XiaoBeiUserUtil().getBindXiaoBeiAccountAndPassword().then((value){
                        setState((){
                          name = value["data"]["xiaoBeiAccount"];
                          XiaoBeiData.xiaobeiAccount=value["data"]["xiaoBeiAccount"];
                          XiaoBeiData.xiaobeiPassword = value["data"]["xiaoBeiPassword"];
                        });
                      });
                      ToastUtil.show('绑定成功');
                    }
                  });

                  return;
                }
                XiaoBei_Login xl = XiaoBei_Login(context);
                xl.setDefaultActAndPws('${XiaoBeiData.xiaobeiAccount}','${XiaoBeiData.xiaobeiPassword}');
                xl.show().then((value){
                  if(value["code"]==200){
                    XiaoBeiUserUtil().getBindXiaoBeiAccountAndPassword().then((value){
                      setState((){
                        name = value["data"]["xiaoBeiAccount"];
                        XiaoBeiData.xiaobeiAccount=value["data"]["xiaoBeiAccount"];
                        XiaoBeiData.xiaobeiPassword = value["data"]["xiaoBeiPassword"];
                      });
                    });
                    ToastUtil.show('修改成功');
                  }
                });

              },
            ),

            Positioned(
                top: 120,
                left: 25,
                right: 25,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 50,
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        //border: Border.all(width: 1,)
                      ),
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Center(child: Text('${openTime}',style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight: FontWeight.w900,),),),
                      ),
                    )))


          ],
        ),


      )
      ,
    );
  }

  @override
  void initState() {
    initBindAccount();
    initOpenStartAndEndTime();
  }





  initBindAccount(){
    XiaoBeiUserUtil().getBindXiaoBeiAccountAndPassword().then((value){
      //print('${value}');

      String? account = value["data"]["xiaoBeiAccount"].toString();

      //判断服务端的账号和密码是否为空
      if(account.isEmpty || account==null){
        return;
      }

      //刷新UI显示的用户
      setState((){
        name = value["data"]["xiaoBeiAccount"];
        XiaoBeiData.xiaobeiAccount=value["data"]["xiaoBeiAccount"];
        XiaoBeiData.xiaobeiPassword = value["data"]["xiaoBeiPassword"];
      });

    });
  }


  initOpenStartAndEndTime(){
    XiaoBeiUserUtil().getOpenStartAndEndTime().then((value){
      if(value["code"]==200){
        setState((){
          openTime = '开通时间：${value["data"]}';
        });

      }


    });
  }



}


/**
 * 公告
 */
class XiaoBei_User_Notice extends StatefulWidget {
  const XiaoBei_User_Notice({Key? key}) : super(key: key);

  @override
  State<XiaoBei_User_Notice> createState() => _XiaoBei_User_NoticeState();
}

class _XiaoBei_User_NoticeState extends State<XiaoBei_User_Notice> {

  String? noticeText='加载中...';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 30),
      height: MediaQuery.of(context).size.height/1.7,
      width: MediaQuery.of(context).size.width/2.4,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0,7.0),
                blurRadius: 14.0,
                spreadRadius: 0,
                color:Color(0xFFdfdfdf)
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 10, 0),
            child: Text('公告',style: TextStyle(fontSize: 25),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width/1.25,
              color: Colors.black26,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 20, 50),
            child: Text('${noticeText}',style: TextStyle(fontSize: 15),),
          )

        ],
      ),
    );
  }


  @override
  void initState() {
    initNoticeText();
  }

  //初始化公告文本
  initNoticeText(){
    XiaoBeiUserUtil().getXiaoBeiNotice().then((value){
      if(value["code"]==200){
        setState((){
          noticeText = value["data"]["noticeText"];
        });
      }
    });
  }



}



