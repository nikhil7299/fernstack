import 'package:dio/dio.dart';
import 'package:fernstack/common/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final dio = ref.watch(dioProvider);
  return AdminService(
    dio: dio,
  );
});

abstract class IAdminService {
  
}

class AdminService implements IAdminService {
  final Dio _dio;

  AdminService({
    required Dio dio,
  }) : _dio = dio;


}
