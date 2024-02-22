import 'package:dio/dio.dart';
import 'package:taakitecture/core/interfaces/client.dart';
import '../../config/app_setting.dart';
import 'service_lifecycle.dart';
import 'service_logger.dart';

class DioClient extends IClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = AppSetting.baseUrl;
    _dio.interceptors.add(ServiceLifecycle());
    _dio.interceptors.add(ServiceLogger());
  }

  @override
  delete(String path) async => (await _dio.delete(path)).data;

  @override
  get(String path) async => (await _dio.get(path)).data;

  @override
  post(String path, {Map<String, dynamic>? data}) async => (await _dio.post(path, data: data)).data;

  @override
  put(String path, {Map<String, dynamic>? data}) async => (await _dio.put(path, data: data)).data;

  @override
  upload(String path, {required formData}) async => (await _dio.post(path, data: formData)).data;
}


