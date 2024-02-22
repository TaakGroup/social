import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/utils/extensions/on_datetime/convertor.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';
import 'package:social/features/messenger/view/widgets/bubble/image_widget.dart';
import 'package:social/features/share_experience/comments/controller/reply_controller.dart';
import '../../../../../core/app/view/themes/styles/buttons/button_icon/elevated_button_icon.dart';
import '../../data/models/share_experience_comment_model.dart';

class ShareExperienceCommentWidget extends GetWidget<ReplyController> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ShareExperienceCommentModel comment;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool hasDeletePlaceholder;
  final bool hasReplayPlaceHolder;
  final void Function(String id)? onProfilePressed;
  final void Function(ShareExperienceCommentModel model)? onComment;
  final void Function(ShareExperienceCommentModel model)? onLike;
  final void Function(ShareExperienceCommentModel model)? onDislike;
  final void Function(ShareExperienceCommentModel model)? onDeletePressed;
  final void Function(ShareExperienceCommentModel model, AnimatedListState animatedList)? onReplyPressed;
  final void Function(ShareExperienceCommentModel model, ShareExperienceCommentModel reply)? onReplyLikePressed;
  final void Function(ShareExperienceCommentModel model, ShareExperienceCommentModel reply)? onReplyDislikePressed;
  final void Function(ShareExperienceCommentModel model, ShareExperienceCommentModel reply, Function(int) onRemoved)? onReplyDeletePressed;

  ShareExperienceCommentWidget({
    super.key,
    required this.comment,
    this.onLike,
    this.onDislike,
    this.onComment,
    this.backgroundColor,
    this.padding,
    this.onDeletePressed,
    this.onReplyPressed,
    this.onReplyLikePressed,
    this.onReplyDislikePressed,
    this.onReplyDeletePressed,
    this.onProfilePressed,
    this.hasDeletePlaceholder = true,
    this.hasReplayPlaceHolder = false,
  });

  AnimatedListState? get _animatedList => _listKey.currentState;

  Widget _buildRemovedItem(ShareExperienceCommentModel reply, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ShareExperienceCommentWidget(comment: reply),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: padding,
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => onProfilePressed?.call(comment.userId),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: ShapeDecoration(
                    color: context.colorScheme.surface,
                    shape: const CircleBorder(),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(comment.avatar),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onProfilePressed?.call(comment.userId),
                      child: Row(
                        children: [
                          Text(
                            comment.name!,
                            style: context.textTheme.labelMedium,
                          ),
                          const SizedBox(width: 8.0),
                          if (comment.approvedProfile)
                            SvgPicture.asset(
                              AssetPaths.verifyTick,
                              height: 16,
                              width: 16,
                            ),
                          const Spacer(),
                          Text(
                            '${comment.createTime.toNowText} ${comment.topicName != null && comment.topicName!.isNotEmpty ? '.' : ''} ${comment.topicName ?? ''}',
                            style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.outline),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onComment?.call(comment),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (comment.biography.isNotEmpty) const SizedBox(height: 4),
                          if (comment.biography.isNotEmpty)
                            Text(
                              comment.biography,
                              style: context.textTheme.bodySmall,
                            ),
                          const SizedBox(height: 8),
                          Text(
                            comment.text,
                            style: context.textTheme.bodySmall,
                          ),
                          if (comment.image != null && comment.image!.isNotEmpty) const SizedBox(height: 8),
                          if (comment.image != null && comment.image!.isNotEmpty)
                            AspectRatio(
                              aspectRatio: 1,
                              child: ImageWidget(
                                imageUrl: comment.image!,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (onReplyPressed != null)
                                ElevatedButtonIcon(
                                  color: ButtonColors.surface,
                                  size: ButtonSizes.small,
                                  onPressed: () => onReplyPressed?.call(comment, _animatedList!),
                                  label: Text(
                                    'پاسخ',
                                    style: context.textTheme.labelSmallProminent,
                                  ),
                                  icon: SvgPicture.asset(
                                    AssetPaths.reply,
                                    color: context.colorScheme.outline,
                                  ),
                                )
                              else if (hasReplayPlaceHolder)
                                const Spacer()
                              else
                                const SizedBox(),
                              if (comment.commentCount == null) const Spacer(),
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: comment.state != null ? () => onLike?.call(comment) : null,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          comment.state?.value == ExperienceActionState.like ? AssetPaths.likeFill : AssetPaths.like,
                                          height: 20,
                                          width: 20,
                                          color: comment.state?.value == ExperienceActionState.like
                                              ? context.colorScheme.primary
                                              : context.colorScheme.outline,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            comment.likeCount.value.toString(),
                                            style: context.textTheme.bodyLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    onTap: comment.state != null ? () => onDislike?.call(comment) : null,
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      mainAxisAlignment: onDeletePressed != null && comment.selfExperience
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          comment.state?.value == ExperienceActionState.dislike
                                              ? AssetPaths.dislikeFill
                                              : AssetPaths.dislike,
                                          height: 20,
                                          width: 20,
                                          color: comment.state?.value == ExperienceActionState.dislike
                                              ? context.colorScheme.primary
                                              : context.colorScheme.outline,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Align(
                                            alignment: comment.commentCount != null &&
                                                    onComment != null &&
                                                    onDeletePressed != null &&
                                                    comment.selfExperience
                                                ? Alignment.centerLeft
                                                : Alignment.center,
                                            child: Text(
                                              comment.disliked.value.toString(),
                                              style: context.textTheme.bodyLarge,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (comment.commentCount != null && onComment != null) const Spacer(),
                              if (comment.commentCount != null && onComment != null)
                                Expanded(
                                  child: Obx(
                                    () => Row(
                                      mainAxisAlignment: onDeletePressed != null && comment.selfExperience
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(AssetPaths.message),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            comment.commentCount.toString(),
                                            style: context.textTheme.bodyLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (onDeletePressed != null && comment.selfExperience) const Spacer(),
                              if (onDeletePressed != null && comment.selfExperience)
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () => onDeletePressed?.call(comment),
                                    child: SvgPicture.asset(
                                      AssetPaths.trash,
                                      height: 20,
                                      width: 20,
                                      color: context.colorScheme.outline,
                                    ),
                                  ),
                                )
                              else if (hasDeletePlaceholder)
                                const SizedBox(width: 20, height: 20)
                              else
                                const SizedBox()
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    if (onReplyPressed != null)
                      controller.obx(
                        (_) => AnimatedList(
                          key: _listKey,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          initialItemCount: comment.replies.length,
                          itemBuilder: (BuildContext context, int index, animation) => ShareExperienceCommentWidget(
                            comment: comment.replies[index],
                            onLike: (reply) => onReplyLikePressed?.call(comment, reply),
                            onDislike: (reply) => onReplyDislikePressed?.call(comment, reply),
                            hasDeletePlaceholder: false,
                            hasReplayPlaceHolder: true,
                            onProfilePressed: onProfilePressed,
                            onDeletePressed: (reply) => onReplyDeletePressed?.call(
                              comment,
                              reply,
                              (index) => _animatedList?.removeItem(
                                index,
                                (context, animation) => _buildRemovedItem(reply, context, animation),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
        controller.obx((_) {
          if (comment.replies.isNotEmpty && comment.remainReplyCount > 0) {
            return Obx(
              () => SizedBox(
                child: controller.isPaginationLoading.value
                    ? Center(child: LoadingIndicatorWidget(color: context.colorScheme.primary))
                    : GestureDetector(
                        onTap: () => controller.getMoreReplies(comment, _animatedList!),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Divider(
                                color: context.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'مشاهده ${comment.remainReplyCount} پاسخ به ${comment.name}',
                              style: context.textTheme.labelSmallProminent?.copyWith(color: context.colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          } else {
            return const SizedBox();
          }
        })
      ],
    );
  }
}
