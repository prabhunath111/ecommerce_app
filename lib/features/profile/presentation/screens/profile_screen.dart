import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            // User Header with GetBuilder
            GetBuilder<AuthController>(
              id: GetBuilderIds.profileInfo,
              builder: (authCtrl) {
                final user = authCtrl.currentUser;

                return AppCard(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.primary.withAlpha(40),
                            backgroundImage: user?.avatar != null ? NetworkImage(user!.avatar!) : null,
                            child: user?.avatar == null
                                ? const Icon(Icons.person, size: 36, color: AppColors.primary)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Alex Morgan',
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? 'alex.morgan@example.com',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'VIP Trendsetter',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.secondaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.m),

            // Metrics / Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Active Orders',
                    value: '2',
                    icon: Icons.local_shipping_outlined,
                    color: AppColors.primary,
                    context: context,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: _buildStatCard(
                    title: 'Saved Items',
                    value: '14',
                    icon: Icons.favorite_border_rounded,
                    color: AppColors.accent,
                    context: context,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: _buildStatCard(
                    title: 'Coupons',
                    value: '3',
                    icon: Icons.confirmation_number_outlined,
                    color: AppColors.secondary,
                    context: context,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.l),

            // Profile Actions List
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Order History',
                    subtitle: 'Check recent tracking & invoices',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    icon: Icons.location_on_outlined,
                    title: 'Shipping Addresses',
                    subtitle: 'Manage home & office delivery points',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Saved Payment Methods',
                    subtitle: 'Cards, UPI & Wallets',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    icon: Icons.support_agent_rounded,
                    title: 'Customer Care & FAQ',
                    subtitle: '24/7 dedicated support team',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.m),

            // Settings Shortcut
            AppCard(
              padding: EdgeInsets.zero,
              child: _buildListTile(
                icon: Icons.settings_outlined,
                title: 'Preferences & Settings',
                subtitle: 'Theme, notifications, currency',
                onTap: () => context.push(AppRoutes.settings),
              ),
            ),

            const SizedBox(height: AppSpacing.l),

            // Logout Option
            ListTile(
              onTap: () async {
                final authCtrl = Get.find<AuthController>();
                await authCtrl.logout();
                if (context.mounted) {
                  context.go(AppRoutes.signIn);
                }
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
              ),
              title: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.labelLarge),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
    );
  }
}
