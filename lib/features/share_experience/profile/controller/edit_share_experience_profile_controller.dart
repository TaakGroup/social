import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../social/controller/upload_image_mixin.dart';
import '../data/models/profile_model.dart';

class EditShareExperienceProfileController extends BaseController  {
  late TextEditingController usernameTextController;
  final (ProfileModel profile, String hint) args = Get.arguments;
  late String? avatarImage;

  EditShareExperienceProfileController(super.remoteRepository);

  static EditShareExperienceProfileController get to => Get.find();

  ProfileModel get profile => args.$1;

  @override
  onInit() {
    change(null, status: RxStatus.success());
    usernameTextController =  TextEditingController(text: profile.username);
    avatarImage = profile.avatarImage;

    super.onInit();
  }

  onSubmit() {
    if (usernameTextController.text.isNotEmpty) {
      profile.username = usernameTextController.text;
      profile.avatarImage = avatarImage ?? profile.avatarImage;

      create(model: profile);
    }
  }

  @override
  onSuccess(result) {
    Get.back(result: true);

    return super.onSuccess(result);
  }
}
