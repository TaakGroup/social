import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/mixin/handle_failure_mixin.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../core/app/config/app_setting.dart';
import 'image_picker_mixin.dart';
import 'messenger_media_mixin.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MessengerMediaController extends BaseController with ImagePickerMixin, MessengerMediaMixin, HandleFailureMixin {
  List<String> sendVoices = [];

  MessengerMediaController(super.remoteRepository);

  static MessengerMediaController get to => Get.find();

  @override
  onImagePicked(XFile bytes) async {
    uploadFileData(bytes);
    super.onImagePicked(bytes);
  }

  onVoiceRecorded(String? path) async {
    if (path != null && path.isNotEmpty && !sendVoices.contains(path)) {
      sendVoices.add(path);
      uploadFileData(XFile(path));
    }
  }

  @override
  onFilePicked(XFile bytes) async {
    uploadFileData(bytes);
    super.onFilePicked(bytes);
  }

  Future uploadFileData(XFile xFile) async {
    final file = dio.MultipartFile.fromBytes(await xFile.readAsBytes(), filename: xFile.name);

    final formData = dio.FormData();
    formData.files.add(MapEntry('files', file));
    uploadFile(formData: formData).then(
      (response) => response.fold(
        (l) {
          // TODO : when upload file failed
        },
        (r) async {
          await DefaultCacheManager().putFile('${AppSetting.baseUrl}/doctor/file/${r.name}', await xFile.readAsBytes());
        },
      ),
    );
  }

  @override
  onSuccess(result) {
    if (result.valid) {
      // MessengerController.to.sendMessage(media: result.name);
    }
  }
}
