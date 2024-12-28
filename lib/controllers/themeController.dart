import 'package:findjobs/screens/theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  ThemeData get themeData => isDarkMode.value ? darkTheme : lightTheme;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
