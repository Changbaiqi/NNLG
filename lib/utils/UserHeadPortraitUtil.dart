import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:path_provider/path_provider.dart';

class UserHeadPortraitUtil {
  BuildContext? _context;

  UserHeadPortraitUtil(context) {
    this._context = context;
  }

  Future setHead() async {
    return await showDialog(
        context: _context!,
        builder: (BuildContext buildContext) {
          return Dialog(
              child: Container(
            height: 210,
            child: _UserHeadPortraitUtil_Win(),
          ));
        });
  }
}

class _UserHeadPortraitUtil_Win extends StatefulWidget {
  const _UserHeadPortraitUtil_Win({Key? key}) : super(key: key);

  @override
  State<_UserHeadPortraitUtil_Win> createState() =>
      _UserHeadPortraitUtil_WinState();
}

class _UserHeadPortraitUtil_WinState extends State<_UserHeadPortraitUtil_Win>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          isScrollable: false,
          tabs: [
            Tab(
              text: 'QQ头像',
            ),
            Tab(
              text: '本地图片',
            )
          ],
        ),
      ),
      body: Container(
        height: 150,
        child: Column(
          children: [
            Container(
              height: 140,
              child: TabBarView(controller: _tabController, children: [
                _qqImageWidget(),
                _fileImageWidget(),
              ]),
            )
          ],
        ),
      ),
    );
  }

  _qqImageWidget() {
    TextEditingController qqInput = TextEditingController();
    StateSetter? ss;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              decoration: InputDecoration(
                  icon: StatefulBuilder(
                    builder: (context, setInnerState) {
                      ss = setInnerState;
                      return Image.network(
                        'https://q1.qlogo.cn/g?b=qq&nk=${qqInput.text}&s=640',
                        height: 35,
                        width: 35,
                        errorBuilder: (context, e, stack) {
                          return Icon(Icons.account_circle_rounded);
                        },
                      );
                    },
                  ),
                  hintText: '请输入QQ号 '),
              onChanged: (str) {
                qqInput.text = str;
                ss!(() {});
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  child: Text("确定"),
                  onPressed: () async {
                    await ShareDateUtil().setAccountHeadQQ(qqInput.text);
                    await ShareDateUtil().setAccountHeadMode(1);
                    Get.snackbar("头像修改", "修改成功",duration: Duration(milliseconds: 1500),);
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }

  final ImagePicker picker = ImagePicker();

  _fileImageWidget() {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
              child: Text("选择图片"),
              onPressed: () {
                _getImage();
                Navigator.pop(context);
                //
              })
        ],
      ),
    );
  }

  Future _getImage() async {
    final pickerImages = await picker.pickImage(source: ImageSource.gallery);
    // if (mounted) {
      if (pickerImages != null) {
        File _imgPath = File(pickerImages.path);
        await getApplicationDocumentsDirectory().then((value) async {
          _imgPath.copy(value.path + "/user.jpg");
          print("读取：" + AccountData.head_filePath.value);
          print("地址：" + value.path + "/user.jpg");
          await ShareDateUtil()
              .setAccountHeadFilePath(value.path + "/user.jpg");
          await ShareDateUtil().setAccountHeadMode(2);
        });

        //Navigator.pop(context,pickerImages.path);
      } else {
        print('没有照片可以选择');
      }
    }
  // }
}
