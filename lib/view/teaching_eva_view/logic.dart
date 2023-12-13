import 'package:get/get.dart';
import 'package:nnlg/utils/TeachingEvaUtil.dart';
import 'package:nnlg/utils/edusys/tools/TeachingEva.dart';

import 'state.dart';

class TeachingEvaViewLogic extends GetxController {
  final TeachingEvaViewState state = TeachingEvaViewState();

  @override
  void onInit() {
    TeachingEvaUtil().getTeachingEvaList();
  }
}
