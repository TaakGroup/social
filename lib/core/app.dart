
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:social/core/app/utils/helper/box_helpers.dart';
import 'app/config/app_setting.dart';

class App {

  static GetStorage box = GetStorage();
  static Logger logger = Logger(
    printer: PrettyPrinter(
      printEmojis: false,
      printTime: false,
      methodCount: 0,
      noBoxingByDefault: true,
    ),
  );

  static onAppStart(BuildContext context, String token) {
    initBox().then((value) => BoxHelper.setToken(token));
    SystemChrome.setPreferredOrientations(AppSetting.orientation); // Lock orientate
  }

  static Future initBox() async {
    await GetStorage.init();
    box = GetStorage();
  }
}
