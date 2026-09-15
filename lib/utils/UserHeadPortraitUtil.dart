import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:callo/dao/AccountData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:path_provider/path_provider.dart';

/// 更换头像弹窗：毛玻璃 + 渐变风格
class UserHeadPortraitUtil {
  BuildContext? _context;

  UserHeadPortraitUtil(context) {
    this._context = context;
  }

  Future setHead() async {
    return await showDialog(
        context: _context!,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (BuildContext buildContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: GlassCard(
              page: 'main_user_view',
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: const _UserHeadPortraitUtil_Win(),
            ),
          );
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
  static const String _page = 'main_user_view';

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return SizedBox(
      height: 280,
      child: Column(
        children: [
          GlassSectionTitle(page: _page, title: '更换头像'),
          const SizedBox(height: 6),
          TabBar(
            controller: _tabController,
            labelColor: accent,
            unselectedLabelColor: text.withValues(alpha: .55),
            indicatorColor: accent,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'QQ头像'),
              Tab(text: '本地图片'),
            ],
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              _qqImageWidget(),
              _fileImageWidget(),
            ]),
          ),
        ],
      ),
    );
  }

  _qqImageWidget() {
    final Color text = GlassTheme.textColor(_page);
    TextEditingController qqInput = TextEditingController();
    StateSetter? ss;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            style: TextStyle(color: text),
            decoration: InputDecoration(
                icon: StatefulBuilder(
                  builder: (context, setInnerState) {
                    ss = setInnerState;
                    return Image.network(
                      'https://q1.qlogo.cn/g?b=qq&nk=${qqInput.text}&s=640',
                      height: 35,
                      width: 35,
                      errorBuilder: (context, e, stack) {
                        return Icon(Icons.account_circle_rounded,
                            color: text.withValues(alpha: .6));
                      },
                    );
                  },
                ),
                hintText: '请输入QQ号',
                hintStyle: TextStyle(color: text.withValues(alpha: .45))),
            onChanged: (str) {
              qqInput.text = str;
              ss!(() {});
            },
          ),
        ),
        const Spacer(),
        GradientButton(
          text: '确定',
          page: _page,
          height: 44,
          onPressed: () async {
            await ShareDateUtil().setAccountHeadQQ(qqInput.text);
            await ShareDateUtil().setAccountHeadMode(1);
            Get.snackbar("头像修改", "修改成功",
                duration: const Duration(milliseconds: 1500));
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  final ImagePicker picker = ImagePicker();

  _fileImageWidget() {
    return Column(
      children: [
        const Spacer(),
        GradientButton(
          text: '选择图片',
          icon: Icons.photo_library_rounded,
          page: _page,
          height: 44,
          onPressed: () {
            _getImage();
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Future<String> getFileHash(String filePath) async {
    final file = File(filePath);

    final fileBytes = file.readAsBytesSync().buffer.asUint8List();
    final hash = md5.convert(fileBytes.buffer.asUint8List()).toString();
    return hash;
  }

  Future _getImage() async {
    final pickerImages = await picker.pickImage(source: ImageSource.gallery);
    if (pickerImages != null) {
      File _imgPath = File(pickerImages.path);
      String fileName = await getFileHash(pickerImages.path);
      await getApplicationDocumentsDirectory().then((value) async {
        if (AccountData.head_filePath.value != "") {
          await File(AccountData.head_filePath.value).delete();
        }
        _imgPath.copy(value.path + '/user_${fileName}.jpg');
        await ShareDateUtil()
            .setAccountHeadFilePath(value.path + '/user_${fileName}.jpg');
        await ShareDateUtil().setAccountHeadMode(2);
      });
    } else {
      print('没有照片可以选择');
    }
  }
}
