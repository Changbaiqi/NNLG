import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class EvalFormViewPage extends StatelessWidget {
  EvalFormViewPage({Key? key}) : super(key: key);

  final logic = Get.find<EvalFormViewLogic>();
  final state = Get.find<EvalFormViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('遵守教学纪律，不随意调课、停课'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('按教学进度和课表安排授课，不随意减少学时'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('治学严谨、有较强的敬业精神'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('课前准备充分，有较强的敬业精神'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('言传身教，为人师表'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师普通话标准，语言表达准确、条理清楚，声音洪亮'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师教态端正，言行举止文明'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('课件质量高，板书工整，布局合理'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('开课之初，教师能向学生明确宣布考核及评级方式'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('内容充实，有适当的深广度'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师讲课思路清晰，阐述准确'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师讲清概念和难点，突出重点'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师善于运用恰当的教学方法和教学手段，调动学生积极性'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('理论联系实际，恰当的选择实例，能介绍本课程的前沿情况，注重内容更新'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('师生互动交流好，师生关系融洽'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('加强课堂纪律、课外作业、答疑等教学环节的管理，严格要求学生'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师能激发学生的求知欲，提高其学习兴趣'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('对学生知识的获得、能力的培养和素质的提高很有帮助'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师的言传身教给学生留下了很好的印象'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('教师的讲课有自己的风格、特色'),
              Row(
                children:  [

                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('1分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('2分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('3分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('4分')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: '5', groupValue: 1, onChanged: (v){
                      }),
                      Text('5分')
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
