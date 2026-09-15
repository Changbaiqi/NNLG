import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:callo/dao/CourseData.dart';
import 'package:callo/utils/CourseWidgetUtil.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;

  setUp(() {
    calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('home_widget'),
            (call) async {
      calls.add(call);
      return true;
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('com.cbq.callocollege/shortcut'), (call) async {
      calls.add(call);
      return true;
    });

    CourseData.schoolOpenTime.value = '2026/9/1';
    CourseData.ansWeek.value = 20;
    CourseData.courseTime.value = [
      '08:30-09:15',
      '09:20-10:05',
      '10:25-11:10',
      '11:15-12:00',
      '14:30-15:15',
      '15:20-16:05',
      '16:15-17:00',
      '17:05-17:50',
      '18:20-19:05',
      '19:10-19:55',
      '20:05-20:50',
      '20:55-21:40',
    ];

    final course = {
      'courseName': '高等数学',
      'courseClassRoom': '教1-101',
      'courseTeacher': '张老师',
    };

    // 一周：12 节 × 7 天；周一第 1-2 节、周五第 5 节有课
    final week = List.generate(12, (period) {
      return List.generate(7, (day) {
        if (day == 0 && (period == 0 || period == 1)) return [course];
        if (day == 4 && period == 4) return [course];
        return <dynamic>[];
      });
    });

    CourseData.weekCourseJson.value = {
      'courses': [week],
      'remark': '测试备注',
    };
    CourseData.weekCourseJson.refresh();
  });

  Map<String, dynamic> lastPayload() {
    final save = calls.lastWhere((c) => c.method == 'saveWidgetData');
    return jsonDecode(save.arguments['data'] as String) as Map<String, dynamic>;
  }

  test('updateCourseWidget builds and saves payload', () async {
    await CourseWidgetUtil.updateCourseWidget();
    final payload = lastPayload();

    expect(payload['open'], '2026/9/1');
    expect(payload['ans'], 20);
    expect(payload.containsKey('dark'), true);
    expect(payload.containsKey('text'), true);
    expect(payload.containsKey('accent'), true);

    final weeks = payload['weeks'] as List;
    expect(weeks.length, 1);
    final days = weeks.first as List;
    expect(days.length, 7);

    final monday = days[0] as List;
    expect(monday.length, 1);
    final merged = monday.first as Map;
    expect(merged['n'], '高等数学');
    expect(merged['p'], '第1-2节');
    expect(merged['s'], '08:30');
    expect(merged['e'], '10:05');
    expect(merged['r'], '教1-101');
    expect(merged.containsKey('c'), true);

    final friday = days[4] as List;
    expect(friday.length, 1);
    expect((friday.first as Map)['p'], '第5节');

    expect(calls.any((c) => c.method == 'updateWidget'), true);
    expect(
        calls.any((c) => c.method == 'refreshCourseWidget'), true);
  });

  test('调整开学日期后版本号与日期变化，课表数据不变', () async {
    await CourseWidgetUtil.updateCourseWidget();
    final before = lastPayload();

    CourseData.schoolOpenTime.value = '2026/9/8';
    await CourseWidgetUtil.updateCourseWidget();
    final after = lastPayload();

    expect(after['open'], '2026/9/8');
    expect(after['ans'], 20);
    expect(after['v'] != before['v'], true);
    expect(jsonEncode(after['weeks']), jsonEncode(before['weeks']));
  });
}
