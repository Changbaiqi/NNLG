/* FileName DashedLind
 *
 * @Author 20840
 * @Date 2024/9/3 14:00
 *
 * @Description TODO
 */

// 自定义虚线 （默认是垂直方向）
import 'package:flutter/material.dart';

class DashedLind extends StatelessWidget {
  final Axis axis; // 虚线方向
  final double dashedWidth; // 根据虚线的方向确定自己虚线的宽度
  final double dashedHeight; // 根据虚线的方向确定自己虚线的高度
  final int count; // 内部会根据设置的个数和宽度确定密度(虚线的空白间隔)
  final Color color; // 虚线的颜色

  const DashedLind({super.key,
    required this.axis,
    this.dashedWidth = 1,
    this.dashedHeight = 1,
    this.count = 10,
    this.color = const Color(0xffaaaaaa)
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 根据宽度计算个数
          return Flex(
            direction: axis,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(count, (_) {
              return SizedBox(
                width: dashedWidth,
                height: dashedHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),);
        });
  }
}