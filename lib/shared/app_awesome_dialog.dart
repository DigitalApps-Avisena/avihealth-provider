import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class  AppAwesomeDialog{
  static void showError(
      BuildContext context, {
        required String title,
        required String desc,
      }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  static void showSuccess(
      BuildContext context, {
        required String title,
        required String desc,
      }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }
}