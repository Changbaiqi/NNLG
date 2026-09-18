import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/WaterData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:callo/utils/WaterUtil.dart';
import 'package:callo/view/ScanKit_Water.dart';
import 'package:callo/view/router/Routes.dart';

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
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        endDrawer: Drawer(
            width: 200,
            child: Center(
              child: Text('加载中...',
                  style: TextStyle(color: GlassTheme.textColor(_page))),
            )),
        //适配状态栏/挖孔摄像头：内容下移，渐变背景保持全屏
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
          color: GlassTheme.accentColor(_page),
          backgroundColor: GlassTheme.surface(_page),
          elevation: 0,
          onRefresh: logic.onRefresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
            children: [
              _moneyCard(),
              const SizedBox(height: 16),
              GlassSectionTitle(page: _page, title: '冷热水开关'),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //冷水独立卡片：开在上、关在下（竖排）
                  Expanded(
                    child: GlassCard(
                      page: _page,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _switchButton(
                            '冷水开',
                            Icons.lock_open_rounded,
                            () => logic.coolOpenWaterButtonCheck(),
                          ),
                          const SizedBox(height: 10),
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
                  const SizedBox(width: 12),
                  //热水独立卡片：开在上、关在下（竖排）
                  Expanded(
                    child: GlassCard(
                      page: _page,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _switchButton(
                            '热水开',
                            Icons.lock_open_rounded,
                            () => logic.hotOpenWaterButtonCheck(),
                            hot: true,
                          ),
                          const SizedBox(height: 10),
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
                ],
              ),
              const SizedBox(height: 16),
              GlassSectionTitle(page: _page, title: '绑定饮水机'),
              const SizedBox(height: 8),
              GlassCard(
                page: _page,
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 12),
                child: bingWater(),
              ),
              const SizedBox(height: 16),
              GlassSectionTitle(page: _page, title: '打水账号'),
              const SizedBox(height: 8),
              GlassCard(
                page: _page,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                child: bingAccount(),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  /// 余额卡片（M3：主色大字 + 中性胶囊）
  Widget _moneyCard() {
    final ColorScheme scheme = GlassTheme.scheme;
    return GlassCard(
      page: _page,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Obx(() => Column(
            children: [
              Text('账户余额',
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Text(
                '${(state.money.value == "" || state.money.value == null) ? "0.00" : state.money.value}￥',
                style: TextStyle(
                    fontSize: 46,
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
      height: 52,
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
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(() => Text(
                  '账号：${state.bingCard.value.isEmpty ? "未绑定" : state.bingCard.value}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: text),
                )),
          ),
          Row(
            children: [
              Visibility(
                  visible: WaterData.waterAccount.value.isEmpty ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: _smallButton(
                      label: '充值',
                      icon: Icons.account_balance_wallet_rounded,
                      colors: const [Color(0xFF1E88E5), Color(0xFF64B5F6)],
                      onPressed: () => Get.toNamed(Routes.WaterCharge),
                    ),
                  )),
              _smallButton(
                label: WaterData.waterAccount.value.isEmpty ? '绑定' : '解绑',
                icon: Icons.link_rounded,
                colors: const [Color(0xFF7C4DFF), Color(0xFFB388FF)],
                onPressed: () {
                  if (WaterData.waterAccount.value.isEmpty) {
                    logic.bingShow();
                  } else {
                    ShareDateUtil().setWaterUnBind().then((value) {
                      state.bingCard.value = "";
                      Get.snackbar("提示", "解绑成功",
                          duration: const Duration(milliseconds: 1500));
                    });
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget bingWater() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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
        _actionButton(
          label: '自动探测',
          icon: Icons.radar_rounded,
          colors: const [Color(0xFF00897B), Color(0xFF4DB6AC)],
          onPressed: () async {
            logic.detectWater().then((value) {
              if (value == null) {
                ToastUtil.show('探测失败，未找到附近收录的机子');
                return;
              }
              ToastUtil.show('已绑定${value['inform']['label']}');
              ShareDateUtil().setCoolWater(value['coldDeviceId']);
              ShareDateUtil().setHotWater(value['hotDeviceId']);
            });
          },
        ),
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(icon, color: fg, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
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
