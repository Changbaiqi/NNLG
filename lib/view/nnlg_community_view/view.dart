import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CustomThemeData.dart';
import 'package:nnlg/utils/CustomerThemeUtil.dart';
import 'package:nnlg/view/nnlg_community_view/CustomFloatingActionButtonLocation.dart';

import 'logic.dart';

class NnlgCommunityViewPage extends StatelessWidget {
  NnlgCommunityViewPage({Key? key}) : super(key: key);

  final logic = Get.put(NnlgCommunityViewLogic());
  final state = Get.find<NnlgCommunityViewLogic>().state;
  final isClose = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['nnlg_community_view']!['backgroundColor'] as List ),
      floatingActionButton: FloatingActionButton(
        child: Text('发布'),
        onPressed: (){

        },
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat,1,-90),
      body: isClose.value?Container(child: Center(child: Text('暂未开放，敬请期待',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['nnlg_community_view']!['textColor'] as List )),),),):Column(
        children: [
          Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  topCommunityMode('趣事板块',true),
                  topCommunityMode('计算机板块',false),
                  topCommunityMode('抽象人板块',false),
                  topCommunityMode('小作文板块',false)
                ],
              )
          ),
          Expanded(child: ListView(
            children: [
              articleCard('用户1','世上无BUG',DateTime.now()),
              articleCard('用户1','牛魔',DateTime.now()),
              articleCard('用户1','世上无BUG',DateTime.now()),
              articleCard('用户1','牛魔',DateTime.now()),
              articleCard('用户1','世上无BUG',DateTime.now()),
              articleCard('用户1','世上无BUG',DateTime.now()),
              articleCard('用户1','牛魔',DateTime.now()),
              articleCard('用户1','世上无BUG',DateTime.now())
            ],
          ),flex: 1,)
        ],
      ),
    );
  }
  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 顶部社区模块
   * [date] 14:50 2024/9/6
   * [param] null
   * [return]
   */
  topCommunityMode(String title,isSelect){
    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 0, 10),child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          color: isSelect?Colors.black38:Colors.black12,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Stack(
        children: [
          Align(child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(50)
            ),
          ),alignment: Alignment.center,),
          Align(child: SvgPicture.asset('assets/images/fun.svg',height: 40,width: 40,),alignment: Alignment.center,),
          Align(child: Text('$title'),alignment: Alignment.bottomCenter,)
        ],
      ),
    ),);
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 文章卡片
   * [date] 14:49 2024/9/6
   * [param] null
   * [return]
   */
  articleCard(String userName,String content,DateTime issueTime){
    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),child: Card(
      child: Container(
        height: 150,
        width: 100,
        child: Stack(
          children: [
            Positioned(child: ClipOval(child: SvgPicture.asset('assets/images/fun.svg',height: 30,width: 30,),),left: 10,top: 10,),
            Positioned(child: Text('$userName'),left: 50,top: 15,),
            Positioned(child: Container(height: 60,width: Get.width*0.85,
              decoration: BoxDecoration(
                  // color: Colors.black12
              ),
            child: Text('$content'),
            ),top: 50,left: 10,),
            Positioned(child: Container(
              width: 200,
              child: Row(
                children: [
                  Text('发布时间：${issueTime.year}-${issueTime.month}-${issueTime.day}-${issueTime.hour}-${issueTime.minute}',style: TextStyle(color: Colors.black45),)
                ],
              ),
            ),left: 10,top: 120,),
            Positioned(child: Container(
              width: 50,
              child: Row(
                children: [
                  Text('点赞')
                ],
              ),
            ),right: 10,top: 120,)
          ],
        ),
      ),
    ),);
  }
}
