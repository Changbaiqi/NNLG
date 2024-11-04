import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:nnlg/utils/CusBehavior.dart';
import 'package:nnlg/utils/CustomerThemeUtil.dart';
import 'package:nnlg/utils/FileUtils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dao/CustomThemeData.dart';
import 'logic.dart';

class AboutMeViewPage extends StatelessWidget {
  AboutMeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AboutMeViewLogic>();
  final state = Get.find<AboutMeViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['backgroundColor'] as List ),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['defaultIconColor'] as List )
        ),
        backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['backgroundColor'] as List ),
        foregroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['foregroundColor'] as List ),
        title: Text('关于软件和作者',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['textColor'] as List )),),
      ),
      body: Container(
        child: ListView(
          children: [
            Column(
              children: [
                //声明
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['backgroundColor'] as List ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0.0, 7.0),
                              blurRadius: 14.0,
                              spreadRadius: 0,
                              // color: Color(0xFFdfdfdf)
                              color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['shadowColor'] as List )
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: ScrollConfiguration(
                        behavior: CusBehavior(),
                        child: Column(
                          children: [
                            // Text(
                            //     '软件作者为本校计算机系(21级)学生，软件维护需要成本。目前用爱发电。如果软件有什么bug或者啥的可以在“校园聊一聊”功能里面提案或联系作者QQ或者发送邮箱：2084069833。因为目前软件源码没人继承维护，所以等软件作者毕业后或许将不再维护。服务器一旦停止运行有些功能将会不能使用（课表和打水功能等核心功能还能使用，这个不用担心）。'),
                            Obx(() => MarkdownWidget(padding:EdgeInsets.all(10),shrinkWrap: true,data: state.aboutMeText.value,config: MarkdownConfig(configs: [
                              PConfig(textStyle: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['about_me_view']!['textColor'] as List ))),

                            ]),))
                            // MarkdownWidget(padding:EdgeInsets.all(10),shrinkWrap: true,data: '''### 关于软件''')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/github.svg',
                                      width: 30,
                                      height: 30,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'GitHub',
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    )
                                  ],
                                ),
                                onTap: () async {
                                  const url = 'https://github.com/Changbaiqi';
                                  if(await canLaunch(url)){
                                    await launch(url);
                                  }else{
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/blog.svg',
                                      width: 30,
                                      height: 30,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '博客',
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    )
                                  ],
                                ),
                                onTap: () async {
                                  const url = 'https://blogs.changbaiqi.top';
                                  if(await canLaunch(url)){
                                    await launch(url);
                                  }else{
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/qq.svg',
                                      width: 30,
                                      height: 30,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'QQ',
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  callQQ(number: 2084069833,isGroup: false);
                                },
                              ),
                            ),

                          ],
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            'By.长白崎\n本软件为免费软件如有贩卖请勿相信\n作者QQ：2084069833',
                            style: TextStyle(fontSize: 13, color: Colors.black45),
                            textAlign: TextAlign.center,
                          ),)
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),//软件申明信息
      ),
    ));
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
