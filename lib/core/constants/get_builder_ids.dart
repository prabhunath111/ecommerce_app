/// Strongly typed GetBuilder IDs to ensure selective and efficient widget rebuilds.
class GetBuilderIds {
  GetBuilderIds._();

  // App & Theme
  static const String appTheme = 'app_theme_builder';

  // Auth IDs
  static const String signInForm = 'sign_in_form';
  static const String signUpForm = 'sign_up_form';
  static const String authLoading = 'auth_loading';
  static const String passwordVisibility = 'password_visibility';

  // Product IDs
  static const String productList = 'product_list';
  static const String categorySelector = 'category_selector';
  static const String bannerCarousel = 'banner_carousel';
  static const String searchResults = 'search_results';
  static String productFavorite(String productId) => 'product_fav_$productId';
  static const String productDetail = 'product_detail';

  // Cart IDs
  static const String cartBadge = 'cart_badge';
  static const String cartList = 'cart_list';
  static const String cartSummary = 'cart_summary';
  static const String promoCodeSection = 'promo_code_section';
  static String cartItemQuantity(String itemId) => 'cart_qty_$itemId';

  // Checkout IDs
  static const String addressSelector = 'address_selector';
  static const String paymentMethodSelector = 'payment_method_selector';
  static const String checkoutSummary = 'checkout_summary';
  static const String placeOrderButton = 'place_order_button';

  // Profile & Settings IDs
  static const String profileInfo = 'profile_info';
  static const String orderHistory = 'order_history';
  static const String settingsToggles = 'settings_toggles';
}
