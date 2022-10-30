import 'package:flutter/material.dart';
import 'package:nnlg/view/manage/XiaobeiUser_Search.dart';


class ManageXiaoBeiUserOperation extends StatefulWidget {
  const ManageXiaoBeiUserOperation({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBeiUserOperation> createState() => _ManageXiaoBeiUserOperationState();
}

class _ManageXiaoBeiUserOperationState extends State<ManageXiaoBeiUserOperation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ManageXiaoBeiUserOperationSearch(),
      ),
      body: ManageXiaoBeiUserOperationMain(),
    );
  }
}





/**
 * 主功能界面
 */
class ManageXiaoBeiUserOperationMain extends StatefulWidget {
  const ManageXiaoBeiUserOperationMain({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBeiUserOperationMain> createState() => _ManageXiaoBeiUserOperationMainState();
}

class _ManageXiaoBeiUserOperationMainState extends State<ManageXiaoBeiUserOperationMain> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [

          ],
        )
      ],
    );
  }
}





/**
 * 查询框
 */
class ManageXiaoBeiUserOperationSearch extends StatefulWidget {
  const ManageXiaoBeiUserOperationSearch({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBeiUserOperationSearch> createState() => _ManageXiaoBeiUserOperationSearchState();
}

class _ManageXiaoBeiUserOperationSearchState extends State<ManageXiaoBeiUserOperationSearch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          radius: 0,
          child: Container(
            height: 35,
            width: 300,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.black26
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Icon(Icons.search,color: Colors.white60,),
                  Center(child: Text("点击此处搜索用户",style: TextStyle(fontSize: 13,color: Colors.white60),),)
                ] ,
              ),),
          ),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (builder){return XiaoBeiUser_Search();}));
          },
        )
      ],
    );
  }
}


/**
 * 用户信息展示
 */
class XiaoBeiUserMessageShowCard extends StatefulWidget {
  const XiaoBeiUserMessageShowCard({Key? key}) : super(key: key);

  @override
  State<XiaoBeiUserMessageShowCard> createState() => _XiaoBeiUserMessageShowCardState();
}

class _XiaoBeiUserMessageShowCardState extends State<XiaoBeiUserMessageShowCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


/**
 * 一键用户打卡
 */


/**
 * 用户定位修改
 */


/**
 * 用户每日打卡时间修改
 */

/**
 * 用户自动打卡开通时间定义修改
 */


/**
 * 用户自动体温开关
 */


/**
 * 用户自动打卡开关(管理员最高级控制)
 */


/**
 *
 */








