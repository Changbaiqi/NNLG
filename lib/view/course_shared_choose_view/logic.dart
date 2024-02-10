import 'package:get/get.dart';

import 'state.dart';

class CourseSharedChooseViewLogic extends GetxController {


  final CourseSharedChooseViewState state = CourseSharedChooseViewState();


  @override
  void onInit() {
    state.initGetSharedAccountList();
  }
}
