import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/app.dart';
import 'core/app/config/app_setting.dart';
import 'core/app/constants/app_routes.dart';
import 'core/app/constants/messages.dart';
import 'core/app/utils/mixin/handle_failure_mixin.dart';
import 'core/app/view/themes/theme.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'initial_bindings.dart';
import 'routes.dart';

class ShareExperienceApp extends StatelessWidget {
  final String token;

  const ShareExperienceApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Share Experience",
      onInit: App.onAppStart(context, token),
      initialBinding: InitialBindings(),
      theme: ImpoTheme.light,
      themeMode: ThemeMode.light,
      locale: AppSetting.culture.locale,
      textDirection: AppSetting.culture.textDirection,
      translations: Messages(),
      getPages: Routs.routs,
      initialRoute: AppRoutes.shareExperience,
      routingCallback: HandleFailureMixin.onRouteChange,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: ResponsiveWrapper.builder(
          maxWidth: 475.0,
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
              statusBarBrightness: context.isDarkMode ? Brightness.dark : Brightness.light,
            ),
            child: child!,
          ),
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.autoScale(360, name: MOBILE),
            ResponsiveBreakpoint.resize(480, name: TABLET),
          ],
        ),
      ),
    );
  }
}
