import 'package:get/get.dart';
import '../../../../core/app/constants/app_routes.dart';
import '../../profile/data/models/profile_model.dart';
import '../../social/controller/base_share_experience_controller.dart';
import '../../social/data/models/share_experience_comment_model.dart';
import '../../social/data/models/share_experience_topic_model.dart';
import '../../view/pages/new_experience_page.dart';

class TopicController extends BaseShareExperienceController {
  final (ShareExperienceTopicModel topic, ProfileModel profile, List<ShareExperienceTopicModel> topics) arg = Get.arguments;

  TopicController(super.remoteRepository);

  static TopicController get to => Get.find();

  @override
  String get path => 'topic/${topic.id}';

  ShareExperienceTopicModel get topic => arg.$1;

  List<ShareExperienceTopicModel> get topics => arg.$3;

  ProfileModel get profile => arg.$2;

  @override
  void onInit() {
    super.onInit();

    change(null, status: RxStatus.loading());

    getExperiences();
  }

  Future<void> newExperience() async {
    final bool? hasNewExperience = await ShareNewExperiencePage.showSheet(
      arg.$2,
      arg.$3,
      selectedTopicIndex: arg.$3.indexOf(topic),
    );

    if (hasNewExperience == true) onRefresh();
  }

  onComment(ShareExperienceCommentModel comment) => Get.toNamed(AppRoutes.comment, arguments: (comment, arg.$2, arg.$3))?.then((value) => onRefresh());
}
