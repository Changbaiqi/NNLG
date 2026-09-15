import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/TeachingEvaUtil.dart';

import 'logic.dart';

/// 评教表单：毛玻璃 + 渐变风格
class EvalFormViewPage extends StatelessWidget {
  EvalFormViewPage({Key? key}) : super(key: key);

  final logic = Get.find<EvalFormViewLogic>();
  final state = Get.find<EvalFormViewLogic>().state;

  static const String _page = 'teaching_eva_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: text,
          iconTheme: IconThemeData(color: text),
          title: Text('${Get.arguments['courseName']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: text)),
        ),
        body: Obx(() => state.formJsonData.value != null
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        itemCount:
                            (state.formJsonData.value!['classList'] as List)
                                .length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          final cls =
                              (state.formJsonData.value!['classList'] as List)[
                                  index];
                          return GlassCard(
                            page: _page,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding:
                                const EdgeInsets.fromLTRB(14, 12, 14, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${cls['className']}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: text),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE53935)
                                            .withValues(alpha: .10),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                            color: const Color(0xFFE53935)
                                                .withValues(alpha: .28)),
                                      ),
                                      child: Text(
                                        '${cls['rate']}',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFE53935)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ...((cls['problemList'] as List)
                                    .map((problem) => _problemBlock(problem))),
                              ],
                            ),
                          );
                        }),
                    flex: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _softButton(
                            text: '保存',
                            color: text,
                            onPressed: () => _submit(0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GradientButton(
                            text: '提交',
                            page: _page,
                            height: 46,
                            onPressed: () => _submit(1),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : const SizedBox.shrink()),
      ),
    );
  }

  /// 单个问题 + 选项（选项为毛玻璃单选胶囊）
  Widget _problemBlock(dynamic problem) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${problem['title']}',
              style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: text)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (problem['selectList'] as List).map((selectE) {
              final bool checked = selectE['checked'] == true;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  (problem['selectList'] as List).forEach((element) {
                    element['checked'] = (element['name'] == selectE['name']);
                  });
                  state.formJsonData.refresh();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: checked
                        ? accent.withValues(alpha: .16)
                        : text.withValues(alpha: .05),
                    border: Border.all(
                      color: checked
                          ? accent.withValues(alpha: .65)
                          : text.withValues(alpha: .12),
                      width: checked ? 1.4 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        checked
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 16,
                        color: checked
                            ? accent
                            : text.withValues(alpha: .45),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${selectE['text']}',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                checked ? FontWeight.w700 : FontWeight.w500,
                            color: checked ? accent : text),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 提交(1)/保存(0)
  void _submit(int type) {
    if (logic.checkSubmit(state.formJsonData.value)) {
      TeachingEvaUtil().submitEva(state.formJsonData.value, type).then((value) {
        if (type == 1) Get.back();
        Get.snackbar("评教通知", "$value",
            duration: const Duration(milliseconds: 1500));
      });
    } else {
      Get.snackbar("评教通知",
          "您还有未评教的选项，请全部选择完后再${type == 1 ? '提交' : '保存'}。",
          duration: const Duration(milliseconds: 1500));
    }
  }

  /// 次要按钮：轻描边玻璃样式
  Widget _softButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 46,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: color.withValues(alpha: .06),
              border: Border.all(color: color.withValues(alpha: .18)),
            ),
            child: Center(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color.withValues(alpha: .85))),
            ),
          ),
        ),
      ),
    );
  }
}
