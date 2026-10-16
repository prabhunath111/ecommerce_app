import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/get_builder_ids.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize all dependencies (Clean DI with GetIt & GetX)
  await di.initDependencies();

  runApp(const TrendifyEcommerceApp());
}

class TrendifyEcommerceApp extends StatelessWidget {
  const TrendifyEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Global App-Level Theme handled via GetBuilder with unique ID
    return GetBuilder<ThemeController>(
      id: GetBuilderIds.appTheme,
      builder: (themeController) {
        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
