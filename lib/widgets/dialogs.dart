import 'package:flutter/material.dart';

class AppDialogs {
  // ✅ نجاح
  static void success(BuildContext context, String message) {
    _showDialog(
      context,
      icon: Icons.check_circle_rounded,
      color: Colors.green,
      title: '✅ Success',
      message: message,
    );
  }

  // ❌ خطأ
  static void error(BuildContext context, String message) {
    _showDialog(
      context,
      icon: Icons.error_outline_rounded,
      color: Colors.red,
      title: '❌ Error',
      message: message,
    );
  }

  // ⚠️ تحذير
  static void warning(BuildContext context, String message) {
    _showDialog(
      context,
      icon: Icons.warning_rounded,
      color: Colors.orange,
      title: '⚠️ Warning',
      message: message,
    );
  }

  // ❓ تأكيد
  static Future<bool> confirm(BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.help_rounded, color: Colors.blue),
                SizedBox(width: 8),
                Text('❓ Confirm'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  static void showDeleteDialog({
    required BuildContext context,
    required VoidCallback onDelete,
    String title = 'Delete Item',
    String message =
        'Are you sure you want to delete this item?\nThis action cannot be undone.',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(message, style: TextStyle(fontSize: 16)),
        actions: [
          // ✅ زر إلغاء (جهة اليسار)
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          // ✅ زر حذف (جهة اليمين)
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onDelete();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔄 تحميل
  static void loading(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // الدالة الأساسية
  static void _showDialog(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 55),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
