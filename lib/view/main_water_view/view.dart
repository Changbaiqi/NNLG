import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/WaterData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:callo/utils/WaterUtil.dart';
import 'package:callo/view/ScanKit_Water.dart';
import 'package:callo/view/router/Routes.dart';
import 'package:callo/view/main_water_view/widget/WaterFavoriteDrawer.dart';

import 'logic.dart';

/// 打水页：毛玻璃 + 渐变风格
class MainWaterViewPage extends StatelessWidget {
  MainWaterViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainWaterViewLogic());
  final state = Get.find<MainWaterViewLogic>().state;

  static const String _page = 'main_water_view';

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    //侧滑栏展开时拦截物理返回键：先收起侧滑栏而不是退出软件
    return Obx(() => PopScope(
          canPop: !logic.isEndDrawerOpen.value,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (logic.scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
              logic.scaffoldKey.currentState?.closeEndDrawer();
            }
          },
          child: GlassBackground(
      page: _page,
      child: Scaffold(
        key: logic.scaffoldKey,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        //右侧收藏抽屉（按 校区/栋数/楼层 分类）
        endDrawer: const WaterFavoriteDrawer(),
        onEndDrawerChanged: (isOpen) => logic.isEndDrawerOpen.value = isOpen,
        //顶部栏：标题 + 收藏列表入口（与课表页AppBar风格一致）
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('打水',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: GlassTheme.textColor(_page))),
          actions: [
            IconButton(
              tooltip: '收藏的饮水机',
              onPressed: logic.openFavoriteDrawer,
              icon: Obx(() {
                final int count = logic.favorites.length;
                final Widget icon = Icon(Icons.bookmarks_rounded,
                    size: 22, color: GlassTheme.accentColor(_page));
                if (count == 0) return icon;
                return Badge(label: Text('$count'), child: icon);
              }),
            ),
            const SizedBox(width: 6),
          ],
        ),
        //适配状态栏/挖孔摄像头：内容下移，渐变背景保持全屏
        body: SafeArea(
          top: false,
          bottom: false,
          child: RefreshIndicator(
          color: GlassTheme.accentColor(_page),
          backgroundColor: GlassTheme.surface(_page),
          elevation: 0,
          onRefresh: logic.onRefresh,
          child: ListView(
            //尽量在一屏内显示完：底部不需要给底栏留大间距（底栏是 Scaffold 的 bottomNavigationBar）
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            children: [
              _moneyCard(),
              const SizedBox(height: 12),
              GlassSectionTitle(page: _page, title: '冷热水开关'),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //热水独立卡片：开在上、关在下（竖排）
                  Expanded(
                    child: GlassCard(
                      page: _page,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _switchButton(
                            '热水开',
                            Icons.lock_open_rounded,
                            () => logic.hotOpenWaterButtonCheck(),
                            hot: true,
                          ),
                          const SizedBox(height: 8),
                          _switchButton(
                            '热水关',
                            Icons.lock_rounded,
                            () => logic.hotCloseWaterButtonCheck(),
                            filled: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  //冷水独立卡片：开在上、关在下（竖排）
                  Expanded(
                    child: GlassCard(
                      page: _page,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _switchButton(
                            '冷水开',
                            Icons.lock_open_rounded,
                            () => logic.coolOpenWaterButtonCheck(),
                            hot: true
                          ),
                          const SizedBox(height: 8),
                          _switchButton(
                            '冷水关',
                            Icons.lock_rounded,
                            () => logic.coolCloseWaterButtonCheck(),
                            filled: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GlassSectionTitle(page: _page, title: '绑定饮水机'),
              const SizedBox(height: 6),
              GlassCard(
                page: _page,
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                child: bingWater(),
              ),
              const SizedBox(height: 12),
              GlassSectionTitle(page: _page, title: '打水账号'),
              const SizedBox(height: 6),
              GlassCard(
                page: _page,
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
                child: bingAccount(),
              ),
            ],
          ),
        ),
      ),
      ),
      )));
  }

  /// 余额卡片（M3：主色大字 + 中性胶囊）
  Widget _moneyCard() {
    final ColorScheme scheme = GlassTheme.scheme;
    return GlassCard(
      page: _page,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Obx(() => Column(
            children: [
              Text('账户余额',
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Text(
                '${(state.money.value == "" || state.money.value == null) ? "0.00" : state.money.value}￥',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: scheme.primary),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop_rounded,
                        size: 14, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      '当前设备：${state.divice.value ?? "未知"}',
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  /// 单个开关按钮：M3 按钮（开=主色/暖色容器，关=中性容器）
  Widget _switchButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool filled = true,
    bool hot = false,
  }) {
    final ColorScheme scheme = GlassTheme.scheme;
    final Color bg = !filled
        ? scheme.surfaceContainerHighest
        : (hot ? scheme.error : scheme.primary);
    final Color fg = !filled
        ? scheme.onSurfaceVariant
        : (hot ? scheme.onError : scheme.onPrimary);
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: fg, size: 18),
                const SizedBox(width: 5),
                Text(label,
                    style: TextStyle(
                        color: fg,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bingAccount() {
    final Color text = GlassTheme.textColor(_page);
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(() => Text(
                  '账号：${WaterData.cardNum.value.isEmpty ? "未绑定" : WaterData.cardNum.value}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: text),
                )),
          ),
          //充值/绑定按钮跟随绑定状态实时刷新
          Obx(() {
            final bool bound = WaterData.waterAccount.value.isNotEmpty;
            return Row(
              children: [
                if (bound)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: _smallButton(
                      label: '充值',
                      icon: Icons.account_balance_wallet_rounded,
                      colors: const [Color(0xFF1E88E5), Color(0xFF64B5F6)],
                      onPressed: () => Get.toNamed(Routes.WaterCharge),
                    ),
                  ),
                _smallButton(
                  label: bound ? '解绑' : '绑定',
                  icon: Icons.link_rounded,
                  colors: const [Color(0xFF7C4DFF), Color(0xFFB388FF)],
                  onPressed: () {
                    if (!bound) {
                      logic.bingShow();
                    } else {
                      ShareDateUtil().setWaterUnBind().then((value) {
                        state.bingCard.value = "";
                        state.money.value = "";
                        state.divice.value = "";
                        Get.snackbar("提示", "解绑成功",
                            duration: const Duration(milliseconds: 1500));
                      });
                    }
                  },
                )
              ],
            );
          })
        ],
      ),
    );
  }

  Widget bingWater() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(
              label: '绑热水',
              icon: Icons.qr_code_scanner_rounded,
              colors: const [Color(0xFFF4511E), Color(0xFFFF8A65)],
              onPressed: () async {
                String result = await Navigator.push(logic.context!,
                    MaterialPageRoute(builder: (builder) {
                      return ScanKit_Water();
                    }));
                WaterUtil().bindHotWater(result);
              },
            ),
            _actionButton(
              label: '自动探测',
              icon: Icons.radar_rounded,
              colors: const [Color(0xFF00897B), Color(0xFF4DB6AC)],
              onPressed: () async {
                logic.detectWater().then((value) {
                  if (value == null) {
                    ToastUtil.show('探测失败，未找到附近收录或收藏的饮水机');
                    return;
                  }
                  ShareDateUtil().setCoolWater('${value['coldDeviceId']}');
                  ShareDateUtil().setHotWater('${value['hotDeviceId']}');
                  //匹配到收藏的饮水机时自动切换绑定
                  ToastUtil.show(value['fromFavorite'] == true
                      ? '已自动切换到收藏的饮水机：${value['label']}'
                      : '已绑定${value['label']}');
                });
              },
            ),
            _actionButton(
              label: '绑冷水',
              icon: Icons.qr_code_scanner_rounded,
              colors: const [Color(0xFF1E88E5), Color(0xFF64B5F6)],
              onPressed: () async {
                String result = await Navigator.push(logic.context!,
                    MaterialPageRoute(builder: (builder) {
                      return ScanKit_Water();
                    }));
                WaterUtil().bindCoolWater(result);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        //收藏：横向占满，左右与父布局留出padding，并与上方按钮留出间距
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              onPressed: logic.favoriteCurrent,
              icon: const Icon(Icons.star_rounded, size: 20),
              label: const Text('收藏当前绑定的饮水机'),
            ),
          ),
        ),
      ],
    );
  }

  /// 动作按钮的 M3 色调底：保留功能色相，但用低饱和 tonal 底
  Color _tonalBg(List<Color> colors) {
    final ColorScheme scheme = GlassTheme.scheme;
    final Color hue = colors.isNotEmpty ? colors.first : scheme.primary;
    return Color.alphaBlend(
      hue.withValues(alpha: scheme.brightness == Brightness.dark ? .30 : .16),
      scheme.surfaceContainerHigh,
    );
  }

  /// 色调底上的可读前景色
  Color _tonalFg(List<Color> colors, Color bg) {
    final Color hue =
        colors.isNotEmpty ? colors.first : GlassTheme.scheme.primary;
    return GlassTheme.readableAccent(hue, bg);
  }

  /// 圆形动作按钮（M3 tonal）
  Widget _actionButton({
    required String label,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    final Color bg = _tonalBg(colors);
    final Color fg = _tonalFg(colors, bg);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(icon, color: fg, size: 22),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: GlassTheme.textColor(_page)),
        ),
      ],
    );
  }

  /// 小号胶囊按钮（M3 tonal）
  Widget _smallButton({
    required String label,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    final Color bg = _tonalBg(colors);
    final Color fg = _tonalFg(colors, bg);
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 14),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      color: fg,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
