import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/sync_status_badge.dart';
import '../../providers/app_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context)!;
    final user = app.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF0F9D58).withValues(alpha: 0.12),
                    backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    child: user?.photoURL == null ? const Icon(Icons.person, size: 28, color: Color(0xFF0F9D58)) : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? l10n.user,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? AppConstants.creatorName,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SyncStatusBadge(status: app.syncStatus),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(l10n.general),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: Text(l10n.darkMode),
                  value: themeProvider.isDarkMode,
                  onChanged: (v) => themeProvider.toggleDarkMode(v),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.currency_exchange),
                  title: Text(l10n.currency),
                      trailing: Text(l10n.currencyValue),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.language),
                  trailing: DropdownButton<String>(
                    value: localeProvider.locale.languageCode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'bn',
                        child: Text('বাংলা'),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        localeProvider.setLanguage(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(l10n.dataAndSync),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_sync_outlined),
              title: Text(l10n.syncStatus),
              subtitle: Text(l10n.syncDescription),
              trailing: SyncStatusBadge(status: app.syncStatus),
              onTap: () => app.syncService?.pushPendingChanges(),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(l10n.other),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.privacy),
                  subtitle: Text(l10n.privacyDescription),
                ),
                const Divider(height: 1),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) => ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.aboutApp),
                    subtitle: Text(
                      snapshot.hasData ? 'v${snapshot.data!.version}' : '',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          title: Text(l10n.appName),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: CircleAvatar(
                                  radius: 38,
                                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                                  backgroundImage: const AssetImage('assets/images/profile_siam.webp'),
                                ),
                              ),
                              const SizedBox(height: 14),
                                  Text(l10n.builtBy),
                              const SizedBox(height: 12),
                                  Text(
                                    snapshot.hasData
                                        ? '${l10n.versionLabel}: v${snapshot.data!.version}'
                                        : '${l10n.versionLabel}: --',
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                              const SizedBox(height: 10),
                                  Text('${l10n.creatorLabel}: ${AppConstants.creatorName}'),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () async {
                                  final url = Uri.parse(AppConstants.creatorWebsite);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: '${l10n.websiteLabel}: ${AppConstants.creatorWebsite}',
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: Text(l10n.close),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
              onPressed: () async {
                final confirmed = await showConfirmDialog(
                  context,
                  title: l10n.logoutConfirmTitle,
                  message: l10n.logoutConfirmMessage,
                  confirmLabel: l10n.logout,
                  isDangerous: false,
                );
                if (confirmed) {
                  await app.signOut();
                }
              },
              icon: const Icon(Icons.logout),
              label: Text(l10n.logout),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 4),
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage('assets/images/profile_siam.webp'),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConstants.creatorName,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    final url = Uri.parse(AppConstants.creatorWebsite);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    'Built by CodeWithSiam',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 13)),
      );
}
