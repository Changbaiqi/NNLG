// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nnlg/dao/ClassScheduleDao.dart';
import 'package:nnlg/dao/ClassScheduleDatabase.dart';

import 'package:nnlg/main.dart';
// import 'package:nnlg/utils/edusys/Account.dart';
// import 'package:nnlg/utils/edusys/tools/EncryEncode.dart';

void main() async{
  // final database = await $FloorClassScheduleDatabase.databaseBuilder('app_database.db').build();
  // final dao = database.classScheduleDao;
  // GetIt getIt = GetIt.instance;
  // getIt.registerSingleton<ClassScheduleDao>(dao,signalsReady: true);
  // dao.findAllClassSchedule();
  // var findAllClassSchedule = GetIt.I<ClassScheduleDao>().findAllClassSchedule();
  // log('测试');
  // log(findAllClassSchedule.toString());
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
  // print(EncryEncode.toEncodeInp("21060231","3838438778*ABCab"));
  // Future<Account> account = new Account("21060231", "3838438778*ABCab").toLogin();
}
