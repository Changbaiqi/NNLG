import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'logic.dart';

class MainCourseNewViewPage extends StatelessWidget {
  MainCourseNewViewPage({Key? key}) : super(key: key);

  final logic = Get.find<MainCourseNewViewLogic>();
  final state = Get.find<MainCourseNewViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: DataTable(
          columns: [
            DataColumn(
              numeric: true,
                label: Container(
              child: Text('测试'),
            )),
            DataColumn(
                label: Container(
                  child: Text('测试'),
                )),
            DataColumn(
                label: Container(
                  child: Text('测试'),
                )),
            DataColumn(
                label: Container(
                  child: Text('测试'),
                )),
            DataColumn(
                label: Container(
                  child: Text('测试'),
                ))
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('测试')),
              DataCell(Text('测试')),
              DataCell(Text('测试')),
              DataCell(Text('测试')),
              DataCell(Text('测试'))
            ])
          ],
        ),
      ),
    );
  }
}
