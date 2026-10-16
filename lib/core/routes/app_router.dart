import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/main/presentation/screens/main_shell_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const MainShellScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: 'signin',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const SignInScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: 'signup',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const CartScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'product_detail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return _buildCustomTransition(
            state: state,
            child: ProductDetailScreen(productId: id),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildCustomTransition(
          state: state,
          child: const SettingsScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );

  static CustomTransitionPage _buildCustomTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        );
      },
    );
  }
}
