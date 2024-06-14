import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/utils/TeachingEvaUtil.dart';

import 'logic.dart';

class EvalFormViewPage extends StatelessWidget {
  EvalFormViewPage({Key? key}) : super(key: key);

  final logic = Get.find<EvalFormViewLogic>();
  final state = Get.find<EvalFormViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Get.arguments['courseName']),
        ),
        body: Obx(() => state.formJsonData.value != null
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount:
                            (state.formJsonData.value!['classList'] as List)
                                .length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Text(state.formJsonData
                                        .value!['classList'][index]['className'],style: TextStyle(fontSize: 18),),
                                    Text('（${state.formJsonData
                                        .value!['classList'][index]['rate']}）',style: TextStyle(color: Colors.red,fontSize: 18),),
                                  ],
                                )
                              ),
                              Column(
                                children:
                                    ((state.formJsonData.value!['classList']
                                                as List)[index]['problemList']
                                            as List)
                                        .map((problemE) => Column(
                                              children: [
                                                Text(problemE['title']),
                                                Wrap(
                                                  children:
                                                      (problemE['selectList']
                                                              as List)
                                                          .map(
                                                              (selectE) =>
                                                                  Container(
                                                                    width: 90,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(selectE[
                                                                            'text']),
                                                                        Checkbox(
                                                                            value:
                                                                                selectE['checked'],
                                                                            onChanged: (v) {
                                                                              (problemE['selectList'] as List).forEach((element) {
                                                                                if (element['name'] == selectE['name'])
                                                                                  element['checked'] = true;
                                                                                else
                                                                                  element['checked'] = false;
                                                                              });
                                                                              state.formJsonData.refresh();
                                                                            })
                                                                      ],
                                                                    ),
                                                                  ))
                                                          .toList(),
                                                )
                                              ],
                                            ))
                                        .toList(),
                              )
                              // ListView.builder(
                              //     itemCount: (state.formJsonData.value!['classList'] as List)[index]['problemList'].length,
                              //     itemBuilder: (BuildContext ctxt1,int index1){
                              //
                              // })
                            ],
                          );
                        }),
                    flex: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (logic.checkSubmit(state.formJsonData.value)) {
                                TeachingEvaUtil()
                                    .submitEva(state.formJsonData.value, 1)
                                    .then((value) {
                                  Get.snackbar(
                                    "评教通知",
                                    "$value",
                                    duration: Duration(milliseconds: 1500),
                                  );
                                  Get.back();
                                });
                              } else {
                                Get.snackbar(
                                  "评教通知",
                                  "您还有未评教的选项，请全部选择完后再提交。",
                                  duration: Duration(milliseconds: 1500),
                                );
                              }
                            },
                            child: Text('提交')),
                        flex: 1,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (logic.checkSubmit(state.formJsonData.value)) {
                                TeachingEvaUtil()
                                    .submitEva(state.formJsonData.value, 0)
                                    .then((value) => Get.snackbar(
                                          "评教通知",
                                          "$value",
                                          duration:
                                              Duration(milliseconds: 1500),
                                        ));
                              } else {
                                Get.snackbar(
                                  "评教通知",
                                  "您还有未评教的选项，请全部选择完后再保存。",
                                  duration: Duration(milliseconds: 1500),
                                );
                              }
                            },
                            child: Text('保存')),
                        flex: 1,
                      ),
                    ],
                  )
                ],
              )
            : Container()));
  }
}
