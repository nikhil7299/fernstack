import 'package:dio/dio.dart';
import 'package:fernstack/env.dart';
import 'package:fernstack/features/user/controller/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart' show TalkerDioLogger;

final dioProvider = Provider<Dio>((ref) {
  final dioOptions = BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/json; charset=UTF-8',
  );
  final dio = Dio(dioOptions);
  dio.interceptors.add(TalkerDioLogger());
  return dio;
});

final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider);

  if (user == null) {
    return false;
  }
  return user.type == 'admin';
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
  return storage;
});
