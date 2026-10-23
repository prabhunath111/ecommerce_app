import 'package:get/get.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

class ProductController extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  ProductController({
    required this.getProductsUseCase,
    required this.getProductByIdUseCase,
    required this.getCategoriesUseCase,
    required this.toggleFavoriteUseCase,
  });

  List<ProductEntity> _products = [];
  List<CategoryEntity> _categories = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _limit = 10;
  String? _errorMessage;
  ProductEntity? _selectedProduct;

  List<ProductEntity> get products => _products;
  List<CategoryEntity> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  String? get errorMessage => _errorMessage;
  ProductEntity? get selectedProduct => _selectedProduct;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadProducts();
  }

  Future<void> loadCategories() async {
    final result = await getCategoriesUseCase(const NoParams());
    result.fold(
      (failure) => null,
      (cats) {
        _categories = cats;
        update([GetBuilderIds.categorySelector]);
      },
    );
  }

  Future<void> loadProducts({bool refresh = false}) async {
    _currentPage = 1;
    _hasMore = true;
    _isLoading = true;
    _errorMessage = null;
    update([GetBuilderIds.productList]);

    final result = await getProductsUseCase(
      GetProductsParams(
        category: _selectedCategory == 'all' ? null : _selectedCategory,
        query: _searchQuery.isEmpty ? null : _searchQuery,
        page: _currentPage,
        limit: _limit,
      ),
    );

    _isLoading = false;
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        update([GetBuilderIds.productList]);
      },
      (data) {
        _products = data;
        _hasMore = data.length >= _limit;
        _errorMessage = null;
        update([GetBuilderIds.productList]);
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (_isMoreLoading || !_hasMore || _isLoading) return;

    _isMoreLoading = true;
    update([GetBuilderIds.productList]);

    final nextPage = _currentPage + 1;
    final result = await getProductsUseCase(
      GetProductsParams(
        category: _selectedCategory == 'all' ? null : _selectedCategory,
        query: _searchQuery.isEmpty ? null : _searchQuery,
        page: nextPage,
        limit: _limit,
      ),
    );

    _isMoreLoading = false;
    result.fold(
      (failure) {
        update([GetBuilderIds.productList]);
      },
      (data) {
        if (data.isEmpty) {
          _hasMore = false;
        } else {
          _currentPage = nextPage;
          _products.addAll(data);
          _hasMore = data.length >= _limit;
        }
        update([GetBuilderIds.productList]);
      },
    );
  }

  void selectCategory(String categoryId) {
    if (_selectedCategory == categoryId) return;
    _selectedCategory = categoryId;
    update([GetBuilderIds.categorySelector]);
    loadProducts();
  }

  void search(String query) {
    _searchQuery = query;
    loadProducts();
  }

  Future<void> toggleFavorite(String productId) async {
    final result = await toggleFavoriteUseCase(productId);
    result.fold(
      (failure) => null,
      (isFav) {
        final index = _products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          _products[index] = _products[index].copyWith(isFavorite: isFav);
        }
        if (_selectedProduct?.id == productId) {
          _selectedProduct = _selectedProduct?.copyWith(isFavorite: isFav);
          update([GetBuilderIds.productDetail]);
        }
        // Selectively update only the specific product's favorite button!
        update([GetBuilderIds.productFavorite(productId)]);
      },
    );
  }

  Future<void> loadProductDetail(String id) async {
    // If already in list, show immediately
    final existing = _products.firstWhereOrNull((p) => p.id == id);
    if (existing != null) {
      _selectedProduct = existing;
      update([GetBuilderIds.productDetail]);
      return;
    }
    final result = await getProductByIdUseCase(id);
    result.fold(
      (failure) => null,
      (detail) {
        _selectedProduct = detail;
        update([GetBuilderIds.productDetail]);
      },
    );
  }
}
