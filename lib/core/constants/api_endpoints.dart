class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://fakestoreapi.com';

  static const String products = '/products';
  static const String categories = '/products/categories';
  static String productDetail(int id) => '/products/$id';
  static String productsByCategory(String category) => '/products/category/$category';

  // Auth endpoints (can be linked to standard auth backend)
  static const String login = '/auth/login';
  static const String users = '/users';
}
