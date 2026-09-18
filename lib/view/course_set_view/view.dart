import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/utils/CourseUtil.dart';
import 'package:callo/utils/CourseWidgetUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/view/module/selectBeginCourseTimeSheet.dart';
import 'package:callo/view/module/selectCourseTimeSheet.dart';
import 'package:callo/view/module/selectDateSheet.dart';
import 'package:callo/view/module/selectNowCourseListSheet.dart';
import 'package:callo/view/module/showCourseNumSheet.dart';

import 'logic.dart';

/// 课表设置：参考工墨设置页（分组标题 + Card/ListTile/SwitchListTile）
class CourseSetViewPage extends StatelessWidget {
  CourseSetViewPage({Key? key}) : super(key: key);
  final logic = Get.put(CourseSetViewLogic());

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('课表设置'), centerTitle: true),
      body: Obx(() => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              _sectionTitle(cs, '外观'),
              Card(
                child: Column(
                  children: [
                    //彩色课表
                    SwitchListTile(
                      secondary: Icon(Icons.palette_outlined, color: cs.primary),
                      title: const Text('彩色课表'),
                      subtitle: const Text('将不同课程用不同颜色区分',
                          style: TextStyle(fontSize: 11.5)),
                      value: CourseData.isColorClassSchedule.value,
                      onChanged: (v) =>
                          ShareDateUtil().setColorClassSchedule(v),
                    ),
                    const Divider(height: 1),
                    //课表项透明度（课程块 + 顶部"大小节显示/周一/周二"等控件背景）
                    _opacityRow(
                      cs,
                      icon: Icons.opacity_rounded,
                      label: '课表项透明度',
                      value: CourseData.courseItemOpacity.value,
                      onChanged: (v) =>
                          ShareDateUtil().setCourseItemOpacity(v),
                    ),
                    const Divider(height: 1),
                    //纯白背景/图片背景
                    SwitchListTile(
                      secondary:
                          Icon(Icons.wallpaper_rounded, color: cs.primary),
                      title: const Text('纯白背景/图片背景'),
                      subtitle: const Text('调整课表背景图片',
                          style: TextStyle(fontSize: 11.5)),
                      value: CourseData.isPictureBackground.value,
                      onChanged: (v) =>
                          ShareDateUtil().setIsPictureBackground(v),
                    ),
                    //背景子选项（展开/收起动画，参考工墨）
                    AnimatedSize(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topCenter,
                      child: !CourseData.isPictureBackground.value
                          ? const SizedBox(width: double.infinity)
                          : Column(
                        children: [
                          const Divider(height: 1),
                          _opacityRow(
                            cs,
                            icon: Icons.opacity_rounded,
                            label: '背景透明度',
                            value: CourseData.courseBackgroundOpacity.value,
                            onChanged: (v) => ShareDateUtil()
                                .setCourseBackgroundOpacity(v),
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            secondary: Icon(Icons.auto_awesome_rounded,
                                color: cs.primary),
                            title: const Text('随机二次元背景图'),
                            value: CourseData
                                .isRandomQuadraticBackground.value,
                            onChanged: (v) {
                              ShareDateUtil()
                                  .setIsRandomQuadraticBackground(v);
                              if (v) {
                                ShareDateUtil().setIsUrlBackground(false);
                                ShareDateUtil()
                                    .setIsCustomerLocalBackground(false);
                              }
                            },
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            secondary: Icon(Icons.link_rounded,
                                color: cs.primary),
                            title: const Text('自定义图片URL背景图'),
                            value: CourseData.isUrlBackground.value,
                            onChanged: (v) {
                              ShareDateUtil().setIsUrlBackground(v);
                              if (v) {
                                ShareDateUtil()
                                    .setIsRandomQuadraticBackground(false);
                                ShareDateUtil()
                                    .setIsCustomerLocalBackground(false);
                              }
                            },
                          ),
                          _urlField(
                            controller: logic.backGroundUrlController,
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            secondary: Icon(Icons.image_outlined,
                                color: cs.primary),
                            title: const Text('自定义背景图'),
                            value: CourseData.isCustomerLocalBackground.value,
                            onChanged: (v) {
                              ShareDateUtil()
                                  .setIsCustomerLocalBackground(v);
                              if (v) {
                                ShareDateUtil().setIsUrlBackground(false);
                                ShareDateUtil()
                                    .setIsRandomQuadraticBackground(false);
                              }
                            },
                          ),
                          _pickImageButton(
                            label: '选择图片',
                            onPressed: () => logic.getImage(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    //课表小组件自定义背景
                    SwitchListTile(
                      secondary:
                          Icon(Icons.widgets_outlined, color: cs.primary),
                      title: const Text('课表小组件自定义背景'),
                      subtitle: const Text('调整桌面课表小组件的背景图片',
                          style: TextStyle(fontSize: 11.5)),
                      value: CourseData.isCourseWidgetCustomBackground.value,
                      onChanged: (v) => ShareDateUtil()
                          .setIsCourseWidgetCustomBackground(v),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topCenter,
                      child: !CourseData.isCourseWidgetCustomBackground.value
                          ? const SizedBox(width: double.infinity)
                          : Column(
                        children: [
                          const Divider(height: 1),
                          _opacityRow(
                            cs,
                            icon: Icons.opacity_rounded,
                            label: '小组件背景透明度',
                            value:
                                CourseData.courseWidgetBackgroundOpacity.value,
                            onChanged: (v) => ShareDateUtil()
                                .setCourseWidgetBackgroundOpacity(v),
                            onChangeEnd: (_) =>
                                CourseWidgetUtil.updateCourseWidget(),
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            secondary: Icon(Icons.auto_awesome_rounded,
                                color: cs.primary),
                            title: const Text('随机二次元背景图'),
                            value: CourseData
                                .isCourseWidgetRandomQuadraticBackground.value,
                            onChanged: (v) {
                              ShareDateUtil()
                                  .setIsCourseWidgetRandomQuadraticBackground(v);
                              if (v) {
                                ShareDateUtil()
                                    .setIsCourseWidgetUrlBackground(false);
                                ShareDateUtil()
                                    .setIsCourseWidgetLocalBackground(false);
                              }
                            },
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            secondary: Icon(Icons.link_rounded,
                                color: cs.primary),
                            title: const Text('自定义图片URL背景图'),
                            value: CourseData.isCourseWidgetUrlBackground.value,
                            onChanged: (v) {
                              ShareDateUtil().setIsCourseWidgetUrlBackground(v);
                              if (v) {
                                ShareDateUtil()
                                    .setIsCourseWidgetRandomQuadraticBackground(
                                        false);
                                ShareDateUtil()
                                    .setIsCourseWidgetLocalBackground(false);
                              }
                            },
                          ),
                          _urlField(
                            controller: logic.widgetBackGroundUrlController,
                            onSubmitted: (v) => ShareDateUtil()
                                .setCourseWidgetBackgroundInputUrl(v),
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            secondary: Icon(Icons.image_outlined,
                                color: cs.primary),
                            title: const Text('自定义背景图'),
                            value:
                                CourseData.isCourseWidgetLocalBackground.value,
                            onChanged: (v) {
                              ShareDateUtil()
                                  .setIsCourseWidgetLocalBackground(v);
                              if (v) {
                                ShareDateUtil()
                                    .setIsCourseWidgetUrlBackground(false);
                                ShareDateUtil()
                                    .setIsCourseWidgetRandomQuadraticBackground(
                                        false);
                              }
                            },
                          ),
                          _pickImageButton(
                            label: '选择图片',
                            onPressed: () => logic.getWidgetImage(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    //摇一摇返回当前周
                    SwitchListTile(
                      secondary:
                          Icon(Icons.vibration_rounded, color: cs.primary),
                      title: const Text('摇一摇返回当前周'),
                      subtitle: const Text('浏览其它周课表时摇一摇快速回到当前周',
                          style: TextStyle(fontSize: 11.5)),
                      value: CourseData.isShakeToNowSchedule.value,
                      onChanged: (v) =>
                          ShareDateUtil().setShakeToNowSchedule(v),
                    ),
                    const Divider(height: 1),
                    //午休分割线
                    SwitchListTile(
                      secondary: Icon(Icons.horizontal_rule_rounded,
                          color: cs.primary),
                      title: const Text('午休分割线'),
                      subtitle: const Text('是否显示课表午休分割线',
                          style: TextStyle(fontSize: 11.5)),
                      value: CourseData.isNoonLineSwitch.value,
                      onChanged: (v) => ShareDateUtil().setNoonLineSwitch(v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle(cs, '课表数据'),
              Card(
                child: Column(
                  children: [
                    //学期课表
                    _valueTile(
                      cs,
                      icon: Icons.menu_book_rounded,
                      title: '学期课表',
                      subtitle: '此项为必选，会根据官网拉取最新的课表数据',
                      value: '${CourseData.nowCourseList.value}',
                      onTap: () {
                        selectNowCourseListSheet(context).show().then((value) async {
                          if (value != null) {
                            Get.snackbar("课表通知", "正在切换课表...",
                                duration: const Duration(milliseconds: 1500));
                            CourseData.nowCourseList.value = value;
                            ShareDateUtil().setNowCourseList(value);
                            await logic.onRefresh();
                            Get.snackbar("课表通知", "课表切换成功",
                                duration: const Duration(milliseconds: 1500));
                          }
                        });
                      },
                    ),
                    const Divider(height: 1),
                    //开学时间
                    _valueTile(
                      cs,
                      icon: Icons.event_available_rounded,
                      title: '开学时间',
                      subtitle: '判断是否为假期中以及自动判断周数',
                      value: '${CourseData.schoolOpenTime.value}',
                      onTap: () {
                        selectDateSheet(context).show().then((value) {
                          if (value != null) {
                            CourseData.schoolOpenTime.value = value;
                            CourseData.nowWeek.value = CourseUtil.getNowWeek(
                                CourseData.schoolOpenTime.value,
                                CourseData.ansWeek.value);
                            ShareDateUtil().setSchoolOpenDate(
                                CourseData.schoolOpenTime.value);
                          }
                        });
                      },
                    ),
                    const Divider(height: 1),
                    //当前周数
                    _valueTile(
                      cs,
                      icon: Icons.timelapse_rounded,
                      title: '当前周数',
                      subtitle: '开学到现在第几周',
                      value: CourseData.nowWeek.value == 0
                          ? '假期中'
                          : '${CourseData.nowWeek.value}',
                      onTap: () {
                        Get.snackbar(
                          "课表通知",
                          CourseData.nowWeek.value == 0
                              ? "假期中"
                              : '当前第${CourseData.nowWeek.value}周',
                          duration: const Duration(milliseconds: 1500),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    //本学期总周数
                    _valueTile(
                      cs,
                      icon: Icons.date_range_rounded,
                      title: '本学期总周数',
                      subtitle: '请选择本学期总共多少周',
                      value: '${CourseData.ansWeek.value}',
                      onTap: () {
                        showCourseNumSheet(context).show().then((value) {
                          if (value != null) {
                            CourseData.ansWeek.value = value;
                            ShareDateUtil()
                                .setSemesterWeekNum(CourseData.ansWeek.value);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle(cs, '上课时间'),
              CourseData.newOrOldCourseScheduleChoose.value
                  ? _newCourseTimeCard(cs, context)
                  : _oldCourseTimeCard(cs, context),
            ],
          )),
    );
  }

  /// 分组标题（工墨同款：小号弱化文字）
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

  /// 带当前值的跳转行（工墨设置页风格）
  Widget _valueTile(
    ColorScheme cs, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: cs.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11.5)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
        ],
      ),
      onTap: onTap,
    );
  }

  /// 透明度滑杆行
  Widget _opacityRow(
    ColorScheme cs, {
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    ValueChanged<double>? onChangeEnd,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        children: [
          Icon(icon, color: cs.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$label   ${(value * 100).toInt()}',
                    style: const TextStyle(fontSize: 14)),
                Slider(
                  value: value.clamp(0, 1),
                  onChanged: (v) =>
                      onChanged(double.parse(v.toStringAsFixed(3))),
                  onChangeEnd: onChangeEnd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// URL 输入框
  Widget _urlField({
    required TextEditingController controller,
    ValueChanged<String>? onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        decoration: const InputDecoration(
          labelText: 'URL',
          hintText: '请输入图片URL链接',
          isDense: true,
        ),
      ),
    );
  }

  /// 选择图片按钮
  Widget _pickImageButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.photo_library_outlined, size: 18),
          label: Text(label),
        ),
      ),
    );
  }

  /// 新课程表：各小节课时间
  Widget _newCourseTimeCard(ColorScheme cs, BuildContext context) {
    final List<String> times =
        CourseData.courseTime.value.map((e) => '$e').toList();
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.schedule_rounded, color: cs.primary),
            title: const Text('各小节课时间'),
            subtitle: const Text('调节每小节课的起止时间',
                style: TextStyle(fontSize: 11.5)),
            trailing:
                Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            onTap: () async {
              await selectCourseTimeSheet
                  .show(Get.context!, 12, CourseData.courseTime.value)
                  .then((resDataTime) async {
                if (resDataTime != null) {
                  List<String> resTime = [];
                  for (int i = 1;
                      i <= CourseData.courseTime.value.length;
                      ++i) {
                    resTime.add(
                        '${(resDataTime[i * 2 - 2].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 2].minute.toString()).padLeft(2, '0')}-${(resDataTime[i * 2 - 1].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 1].minute.toString()).padLeft(2, '0')}');
                  }
                  await ShareDateUtil()
                      .setCourseTimeList(resTime)
                      .then((value) {
                    Get.snackbar("课表通知", "修改成功",
                        duration: const Duration(milliseconds: 1500));
                  });
                }
              });
            },
          ),
          for (int i = 0; i < times.length; i++) ...[
            const Divider(height: 1),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 72, right: 16),
              title: Text('第${i + 1}小节',
                  style: const TextStyle(fontSize: 13.5)),
              trailing: Text(times[i],
                  style: TextStyle(fontSize: 13.5, color: cs.onSurfaceVariant)),
            ),
          ],
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.restart_alt_rounded, color: cs.error),
            title: Text('一键重置默认时间',
                style: TextStyle(color: cs.error, fontWeight: FontWeight.w600)),
            onTap: () => _confirmReset(context, cs),
          ),
        ],
      ),
    );
  }

  /// 旧课程表：各大节课时间
  Widget _oldCourseTimeCard(ColorScheme cs, BuildContext context) {
    final List<String> times =
        CourseData.oldCourseTime.value.map((e) => '$e').toList();
    const List<String> labels = [
      '第一大节',
      '第二大节',
      '第三大节',
      '第四大节',
      '第五大节',
      '第六大节',
    ];
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.schedule_rounded, color: cs.primary),
            title: const Text('各大节课时间'),
            subtitle: const Text('调节每大节课的起止时间',
                style: TextStyle(fontSize: 11.5)),
            trailing:
                Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            onTap: () async {
              await selectBeginCourseTimeSheet(context)
                  .show()
                  .then((resDataTime) async {
                if (resDataTime != null) {
                  List<String> resTime = [];
                  for (int i = 1;
                      i <= CourseData.oldCourseTime.value.length;
                      ++i) {
                    resTime.add(
                        '${(resDataTime[i * 2 - 2].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 2].minute.toString()).padLeft(2, '0')}-${(resDataTime[i * 2 - 1].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 1].minute.toString()).padLeft(2, '0')}');
                  }
                  await ShareDateUtil()
                      .setOldCourseTimeList(resTime)
                      .then((value) {
                    Get.snackbar("课表通知", "修改成功",
                        duration: const Duration(milliseconds: 1500));
                  });
                }
              });
            },
          ),
          for (int i = 0; i < times.length && i < labels.length; i++) ...[
            const Divider(height: 1),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 72, right: 16),
              title: Text(labels[i], style: const TextStyle(fontSize: 13.5)),
              trailing: Text(times[i],
                  style: TextStyle(fontSize: 13.5, color: cs.onSurfaceVariant)),
            ),
          ],
        ],
      ),
    );
  }

  /// 一键重置确认（M3 弹窗）
  void _confirmReset(BuildContext context, ColorScheme cs) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确定重置为默认上课时间吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                ShareDateUtil()
                    .setCourseTimeList(CourseData.defaultCourseTime)
                    .then((value) => CourseData.courseTime.refresh());
                Navigator.pop(dialogContext);
                Get.snackbar("课表通知", "已重置为默认时间",
                    duration: const Duration(milliseconds: 1500));
              },
              child: Text('确定', style: TextStyle(color: cs.error)),
            ),
          ],
        );
      },
    );
  }
}
