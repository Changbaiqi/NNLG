import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/ContextData.dart';
import 'package:callo/dao/LoginData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/HexColor.dart';
import 'package:callo/utils/MainUserUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:callo/utils/UserHeadPortraitUtil.dart';
import 'package:callo/view/VIPFunList.dart';
import 'package:callo/view/module/showUpdateDialog.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

/// 我的页面：毛玻璃 + 渐变风格
class MainUserViewPage extends StatelessWidget {
  MainUserViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainUserViewLogic());
  final state = Get.find<MainUserViewLogic>().state;

  static const String _page = 'main_user_view';

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ShowCaseWidget(
          builder: (showCaseContext) {
            logic.showCaseContext = showCaseContext;
            return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 44, 16, 130),
                  children: [
                    _profileCard(context),
                    const SizedBox(height: 18),
                    GlassSectionTitle(page: _page, title: '设置'),
                    const SizedBox(height: 10),
                    _entry(
                      title: '关于软件和作者',
                      svg: 'assets/images/about.svg',
                      onTap: () => Get.toNamed(Routes.AboutMe),
                    ),
                    _entry(
                      title: '设置、账号安全及隐私',
                      svg: 'assets/images/safe.svg',
                      onTap: () => Get.toNamed(Routes.AccountSafe),
                    ),
                    _entry(
                      title: '探索新版',
                      image: 'assets/images/bbgx.png',
                      onTap: () {
                        showUpdateDialog.isLastVersion().then((value) {
                          if (value == true) {
                            Get.snackbar(
                              "更新提示",
                              "已经是最新版啦(～￣▽￣)～ ",
                              duration: const Duration(milliseconds: 1500),
                            );
                          } else {
                            showUpdateDialog.autoDialog(context, -1);
                          }
                        });
                      },
                    ),
                    _entry(
                      title: '退出登录',
                      image: 'assets/images/backLogin.png',
                      danger: true,
                      onTap: () {
                        ShareDateUtil().clearAllAccountData();
                        Get.offNamed(Routes.Login);
                      },
                    ),
                    Visibility(
                      visible: false,
                      child: _entry(
                        title: '软件开发测试',
                        image: 'assets/images/backLogin.png',
                        onTap: () =>
                            Get.toNamed(Routes.SoftwareDevelopmentTestView),
                      ),
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }

  /// 顶部个人信息卡
  Widget _profileCard(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return Obx(() => GlassCard(
          page: _page,
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
          child: Column(
            children: [
              GestureDetector(
                onLongPress: () {
                  HapticFeedback.vibrate();
                  MainUserUtil()
                      .vipLogin('${LoginData.account}', '${LoginData.password}')
                      .then((value) {
                    if (value["code"] == 400) {
                      ToastUtil.show('${value["msg"]}');
                      return;
                    }
                    if (value["code"] == 200) {
                      ContextDate.ContextVIPTken = value["token"];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => VIPFunList()));
                    }
                  });
                },
                onTap: () async {
                  UserHeadPortraitUtil u = UserHeadPortraitUtil(context);
                  await u.setHead().then((value) {});
                },
                child: Stack(
                  children: [
                    Showcase(
                      key: logic.showCase_1,
                      description: '点击此处可以替换头像',
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              GlassTheme.accentColor(_page),
                              GlassTheme.lighten(
                                  GlassTheme.accentColor(_page), .45),
                            ],
                          ),
                        ),
                        child: ClipOval(
                          child: SizedBox(
                            width: 96,
                            height: 96,
                            child: _avatar(),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: AccountData.isIdent.value,
                      child: Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.verified,
                            color: HexColor(AccountData.identMainColor.value),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${AccountData.studentName}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: text),
              ),
              if (AccountData.isIdent.value) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: HexColor(AccountData.identMainColor.value)
                        .withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: HexColor(AccountData.identMainColor.value)
                            .withValues(alpha: .35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified,
                          color: HexColor(AccountData.identMainColor.value),
                          size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${AccountData.identMainTag}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                HexColor(AccountData.identMainColor.value)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Divider(color: text.withValues(alpha: .08), height: 1),
              _infoRow('学号', '${AccountData.studentID}'),
              Divider(color: text.withValues(alpha: .08), height: 1),
              _infoRow('专业方向', '${AccountData.studentMajor}'),
            ],
          ),
        ));
  }

  Widget _avatar() {
    if (AccountData.headMode.value == 0) {
      return Image.network(
        "https://q1.qlogo.cn/g?b=qq&nk=2084069833&s=640",
        fit: BoxFit.cover,
      );
    }
    if (AccountData.headMode.value == 1) {
      return Image.network(
        "https://q1.qlogo.cn/g?b=qq&nk=${AccountData.head_qq.value}&s=640",
        fit: BoxFit.cover,
        errorBuilder: (context, e, stack) {
          return Image.network(
            "https://q1.qlogo.cn/g?b=qq&nk=2084069833&s=640",
            fit: BoxFit.cover,
          );
        },
      );
    }
    return Image.file(
      File(AccountData.head_filePath.value),
      fit: BoxFit.cover,
      errorBuilder: (context, e, stack) =>
          const Icon(Icons.person, size: 40, color: Colors.white),
    );
  }

  Widget _infoRow(String label, String value) {
    final Color text = GlassTheme.textColor(_page);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13, color: text.withValues(alpha: .55))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '未设置' : value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: text),
            ),
          ),
        ],
      ),
    );
  }

  /// 功能入口
  Widget _entry({
    required String title,
    String? svg,
    String? image,
    bool danger = false,
    required VoidCallback onTap,
  }) {
    final Color text = GlassTheme.textColor(_page);
    final Color titleColor = danger ? const Color(0xFFE53935) : text;
    final Color iconColor =
        danger ? const Color(0xFFE53935) : text.withValues(alpha: .72);
    return GlassCard(
      page: _page,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            if (svg != null)
              SvgPicture.asset(svg, width: 22, height: 22, color: iconColor)
            else if (image != null)
              Image.asset(image, width: 22, height: 22, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: titleColor),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: text.withValues(alpha: .30)),
          ],
        ),
      ),
    );
  }
}
