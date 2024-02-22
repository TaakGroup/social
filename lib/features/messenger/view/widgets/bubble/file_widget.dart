import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/app_constants.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:open_file_plus/open_file_plus.dart';
import '../../../../../core/app/utils/classes/open_file_web.dart';
import '../../../../../core/app/config/app_setting.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';
import 'download_progress_widget.dart';

class FileWidget extends StatelessWidget {
  final String fileUrl;
  final String displayMediaName;
  final Color? iconColor, iconBackgroundColor, color, subtitleColor;
  Function()? onOpenPress;
  final bool? showProgress;

  FileWidget({
    Key? key,
    required this.fileUrl,
    this.iconBackgroundColor,
    this.color,
    this.showProgress,
    required this.displayMediaName,
    this.iconColor,
    this.subtitleColor,
  }) : super(key: key);

  openFile(String path) async {
    final String format = '.${displayMediaName.split('.').last}';
    String formatName = '*/*';
    for (var element in AppConstants.formats) {
      if (element.first == format) {
        formatName = element.last;
      }
    }

    if (kIsWeb) {
      OpenFileWeb.openFile('${AppSetting.baseUrl}/doctor/file/$fileUrl', fileUrl);
    } else {
      OpenFile.open(path, type: formatName);
    }
  }

  FileState({bool? isLoading, String? size}) {
    return Builder(builder: (context) {
      return Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      displayMediaName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: Get.context!.textTheme.labelSmall!.copyWith(color: color),
                    ),
                    const SizedBox(height: 2),
                    Builder(builder: (context) {
                      return Text(
                        size ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Decorations.subtitle.copyWith(color: subtitleColor),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            DownloadProgressWidget(
              isLoading: isLoading,
              progressColor: context.colorScheme.primary,
              innerColor: iconBackgroundColor,
              icon: SvgPicture.asset(
                AssetPaths.document,
                color: iconColor,
              ),
            ),
          ],
        ),
      );
    });
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 بایت";
    const suffixes = [" بایت", "کیلوبایت", "مگابایت", "گیگابایت", "ترابایت"];
    var i = (log(bytes) / log(1024)).floor();
    return "${((bytes / pow(1024, i))).toStringAsFixed(2)} ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileResponse>(
      stream: DefaultCacheManager().getFileStream('${AppSetting.baseUrl}/doctor/file/$fileUrl'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return FileState();
        } else if (snapshot.data is DownloadProgress) {
          DownloadProgress downloadProgress = snapshot.data as DownloadProgress;
          return FileState(isLoading: true);
        } else if (snapshot.data is FileInfo) {
          FileInfo fileInfo = snapshot.data as FileInfo;
          String size = getFileSizeString(bytes: fileInfo.file.lengthSync());
          return GestureDetector(
            onTap: () => openFile(fileInfo.file.path),
            child: FileState(isLoading: showProgress, size: size),
          );
        } else {
          return FileState(isLoading: true);
        }
      },
    );
  }
}
