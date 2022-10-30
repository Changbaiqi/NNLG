import 'package:flutter/material.dart';

class XiaoBeiUser_Search extends StatefulWidget {
  const XiaoBeiUser_Search({Key? key}) : super(key: key);

  @override
  State<XiaoBeiUser_Search> createState() => _XiaoBeiUser_SearchState();
}

class _XiaoBeiUser_SearchState extends State<XiaoBeiUser_Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: MediaQuery.of(context).size.height/23,
              width: MediaQuery.of(context).size.width/1.5,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  style: TextStyle(fontSize: 15,color: Colors.white60),
                  decoration: InputDecoration(
                    hintText: "请输入对应的小北账号或者名称",

                    contentPadding: EdgeInsets.all(0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder: InputBorder.none,

                  ),
                ),),
            ),
            InkWell(
              child: Text("搜索",style: TextStyle(fontSize: 15),),
              onTap: (){

              },
            )
          ],
        ),
      ),
      body: XiaoBeiUserSearchMain(),
    );

  }
}


class XiaoBeiUserSearchMain extends StatefulWidget {
  const XiaoBeiUserSearchMain({Key? key}) : super(key: key);

  @override
  State<XiaoBeiUserSearchMain> createState() => _XiaoBeiUserSearchMainState();
}

class _XiaoBeiUserSearchMainState extends State<XiaoBeiUserSearchMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: ManageXiaoBeiUserOperationSearchList(),flex: 1,)
      ],
    );

  }
}




/**
 * 查询所展示的列表
 */
class ManageXiaoBeiUserOperationSearchList extends StatefulWidget {
  const ManageXiaoBeiUserOperationSearchList({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBeiUserOperationSearchList> createState() => _ManageXiaoBeiUserOperationSearchListState();
}

class _ManageXiaoBeiUserOperationSearchListState extends State<ManageXiaoBeiUserOperationSearchList> {

  ListView? listView;

  @override
  Widget build(BuildContext context) {
    return listView??Center(child: Text("查询"),);

  }




  Widget listChildTable(jsonMessage){

    return Card(
      child: Column(
        children: [
          Text("名称：${jsonMessage["name"]}"),
          Text("小北账号：${jsonMessage["xiaobeiAccount"]}")
        ],
      ),
    );
  }


  show(){


  }







}

