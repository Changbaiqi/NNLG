import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MainViewState {
  final index = 2.obs;
  final pageController = PageController(initialPage: 2).obs;
  MainViewState() {
    ///Initialize variables
  }
}
