import 'dart:ui';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import '../../../../core/app/config/app_setting.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../controller/new_experience_controller.dart';
import '../../profile/data/models/profile_model.dart';
import '../../social/controller/share_experience_media_controller.dart';
import '../../social/data/models/share_experience_topic_model.dart';
import 'get_topic_sheet.dart';

class ShareNewExperiencePage extends StatelessWidget {
  final ProfileModel profile;
  final bool hasImage, hasTopic;
  final String? shareOn;
  final List<ShareExperienceTopicModel> topics;

  const ShareNewExperiencePage({
    super.key,
    required this.profile,
    required this.hasImage,
    required this.topics,
    required this.hasTopic,
    this.shareOn,
  });

  static showSheet(
    ProfileModel profile,
    List<ShareExperienceTopicModel> topics, {
    bool? hasImage,
    bool? hasTopic,
    int? selectedTopicIndex,
    String? shareOn,
  }) async {
    NewExperienceController.to.selectedTopicIndex.value = selectedTopicIndex ?? NewExperienceController.to.selectedTopicIndex.value;
    NewExperienceController.to.isTopicSelected.value = NewExperienceController.to.selectedTopicIndex.value < topics.length;
    if (NewExperienceController.to.isTopicSelected.value) {
      NewExperienceController.to.experience.topicId = topics[NewExperienceController.to.selectedTopicIndex.value].id;
    }

    return await Get.bottomSheet(
      ShareNewExperiencePage(
        profile: profile,
        hasImage: hasImage ?? true,
        hasTopic: hasTopic ?? true,
        topics: topics,
        shareOn: shareOn,
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewExperienceController>(
      builder: (controller) => SafeArea(
        child: Container(
          color: context.colorScheme.background,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(Decorations.paddingHorizontal).copyWith(top: 8),
                  color: context.colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تجربه جدید',
                            style: context.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: Get.back,
                            icon: SvgPicture.asset(
                              AssetPaths.close,
                              color: context.colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      const SizedBox(width: double.infinity, height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider('${AppSetting.baseUrl}/doctor/file/${profile.avatarImage}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      profile.username,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                    Obx(
                                      () => Text(
                                        '${controller.inputCounter.value}/400',
                                        style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.outline),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                AnimatedSize(
                                  alignment: Alignment.topCenter,
                                  duration: const Duration(milliseconds: 200),
                                  clipBehavior: Clip.hardEdge,
                                  child: TextFormField(
                                    maxLength: 400,
                                    onChanged: controller.onTextChanged,
                                    autofocus: true,
                                    minLines: 1,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(bottom: 24),
                                      hintText: 'تجربت رو اینجا بنویس...',
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      hintStyle: context.textTheme.labelLarge,
                                      counter: const SizedBox(),
                                    ),
                                  ),
                                ),
                                if (hasImage)
                                  GetBuilder<ShareExperienceMediaController>(
                                    builder: (controller) => UploadImageWidget(controller: controller),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(Decorations.paddingHorizontal),
                  child: ElevationStateButton(
                    size: ButtonSizes.small,
                    onPressed: () => controller.sendExperience(shareId: shareOn),
                    state: controller,
                    text: 'پست کردن',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadImageWidget extends StatelessWidget {
  final ShareExperienceMediaController controller;

  const UploadImageWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSize(
        duration: Duration(milliseconds: 200),
        alignment: Alignment.center,
        child: Container(
          child: controller.hasImage.value
              ? Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Stack(
                    children: [
                      Obx(
                        () => Blur(
                          blur: controller.imageLoading.value ? 5 : 0,
                          overlay: controller.imageLoading.value
                              ? CircularProgressIndicator(color: context.colorScheme.background)
                              : const SizedBox(),
                          colorOpacity: 0.1,
                          blurColor: Colors.grey,
                          child: Image.memory(controller.pickedImage!),
                        ),
                      ),
                      Obx(
                        () => Container(
                          child: !controller.imageLoading.value
                              ? Positioned(
                                  top: 8,
                                  right: 8,
                                  width: 24,
                                  height: 24,
                                  child: GestureDetector(
                                    onTap: controller.onRemoveImage,
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        shape: const CircleBorder(),
                                      ),
                                      child: SvgPicture.asset(
                                        AssetPaths.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                )
              : IconButton(
                  icon: SvgPicture.asset(AssetPaths.galleryAdd),
                  onPressed: controller.onPickImagePressed,
                ),
        ),
      ),
    );
  }
}
