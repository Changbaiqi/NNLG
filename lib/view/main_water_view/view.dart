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
        body: RefreshIndicator(
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
                            const Color(0xFF1E88E5),
                            () => logic.coolOpenWaterButtonCheck(),
                          ),
                          const SizedBox(height: 10),
                          _switchButton(
                            '冷水关',
                            Icons.lock_rounded,
                            const Color(0xFF1E88E5),
                            () => logic.coolCloseWaterButtonCheck(),
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
                            Icons.local_fire_department_rounded,
                            const Color(0xFFE53935),
                            () => logic.hotOpenWaterButtonCheck(),
                          ),
                          const SizedBox(height: 10),
                          _switchButton(
                            '热水关',
                            Icons.block_rounded,
                            const Color(0xFFE53935),
                            () => logic.hotCloseWaterButtonCheck(),
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
    );
  }

  /// 余额卡片
  Widget _moneyCard() {
    final Color text = GlassTheme.textColor(_page);
    return GlassCard(
      page: _page,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Obx(() => Column(
            children: [
              Text('账户余额',
                  style: TextStyle(
                      fontSize: 12, color: text.withValues(alpha: .62))),
              const SizedBox(height: 6),
              ShaderMask(
                shaderCallback: (Rect rect) => const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
                ).createShader(rect),
                child: Text(
                  '${(state.money.value == "" || state.money.value == null) ? "0.00" : state.money.value}￥',
                  style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: text.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop_rounded,
                        size: 14, color: text.withValues(alpha: .55)),
                    const SizedBox(width: 6),
                    Text(
                      '当前设备：${state.divice.value ?? "未知"}',
                      style: TextStyle(
                          fontSize: 12, color: text.withValues(alpha: .75)),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  /// 单个开关按钮：渐变胶囊（占满所在列宽度）
  Widget _switchButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, GlassTheme.lighten(color, .30)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 5),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ],
              ),
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

  /// 渐变圆形动作按钮
  Widget _actionButton({
    required String label,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: .38),
                blurRadius: 14,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(icon, color: Colors.white, size: 28),
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

  /// 小号渐变按钮
  Widget _smallButton({
    required String label,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: .30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
