import 'package:flutter/material.dart';

/**
 * 共享课表
 */
class Course_Shared extends StatefulWidget {
  const Course_Shared({Key? key}) : super(key: key);

  @override
  State<Course_Shared> createState() => _Course_SharedState();
}

class _Course_SharedState extends State<Course_Shared> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('开始'),
        elevation: 0,
      ),
      body: Column(
        children: [
          ListView(
            children: [
            ],
          )
        ],
      ),
    );
  }


}
