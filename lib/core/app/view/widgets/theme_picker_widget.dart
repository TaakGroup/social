import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import '../../constants/assets_paths.dart';
import '../../utils/helper/box_helpers.dart';
import 'radio_list_tile_widget.dart';

class ThemePickerWidget extends StatelessWidget {
  Rx<ThemeMode> themeMode = BoxHelper.themeMode.obs;

  ThemePickerWidget({Key? key}) : super(key: key);

  static showDialog() {
    return Get.bottomSheet(
      ThemePickerWidget(),
      isScrollControlled: true,
    );
  }

  onThemeModeChange(ThemeMode newThemeMode) {
    themeMode.value = newThemeMode;
    BoxHelper.setThemeMode(newThemeMode);
    Get.changeThemeMode(newThemeMode);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      color: context.colorScheme.background,
      child: Obx(
        () => Wrap(
          children: [
            IconRadioListTile(
              title: 'حالت روز',
              icon: SvgPicture.asset(AssetPaths.sun, colorFilter: ColorFilter.mode(context.colorScheme.onBackground, BlendMode.srcIn)),
              value: themeMode.value == ThemeMode.light,
              onChanged: () => onThemeModeChange(ThemeMode.light),
            ),
            const Divider(height: 24),
            IconRadioListTile(
              title: 'حالت شب',
              icon: SvgPicture.asset(AssetPaths.moon, colorFilter: ColorFilter.mode(context.colorScheme.onBackground, BlendMode.srcIn)),
              value: themeMode.value == ThemeMode.dark,
              onChanged: () => onThemeModeChange(ThemeMode.dark),
            ),
            const Divider(height: 24),
            IconRadioListTile(
              title: 'دیفالت سیستم',
              icon: SvgPicture.asset(AssetPaths.setting2, colorFilter: ColorFilter.mode(context.colorScheme.onBackground, BlendMode.srcIn)),
              value: themeMode.value == ThemeMode.system,
              onChanged: () => onThemeModeChange(ThemeMode.system),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
