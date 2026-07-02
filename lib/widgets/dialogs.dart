import 'package:flutter/material.dart';

class AppDialogs {
  // ✅ نجاح
  static void success(BuildContext context, String message) {
    _showDialog(
      context,
      icon: Icons.check_circle_rounded,
      color: Colors.green,
      title: 'success',
      message: message,
    );
  }

  // ❌ خطأ
  static void error(BuildContext context, String message) {
    _showDialog(
      context,
      icon: Icons.error_outline_rounded,
      color: Colors.red,
      title: 'error',
      message: message,
    );
  }

  // ⚠️ تحذير
  static void warning(BuildContext context, String message) {
    _showDialog(
      context,
      icon: Icons.warning_rounded,
      color: Colors.orange,
      title: 'warning',
      message: message,
    );
  }

  // ❓ تأكيد
  static Future<bool> confirm(BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.help_rounded, color: Colors.blue),
                SizedBox(width: 8),
                Text('ok'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text('confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // 🔄 تحميل
  static void loading(
    BuildContext context, {
    String message = 'loding...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
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
      builder: (context) => AlertDialog(
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
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('ok'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
