import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onConfirmed;

  // قابل سفارشی‌سازی در صورت نیاز؛ پیش‌فرض از ترجمه‌ها خونده می‌شود
  final String? title;
  final String? question;
  final String? cancelText;
  final String? deleteText;

  const DeleteButton({
    super.key,
    required this.onConfirmed,
    this.title,
    this.question,
    this.cancelText,
    this.deleteText,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final tTitle    = title      ?? (loc?.deleteDeviceTitle        ?? "Delete device");
    final tQuestion = question   ?? (loc?.deleteDeviceConfirmation ?? "Are you sure you want to remove this device?");
    final tCancel   = cancelText ?? (loc?.cancel                   ?? "Cancel");
    final tDelete   = deleteText ?? (loc?.delete                   ?? "Delete");

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC2626), // قرمز مدرن
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.delete_outline),
        label: Text(tTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(tTitle),
              content: Text(tQuestion),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(tCancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(tDelete),
                ),
              ],
            ),
          );

          if (confirm == true) {
            onConfirmed();
          }
        },
      ),
    );
  }
}
