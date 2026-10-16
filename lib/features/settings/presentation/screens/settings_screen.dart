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
import '../controllers/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedCurrency = 'INR (₹)';
  String _selectedLanguage = 'English (US)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Appearance & Theme Section
            Text('Appearance', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.s),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  GetBuilder<ThemeController>(
                    id: GetBuilderIds.settingsToggles,
                    builder: (themeCtrl) {
                      return SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            themeCtrl.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          themeCtrl.isDarkMode ? 'Dark theme is active' : 'Light theme is active',
                          style: AppTextStyles.bodySmall,
                        ),
                        value: themeCtrl.isDarkMode,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) {
                          themeCtrl.toggleTheme(val);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.l),

            // Notifications
            Text('Notifications', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.s),
            AppCard(
              padding: EdgeInsets.zero,
              child: SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.notifications_active_outlined, color: AppColors.secondaryDark),
                ),
                title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Order tracking updates & flash sale drops', style: TextStyle(fontSize: 12)),
                value: _notificationsEnabled,
                activeTrackColor: AppColors.secondaryDark,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
              ),
            ),

            const SizedBox(height: AppSpacing.l),

            // Regional & Language
            Text('Regional & Currency', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.s),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.currency_rupee_rounded, color: AppColors.primary),
                    title: const Text('Currency', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: DropdownButton<String>(
                      value: _selectedCurrency,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 'INR (₹)', child: Text('INR (₹)')),
                        DropdownMenuItem(value: 'USD (\$)', child: Text('USD (\$)')),
                        DropdownMenuItem(value: 'EUR (€)', child: Text('EUR (€)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCurrency = val);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                    title: const Text('Language', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 'English (US)', child: Text('English (US)')),
                        DropdownMenuItem(value: 'Hindi (हिंदी)', child: Text('Hindi (हिंदी)')),
                        DropdownMenuItem(value: 'Spanish (Español)', child: Text('Spanish (Español)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedLanguage = val);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.l),

            // App Data & Cache
            Text('Storage & App Info', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.s),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cleaning_services_outlined, color: AppColors.orange),
                    title: const Text('Clear Image Cache'),
                    subtitle: const Text('Free up temporary image storage (24.5 MB)'),
                    trailing: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image cache cleared successfully!')),
                        );
                      },
                      child: const Text('Clear'),
                    ),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.info_outline_rounded, color: AppColors.info),
                    title: Text('App Version'),
                    trailing: Text('1.0.0 (Build 2026.10)', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Sign out Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                onPressed: () async {
                  final authCtrl = Get.find<AuthController>();
                  await authCtrl.logout();
                  if (context.mounted) {
                    context.go(AppRoutes.signIn);
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log Out'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
