import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_pills.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.m,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_bag_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.s),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  AppConstants.appTagline,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Cart action button with reactive bump badge using GetBuilder
          GetBuilder<CartController>(
            id: GetBuilderIds.cartBadge,
            builder: (cartCtrl) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.m),
              child: IconButton(
                icon: AppBadge(
                  count: cartCtrl.totalQuantity,
                  child: const Icon(Icons.shopping_bag_outlined, size: 26),
                ),
                onPressed: () => context.push(AppRoutes.cart),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          final productCtrl = Get.find<ProductController>();
          await productCtrl.loadProducts(refresh: true);
        },
        child: CustomScrollView(
          slivers: [
            // Search Input Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    final ctrl = Get.find<ProductController>();
                    ctrl.search(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search clothes, electronics, shoes...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 22),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              Get.find<ProductController>().search('');
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // Promotional Banners Carousel
            const SliverToBoxAdapter(
              child: BannerCarousel(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.m),
            ),

            // Horizontal Categories Filter Chips
            const SliverToBoxAdapter(
              child: CategoryPills(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.m),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trending Deals', style: AppTextStyles.titleMedium),
                    Text(
                      'Curated for you',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.s),
            ),

            // Products Grid using GetBuilder listening to GetBuilderIds.productList
            GetBuilder<ProductController>(
              id: GetBuilderIds.productList,
              builder: (controller) {
                if (controller.isLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                if (controller.errorMessage != null) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      icon: Icons.error_outline_rounded,
                      title: 'Something went wrong',
                      message: controller.errorMessage!,
                      buttonText: 'Try Again',
                      onButtonPressed: () => controller.loadProducts(refresh: true),
                    ),
                  );
                }

                if (controller.products.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'No Products Found',
                      message: 'Try clearing your search or selecting another category.',
                      buttonText: 'Reset Filters',
                      onButtonPressed: () {
                        _searchController.clear();
                        controller.selectCategory('all');
                        controller.search('');
                        setState(() {});
                      },
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = controller.products[index];
                        return ProductCard(product: product, index: index);
                      },
                      childCount: controller.products.length,
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}
