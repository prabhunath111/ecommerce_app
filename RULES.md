# Trendify E-Commerce Flutter Project Rules & Architecture Guidelines

This project is a production-grade Flutter E-Commerce application built using **Clean Architecture**, **Feature-First Layering**, **GetX (ID-Based GetBuilder)** for state management, **GoRouter** for routing, **Dio** with interceptors for networking, and **Razorpay** for checkout payments.

---

## 1. Clean Architecture & Feature-First Directory Structure

Each feature resides under `lib/features/<feature_name>/` and contains three isolated layers:

```
lib/
├── core/
│   ├── constants/             # App-wide constants, GetBuilder IDs, API endpoints
│   ├── di/                    # Dependency injection (GetIt container)
│   ├── error/                 # Domain Failures & Data Exceptions
│   ├── network/               # Dio client, Interceptors (Auth, Logging, Error)
│   ├── services/              # External interfaces (PaymentService, StorageService)
│   ├── theme/                 # AppColors, Typography, Light & Dark ThemeData
│   ├── usecase/               # Base UseCase<Type, Params>
│   ├── utils/                 # Formatters, Helpers
│   └── widgets/               # Reusable UI components (AppButton, AppTextField, etc.)
└── features/
    ├── <feature_name>/
    │   ├── data/
    │   │   ├── datasources/   # Remote (Dio) and Local (SharedPreferences) datasources
    │   │   ├── models/        # JSON serializable data models extending domain entities
    │   │   └── repositories/  # Repository implementations returning Either<Failure, T>
    │   ├── domain/
    │   │   ├── entities/      # Core business entities extending Equatable
    │   │   ├── repositories/  # Abstract repository interfaces
    │   │   └── usecases/      # Single-responsibility use cases
    │   └── presentation/
    │       ├── controllers/   # GetxControllers calling update(['unique_id'])
    │       ├── screens/       # Screen widgets
    │       └── widgets/       # Feature-specific UI widgets
```

---

## 2. GetX State Management Rules (GetBuilder with IDs)

To ensure high performance and avoid unnecessary widget rebuilds:
1. **Always use `GetBuilder` with an explicit `id`** for any reactive/listener widget:
   ```dart
   GetBuilder<CartController>(
     id: CartIds.cartBadge,
     builder: (controller) => Badge(
       label: Text('${controller.itemCount}'),
       child: const Icon(Icons.shopping_bag_outlined),
     ),
   )
   ```
2. **Never call generic `update()` without IDs** if only a specific portion of the screen changed:
   ```dart
   // Good
   update([CartIds.cartBadge, CartIds.cartSummary]);

   // Avoid global rebuilds unless initializing the entire screen
   ```
3. Define all widget IDs in `core/constants/get_builder_ids.dart` to prevent typos and ensure maintainability.
4. Separate business logic from UI: Controllers invoke Use Cases and manage view state, while Widgets only render UI and dispatch events.

---

## 3. GoRouter Routing Rules

1. Define all routes centrally in `core/routes/app_router.dart`.
2. Use named constants for route paths in `core/routes/app_routes.dart`.
3. Use `CustomTransitionPage` for smooth page transitions (fade/slide).
4. Utilize `context.goNamed(...)` or `context.pushNamed(...)` for navigation.

---

## 4. Dio & Interceptors Rules

1. All HTTP requests must go through `DioClient`.
2. **AuthInterceptor**: Attach Authorization Bearer token automatically if the user is authenticated.
3. **LoggingInterceptor**: Log request method, URL, headers, payload, and response time in debug mode.
4. **ErrorInterceptor**: Intercept `DioException` and map status codes (400, 401, 403, 404, 500, timeout) into domain-level `Failure` objects (`ServerFailure`, `NetworkFailure`, `AuthFailure`).

---

## 5. Theme & Design System

1. Support **Light Theme** and **Dark Theme** globally via `ThemeController`.
2. Use centralized color tokens in `AppColors`:
   - Primary: `#6C5CE7` (Modern Violet)
   - Secondary: `#00CEC9` (Teal)
   - Accent: `#FD79A8`
   - Background Light: `#F8F9FA`, Background Dark: `#121212`
   - Surface Light: `#FFFFFF`, Surface Dark: `#1E1E1E`
3. Use Google Fonts (Poppins/Inter) with clean scale in `AppTextStyles`.
4. Use standard spacing multiples (4, 8, 12, 16, 20, 24, 32) from `AppSpacing`.

---

## 6. Payment Service & Razorpay Rules

1. Treat payment processing as an abstract domain service:
   ```dart
   abstract class PaymentService {
     void initialize({
       required Function(PaymentSuccessResponse) onSuccess,
       required Function(PaymentFailureResponse) onError,
       required Function(ExternalWalletResponse) onWallet,
     });
     Future<void> openCheckout(PaymentOptions options);
     void dispose();
   }
   ```
2. Implement `RazorpayPaymentService` implementing `PaymentService`.
3. Ensure mock/fallback mode exists for testing and non-mobile desktop platforms.

---

## 7. Testing Standards

1. Use `flutter_test` and `mocktail` for unit testing.
2. Unit tests must cover:
   - Use Cases (mocking repository interfaces)
   - Repositories (mocking remote & local datasources)
   - GetxControllers (verifying state changes and `update(['id'])` invocations)
3. Run tests using `flutter test`.
