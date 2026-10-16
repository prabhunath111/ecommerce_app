import 'package:get/get.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthController({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  });

  UserEntity? _currentUser;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => _currentUser = null,
      (user) => _currentUser = user,
    );
    update([GetBuilderIds.signInForm, GetBuilderIds.signUpForm, GetBuilderIds.profileInfo]);
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    update([GetBuilderIds.passwordVisibility]);
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    update([GetBuilderIds.authLoading, GetBuilderIds.signInForm]);

    final result = await loginUseCase(LoginParams(email: email.trim(), password: password));

    _isLoading = false;
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        update([GetBuilderIds.authLoading, GetBuilderIds.signInForm]);
        return false;
      },
      (user) {
        _currentUser = user;
        _errorMessage = null;
        update([
          GetBuilderIds.authLoading,
          GetBuilderIds.signInForm,
          GetBuilderIds.profileInfo,
        ]);
        return true;
      },
    );
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    update([GetBuilderIds.authLoading, GetBuilderIds.signUpForm]);

    final result = await signUpUseCase(
      SignUpParams(name: name.trim(), email: email.trim(), password: password),
    );

    _isLoading = false;
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        update([GetBuilderIds.authLoading, GetBuilderIds.signUpForm]);
        return false;
      },
      (user) {
        _currentUser = user;
        _errorMessage = null;
        update([
          GetBuilderIds.authLoading,
          GetBuilderIds.signUpForm,
          GetBuilderIds.profileInfo,
        ]);
        return true;
      },
    );
  }

  Future<void> logout() async {
    _isLoading = true;
    update([GetBuilderIds.authLoading]);

    await logoutUseCase(const NoParams());
    _currentUser = null;
    _isLoading = false;
    update([
      GetBuilderIds.authLoading,
      GetBuilderIds.signInForm,
      GetBuilderIds.profileInfo,
    ]);
  }
}
