import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/dao/AppInfoData.dart';
import 'package:callo/dao/ContextData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/dao/LoginData.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/view/module/showUpdateDialog.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

/// 设置、账号安全及隐私：参考工墨设置页（分组标题 + Card/ListTile 列表）
class AccountSafeViewPage extends StatelessWidget {
  AccountSafeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AccountSafeViewLogic>();
  final state = Get.find<AccountSafeViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('设置'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(cs, '账号与安全'),
          Card(
            child: Column(
              children: [
                //按住查看教务系统密码
                InkWell(
                  onTapDown: (_) => state.eyeState.value = true,
                  onTapUp: (_) => state.eyeState.value = false,
                  onTapCancel: () => state.eyeState.value = false,
                  child: ListTile(
                    leading: Icon(Icons.password_rounded, color: cs.primary),
                    title: const Text('教务系统密码'),
                    subtitle: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('学号：${LoginData.account}',
                                style: const TextStyle(fontSize: 11.5)),
                            Text(
                              '密码：${state.eyeState.value ? LoginData.password : '按住查看'}',
                              style: const TextStyle(fontSize: 11.5),
                            ),
                          ],
                        )),
                    trailing: Obx(() => Icon(
                          state.eyeState.value
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: cs.onSurfaceVariant,
                        )),
                  ),
                ),
                const Divider(height: 1),
                Obx(() => SwitchListTile(
                      secondary:
                          Icon(Icons.rocket_launch_rounded, color: cs.primary),
                      title: const Text('极速启动'),
                      subtitle: const Text(
                        '开启后先进入离线模式快速查看课表，登录认证成功后再放行其余功能',
                        style: TextStyle(fontSize: 11.5),
                      ),
                      value: ContextDate.isTopSpeedStart.value,
                      onChanged: (v) {
                        ShareDateUtil().setTopSpeedStart(v);
                      },
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(cs, '外观'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('深色模式',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface)),
                      const SizedBox(height: 10),
                      Row(children: [
                        _modePill(
                          cs,
                          '跟随系统',
                          CustomThemeData.isFollowSystemDarkMode.value,
                          () => ShareDateUtil().setIsFollowSystemDarkMode(true),
                        ),
                        const SizedBox(width: 8),
                        _modePill(
                          cs,
                          '浅色',
                          !CustomThemeData.isFollowSystemDarkMode.value &&
                              CustomThemeData.selectThemeUid.value ==
                                  'default:whiteTheme',
                          () async {
                            if (CustomThemeData.isFollowSystemDarkMode.value) {
                              await ShareDateUtil()
                                  .setIsFollowSystemDarkMode(false);
                            }
                            await ShareDateUtil()
                                .setThemeUid('default:whiteTheme');
                            await CustomThemeData.loadTheme(
                                CustomThemeData.selectThemeUid.value);
                          },
                        ),
                        const SizedBox(width: 8),
                        _modePill(
                          cs,
                          '深色',
                          !CustomThemeData.isFollowSystemDarkMode.value &&
                              CustomThemeData.selectThemeUid.value ==
                                  'default:blackTheme',
                          () async {
                            if (CustomThemeData.isFollowSystemDarkMode.value) {
                              await ShareDateUtil()
                                  .setIsFollowSystemDarkMode(false);
                            }
                            await ShareDateUtil()
                                .setThemeUid('default:blackTheme');
                            await CustomThemeData.loadTheme(
                                CustomThemeData.selectThemeUid.value);
                          },
                        ),
                      ]),
                      const SizedBox(height: 10),
                      //自动取色模式（Material You：从课表壁纸提取主题色）
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: Icon(Icons.auto_fix_high_rounded,
                            color: cs.primary),
                        title: const Text('自动取色模式'),
                        subtitle: const Text(
                            '根据课表壁纸自动生成主题配色（Material You）',
                            style: TextStyle(fontSize: 11.5)),
                        value: CustomThemeData.isAutoColorMode.value,
                        onChanged: (v) =>
                            ShareDateUtil().setIsAutoColorMode(v),
                      ),
                      const SizedBox(height: 6),
                      Text('主题配色',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface)),
                      const SizedBox(height: 10),
                      //自动取色模式下预设配色置灰且不可选（使用自动取到的/默认主题色）
                      Opacity(
                        opacity:
                            CustomThemeData.isAutoColorMode.value ? .45 : 1,
                        child: IgnorePointer(
                          ignoring: CustomThemeData.isAutoColorMode.value,
                          child: SizedBox(
                            height: 84,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 4),
                              itemCount: AppThemePreset.values.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) => _presetTile(
                                  cs, AppThemePreset.values[index]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(cs, '关于'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('关于软件和作者'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.toNamed(Routes.AboutMe),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_outlined),
                  title: const Text('版本'),
                  trailing: Obx(() => Text(
                      'v${AppInfoData.version.value} (${AppInfoData.buildNumber.value})')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 分组标题（工墨同款：小号灰字）
  Widget _sectionTitle(ColorScheme cs, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  /// 深色模式胶囊（跟随系统 / 浅色 / 深色）
  Widget _modePill(
      ColorScheme cs, String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color:
                selected ? cs.primary.withValues(alpha: .12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? cs.primary : cs.outlineVariant.withValues(alpha: .6),
            ),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  fontSize: 13,
                  color: selected
                      ? cs.primary
                      : cs.onSurfaceVariant.withValues(alpha: .8),
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                )),
          ),
        ),
      ),
    );
  }

  /// 配色方块（工墨同款：色板圆点 + 名称，选中放大高亮）
  Widget _presetTile(ColorScheme cs, AppThemePreset presetValue) {
    final bool selected = CustomThemeData.preset.value == presetValue;
    return GestureDetector(
      onTap: () => ShareDateUtil().setThemePreset(presetValue),
      child: AnimatedScale(
        scale: selected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 96,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? cs.primary.withValues(alpha: .1)
                : cs.surfaceContainerHighest.withValues(alpha: .35),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? cs.primary
                  : cs.outlineVariant.withValues(alpha: .5),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final Color c in presetValue.swatches) ...[
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.black.withValues(alpha: .08)),
                      ),
                    ),
                    if (c != presetValue.swatches.last)
                      const SizedBox(width: 4),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(presetValue.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected ? cs.primary : cs.onSurfaceVariant,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
