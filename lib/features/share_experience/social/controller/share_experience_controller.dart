import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/features/share_experience/social/controller/self_share_experience_controller.dart';
import 'package:social/features/share_experience/social/controller/share_experience_action_mixin.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_model.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../profile/data/models/profile_model.dart';
import '../../view/pages/new_experience_page.dart';
import '../../view/pages/new_experience_sheet.dart';
import '../data/models/share_experience_comment_model.dart';
import '../data/models/share_experience_topic_model.dart';
import 'other_share_experience_controller.dart';

class ShareExperienceController extends BaseController<ShareExperienceModel> with ShareExperienceActionMixin {
  late PageController tabController;
  Rx<ShareExperienceType> shareExperienceType = ShareExperienceType.other.obs;
  List<ShareExperienceCommentModel> pins = [];

  ShareExperienceController(super.remoteRepository);

  static ShareExperienceController get to => Get.find();

  @override
  onInit() {
    tabController = PageController();
    shareExperienceType.value = ShareExperienceType.other;
    initShareExperience();

    super.onInit();
  }

  initShareExperience() {
    OtherShareExperienceController.to.initPaging();
    SelfShareExperienceController.to.initPaging();

    getShareExperience();
  }

  onChangeTab(ShareExperienceType value) {
    tabController.animateToPage(value.index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    shareExperienceType.value = value;
  }

  getShareExperience() => find();

  @override
  onSuccess(ShareExperienceModel result) async {
    pins.addAll(result.pins.where((element) => element.isPin));
    OtherShareExperienceController.to.items.addAll(result.otherComments);
    if (result.selfComments.isEmpty) {
      SelfShareExperienceController.to.change(null, status: RxStatus.empty());
    } else {
      SelfShareExperienceController.to.items.addAll(result.selfComments);
      SelfShareExperienceController.to.change(null, status: RxStatus.success());
    }

    super.onSuccess(result);

    SchedulerBinding.instance.addPostFrameCallback((_) => tabController.jumpToPage(shareExperienceType.value.index));
  }

  newExperience(ProfileModel profile, List<ShareExperienceTopicModel> topics) async {
    final bool? hasNewExperience = await ShareNewExperienceSheet.showSheet(
      profile,
      topics,
      selectedTopicIndex: double.maxFinite.toInt(),
    );

    if (hasNewExperience == true) initShareExperience();
  }

  openTopic(ShareExperienceTopicModel topic, ProfileModel profile, List<ShareExperienceTopicModel> topics) =>
      Get.toNamed(AppRoutes.topic, arguments: (topic, profile, topics))?.then((result) {
        initShareExperience();
      });

  onComment(ShareExperienceCommentModel comment, ProfileModel profile, List<ShareExperienceTopicModel> topics) =>
      Get.toNamed(AppRoutes.comment, arguments: (comment, profile, topics))?.then(
        (result) {
          if (result != null) {
            final exp = OtherShareExperienceController.to.items.firstWhereOrNull((element) => element.id == comment.id);
            if (exp != null) {
              exp.likeCount.value = result.likeCount.value;
              exp.disliked.value = result.disliked.value;
              exp.commentCount?.value = result.commentCount?.value;
              exp.state?.value = result.state?.value;
            }
          }
        },
      );

  void openProfile(String userId, profile, topics) => Get.toNamed(
        AppRoutes.shareExperienceProfile,
        arguments: (
          userId,
          profile,
          topics,
        ),
      );
}
