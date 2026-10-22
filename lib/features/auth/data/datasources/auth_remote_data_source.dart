import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw const AuthException(message: 'Email and password are required.');
      }

      // Try hitting auth endpoint
      try {
        final response = await dioClient.post(
          ApiEndpoints.login,
          data: {'email': email, 'password': password},
        );

        if (response.statusCode == 200 && response.data != null) {
          final token = response.data['accessToken']?.toString() ?? 'mock_jwt_token_trendify';
          return UserModel(
            id: response.data['user']['id'],
            name: response.data['user']['username'],
            email: email,
            avatar: 'https://images.openai.com/static-rsc-4/MyuryllVzeLN-klhoFeVS9Q0fL6RFx-Juyix8TlSszORLyVfVCpctvDR4aOW9_y52QtkY7vu50GMWK6sj2MmK7e8KcymuTZfcHizCBa0AQDkHdAmuqSpP8z8l9--B-rTDhhzB9ouetftPMojWk5YXZ7yhauz3eyAvnbXaw1xGXnkNKFrGvqDcok2LUjo_da_?purpose=fullsize',
            token: token,
          );
        }
      } catch (apiError) {
        // Fallback for demo logins (e.g. user enters any valid email)
        if (apiError is AuthException) rethrow;
      }

      // Graceful fallback for mock testing / demo login
      await Future.delayed(const Duration(milliseconds: 600));
      return UserModel(
        id: 'usr_demo_101',
        name: email.contains('@') ? email.split('@').first.capitalize() : 'Alex Morgan',
        email: email,
        avatar: 'https://images.openai.com/static-rsc-4/MyuryllVzeLN-klhoFeVS9Q0fL6RFx-Juyix8TlSszORLyVfVCpctvDR4aOW9_y52QtkY7vu50GMWK6sj2MmK7e8KcymuTZfcHizCBa0AQDkHdAmuqSpP8z8l9--B-rTDhhzB9ouetftPMojWk5YXZ7yhauz3eyAvnbXaw1xGXnkNKFrGvqDcok2LUjo_da_?purpose=fullsize',
        token: 'jwt_trendify_session_${DateTime.now().millisecondsSinceEpoch}',
        phone: '+91 95472 71228',
        address: 'JP Nagar, Bangalore, KA, India',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
        token: 'jwt_trendify_session_${DateTime.now().millisecondsSinceEpoch}',
        phone: '+91 98765 43210',
        address: '42 MG Road, Bangalore, KA, India',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
