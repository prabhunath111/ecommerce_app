import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  UserModel? getLastUser();
  Future<void> clearAuth();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService storageService;

  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> cacheUser(UserModel user) async {
    if (user.token != null) {
      await storageService.setString(AppConstants.authTokenKey, user.token!);
    }
    await storageService.setString(AppConstants.userDataKey, jsonEncode(user.toJson()));
  }

  @override
  UserModel? getLastUser() {
    final jsonStr = storageService.getString(AppConstants.userDataKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return UserModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearAuth() async {
    await storageService.remove(AppConstants.authTokenKey);
    await storageService.remove(AppConstants.userDataKey);
  }
}
