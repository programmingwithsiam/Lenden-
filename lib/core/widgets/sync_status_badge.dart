import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

class SyncStatusBadge extends StatelessWidget {
  final String status;
  const SyncStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final Color color;
    late final String label;

    switch (status) {
      case AppConstants.syncStatusSyncing:
        icon = Icons.sync;
        color = AppTheme.warning;
        label = 'সিঙ্ক হচ্ছে';
        break;
      case AppConstants.syncStatusPending:
        icon = Icons.cloud_off_outlined;
        color = AppTheme.warning;
        label = 'সিঙ্ক বাকি';
        break;
      default:
        icon = Icons.cloud_done_outlined;
        color = AppTheme.success;
        label = 'সিঙ্ক সম্পন্ন';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
