class AppConstants {
  AppConstants._();

  static const String appName = 'Trendify';
  static const String appTagline = 'Curated Fashion & Lifestyle';

  // Storage Keys
  static const String themeKey = 'app_theme_mode';
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_items';

  // Razorpay Test Credentials (Replace with your actual keys in prod)
  static const String razorpayKeyId = 'rzp_test_1DP5mmOlF5G5ag';
  static const String currency = 'INR';
  static const String currencySymbol = '₹';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
