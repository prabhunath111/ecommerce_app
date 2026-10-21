import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/cart_usecases.dart';
import '../../features/cart/presentation/controllers/cart_controller.dart';

import '../../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/checkout/domain/usecases/checkout_usecases.dart';
import '../../features/checkout/presentation/controllers/checkout_controller.dart';

import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_categories_usecase.dart';
import '../../features/products/domain/usecases/get_product_by_id_usecase.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/products/presentation/controllers/product_controller.dart';

import '../../features/settings/data/datasources/theme_local_data_source.dart';
import '../../features/settings/presentation/controllers/theme_controller.dart';
import '../network/dio_client.dart';
import '../services/payment_service.dart';
import '../services/storage_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ----------------------------------------------------
  // External & Core Services
  // ----------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<StorageService>(
    () => SharedPreferencesStorageService(sl()),
  );
  sl.registerLazySingleton<PaymentService>(() => RazorpayPaymentService());
  sl.registerLazySingleton<DioClient>(() => DioClient(storageService: sl()));

  // ----------------------------------------------------
  // Theme & Appearance
  // ----------------------------------------------------
  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(storageService: sl()),
  );
  sl.registerLazySingleton<ThemeController>(
    () => ThemeController(themeLocalDataSource: sl()),
  );
  Get.put(sl<ThemeController>());

  // ----------------------------------------------------
  // Auth Feature
  // ----------------------------------------------------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storageService: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => AuthController(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  Get.put(sl<AuthController>());

  // ----------------------------------------------------
  // Products Feature
  // ----------------------------------------------------
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => ProductController(
      getProductsUseCase: sl(),
      getProductByIdUseCase: sl(),
      getCategoriesUseCase: sl(),
      toggleFavoriteUseCase: sl(),
    ),
  );
  Get.put(sl<ProductController>());

  // ----------------------------------------------------
  // Cart Feature
  // ----------------------------------------------------
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(storageService: sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateCartQuantityUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => CartController(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      updateCartQuantityUseCase: sl(),
      removeFromCartUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );
  Get.put(sl<CartController>());

  // ----------------------------------------------------
  // Checkout Feature
  // ----------------------------------------------------
  sl.registerLazySingleton<CheckoutRepository>(() => CheckoutRepositoryImpl());
  sl.registerLazySingleton(() => PlaceOrderUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOrderHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => CheckoutController(placeOrderUseCase: sl(), paymentService: sl()),
  );
  Get.put(sl<CheckoutController>());
}
