/* FileName CustomerThemeUtil
 *
 * @Author 20840
 * @Date 2024/10/1 17:19
 *
 * @Description TODO
 */

import 'dart:ui';

class CustomerThemeUtil{
  //用于设置颜色
  static setColor(List? colorList,Color color){
    if (colorList==null){
      return color;
    }
    return Color.fromARGB(colorList[0], colorList[1], colorList[2], colorList[3]);
  }
}