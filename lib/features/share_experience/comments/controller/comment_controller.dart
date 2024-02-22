import 'package:get/get.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/features/share_experience/social/controller/base_share_experience_controller.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_topic_model.dart';

import '../../profile/data/models/profile_model.dart';
import '../../view/pages/new_experience_page.dart';

class CommentController extends BaseShareExperienceController {
  (ShareExperienceCommentModel comment, ProfileModel profile, List<ShareExperienceTopicModel> topics) arg = Get.arguments;
  late ShareExperienceCommentModel comment;
  late String shareId;

  CommentController(super.remoteRepository);

  static CommentController get to => Get.find();

  ProfileModel get profile => arg.$2;

  onWillBack() {
    Get.back(result: comment);
    return true;
  }

  @override
  String get path => 'comments/${comment.id}';

  @override
  like(ShareExperienceCommentModel comment, {String? path}) {
    return super.like(comment, path: "$shareId/comments/${comment.id}/like");
  }

  @override
  dislike(ShareExperienceCommentModel comment, {String? path, String? deletePath}) {
    return super.dislike(
      comment,
      path: "$shareId/comments/${comment.id}/dislike",
      deletePath: "$shareId/comments/${comment.id}/like",
    );
  }

  @override
  void onInit() {
    comment = arg.$1;
    shareId = comment.id;

    super.onInit();

    change(null, status: RxStatus.loading());

    getExperiences();
  }

  Future<void> newExperience() async {
    final bool? hasNewComment = await ShareNewExperiencePage.showSheet(
      arg.$2,
      arg.$3,
      hasImage: false,
      hasTopic: false,
      shareOn: '${comment.id}/comments',
    );

    if (hasNewComment == true) onRefresh();
  }

  openProfile(String userId) => Get.toNamed(
        AppRoutes.shareExperienceProfile,
        arguments: (
          userId,
          arg.$2,
          arg.$3,
        ),
      );

  @override
  onSuccess(result) {
    comment = result.currentComment;
    comment.id = shareId;

    update();
    return super.onSuccess(result);
  }
}
