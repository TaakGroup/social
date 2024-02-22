import 'package:flutter/material.dart';
import 'package:social/features/messenger/data/models/user_info_model.dart';
import '../../../../features/share_experience/profile/data/models/profile_model.dart';
import '../../../app.dart';

class BoxHelper {
  static const _tokenKey = 'TOKEN';
  static const _userKey = 'USER';
  static const _themeMode = 'THEME_MODE';
  static const _firebaseToken = 'FIREBASE_TOKEN';
  static const _notificationPermission = 'NOTIFICATION_PERMISSION';

  static void clearBox() => App.box.erase();

  // Save
  static Future<void> save(String kay, value) => App.box.write(kay, value);

  static read(String kay) => App.box.read(kay);

  // TOKEN
  static void setToken(String userToken) => App.box.write(_tokenKey, userToken);

  static void removeToken() => App.box.remove(_tokenKey);

  static String? get getToken => App.box.read(_tokenKey);

  static bool get hasToken => (App.box.read(_tokenKey) ?? '').isNotEmpty;

  // Theme
  static ThemeMode get themeMode => ThemeMode.values[App.box.read(_themeMode) ?? 0];

  static void setThemeMode(ThemeMode themeMode) => App.box.write(_themeMode, themeMode.index);

  //  Firebase
  static Future<void> setFirebaseMessagingToken(String token) => App.box.write(_firebaseToken, token);

  static String? get firebaseToken => App.box.read(_firebaseToken);

  static Future<void> setNotificationPermissionSeen() => App.box.write(_notificationPermission, true);

  static bool get isNotificationPermissionSeen => App.box.read(_notificationPermission) ?? false;

  // User
  static saveUserProfile(ProfileModel userInfoModel) => save(_userKey, userInfoModel.toJson());

  static ProfileModel? getUserProfile() {
    final json = read(_userKey);
    return json != null ? UserInfoModel().fromJson(json) : null;
  }
}
