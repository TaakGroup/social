import 'package:get/get.dart';
import 'package:social/core/app/utils/mixin/handle_failure_mixin.dart';
import 'package:social/features/share_experience/social/controller/share_experience_action_mixin.dart';
import 'package:social/features/share_experience/social/controller/share_experience_controller.dart';
import 'package:taakitecture/taakitecture.dart';

import '../data/models/share_experience_comment_model.dart';

abstract class BaseShareExperienceController extends BaseController with ScrollMixin, ShareExperienceActionMixin, HandleFailureMixin {
  late int totalCount;
  final RxBool isPaginationLoading = false.obs;
  int pageSize = 10;
  int pageNo = 0;
  bool isInitialLoading = true;
  List<ShareExperienceCommentModel> items = [];

  String get path;

  BaseShareExperienceController(super.remoteRepository);

  initPaging() {
    totalCount = double.maxFinite.toInt();
    isPaginationLoading.value = false;
    isInitialLoading = true;
    pageNo = 0;
    items.clear();
  }

  @override
  void onInit() {
    initPaging();
    change(null, status: RxStatus.success());

    super.onInit();
  }

  @override
  onLoading() {
    return;
  }

  Future getExperiences() async {
    final request = await find('$path/$pageNo/$pageSize');

    request.fold(
      (l) {},
      (r) {
        totalCount = r.totalCount;
        items.addAll(r.list);
        isPaginationLoading.value = false;

        if (totalCount == 0) {
          change(items, status: RxStatus.empty());
        } else {
          change(items, status: RxStatus.success());
        }
      },
    );
  }

  Future<void> onRefresh() {
    initPaging();
    return getExperiences();
  }

  @override
  Future<void> onEndScroll() async {
    if (totalCount > pageNo * pageSize) {
      pageNo++;
      isPaginationLoading.value = true;
      getExperiences();
    }
  }

  @override
  Future<void> onTopScroll() async {}

  @override
  onSuccess(result) {
    try {
      totalCount = result.totalCount;
    } catch (_) {}
  }

  @override
  deleteExperience(ShareExperienceCommentModel comment) {
    super.deleteExperience(comment).then((_) => ShareExperienceController.to.initShareExperience());
  }

  @override
  deleteComment(ShareExperienceCommentModel comment, String shareId) {
    return super.deleteComment(comment, shareId).then((_) => onRefresh());
  }
}
