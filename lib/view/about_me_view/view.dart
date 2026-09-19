import 'package:callo/dao/AppInfoData.dart';
import 'package:callo/dao/DebugData.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:callo/utils/CusBehavior.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logic.dart';

/// 关于软件和作者：毛玻璃 + 渐变风格
class AboutMeViewPage extends StatelessWidget {
  AboutMeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AboutMeViewLogic>();
  final state = Get.find<AboutMeViewLogic>().state;

  static const String _page = 'about_me_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return Obx(() => GlassBackground(
          page: _page,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(color: text),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: text,
              title: Text('关于软件和作者',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: text)),
            ),
            body: ListView(
              //果冻回弹由全局的 _JellyScrollBehavior 提供
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                //应用信息
                GlassCard(
                  page: _page,
                  padding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                  child: Column(
                    children: [
                      //连续点击图标5次：切换「我的」页面里的「软件开发测试」入口
                      GestureDetector(
                        onTap: _onLogoTap,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [accent, GlassTheme.lighten(accent, .45)],
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/ic_launcher.png',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('恰啰校园',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: text)),
                      const SizedBox(height: 4),
                      Text(
                        '当前版本：${AppInfoData.version.value}(${AppInfoData.versionNumber.value})',
                        style: TextStyle(
                            fontSize: 12.5,
                            color: text.withValues(alpha: .6)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GlassSectionTitle(page: _page, title: '关于软件'),
                const SizedBox(height: 8),
                GlassCard(
                  page: _page,
                  padding: const EdgeInsets.all(6),
                  child: ScrollConfiguration(
                    behavior: CusBehavior(),
                    child: Obx(() => MarkdownWidget(
                          padding: const EdgeInsets.all(10),
                          shrinkWrap: true,
                          data: state.aboutMeText.value,
                          config: MarkdownConfig(configs: [
                            PConfig(textStyle: TextStyle(color: text)),
                          ]),
                        )),
                  ),
                ),
                const SizedBox(height: 22),
                //作者链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _social(
                      asset: 'assets/images/github.svg',
                      label: 'GitHub',
                      onTap: () async {
                        const url = 'https://github.com/Changbaiqi';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                    _social(
                      asset: 'assets/images/blog.svg',
                      label: '博客',
                      onTap: () async {
                        const url = 'https://blogs.changbaiqi.top';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                    _social(
                      asset: 'assets/images/qq.svg',
                      label: 'QQ',
                      onTap: () => callQQ(number: 2084069833, isGroup: false),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'By.长白崎\n本软件为免费软件如有贩卖请勿相信\n作者QQ：2084069833',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.6,
                      color: text.withValues(alpha: .45)),
                ),
              ],
            ),
          ),
        ));
  }

  /// 连续点击图标5次：切换「我的」页面里的「软件开发测试」入口
  void _onLogoTap() {
    if (DebugData.onLogoTap()) {
      ToastUtil.show(DebugData.showDevTest.value
          ? '已开启软件开发测试入口'
          : '已隐藏软件开发测试入口');
    }
  }

  /// 作者链接按钮
  Widget _social({
    required String asset,
    required String label,
    required VoidCallback onTap,
  }) {
    final Color accent = GlassTheme.accentColor(_page);
    final Color text = GlassTheme.textColor(_page);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: .10),
                border: Border.all(color: accent.withValues(alpha: .22)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  asset,
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(accent, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: text.withValues(alpha: .7))),
          ],
        ),
      ),
    );
  }

  /// 吊起QQ
  /// [number]QQ号
  /// [isGroup]是否是群号,默认是,不是群号则直接跳转聊天
  void callQQ({int number = 955586867, bool isGroup = true}) async {
    String url = isGroup
        ? 'mqqapi://card/show_pslcard?src_type=internal&version=1&uin=${number ?? 0}&card_type=group&source=qrcode'
        : 'mqqwpa://im/chat?chat_type=wpa&uin=${number ?? 0}&version=1&src_type=web&web_src=oicqzone.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('不能访问');
    }
  }
}
