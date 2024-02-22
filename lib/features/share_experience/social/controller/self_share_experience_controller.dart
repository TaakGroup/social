import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'base_share_experience_controller.dart';

class SelfShareExperienceController extends BaseShareExperienceController {
  SelfShareExperienceController(super.remoteRepository);

  static SelfShareExperienceController get to => Get.find();

  @override
  String get path => 'self';

  @override
  onSuccess(result) {
    super.onSuccess(result);

    if (result.totalCount == 0) change(null, status: RxStatus.empty());
  }
}
