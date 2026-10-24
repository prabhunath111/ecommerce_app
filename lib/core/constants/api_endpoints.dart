class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://e-commerce-nodejs-app.onrender.com';

  static const String products = '/api/products';
  static const String categories = '/api/products/categories';
  static String productDetail(int id) => '/products/$id';
  static String productsByCategory(String category) => '/products/category/$category';

  // Auth endpoints (can be linked to standard auth backend)
  static const String signup = '/api/auth/signup';
  static const String login = '/api/auth/login';
  static const String users = '/users';

  // Cart endpoints
  static const String addToCart = '/api/cart/add';
}
