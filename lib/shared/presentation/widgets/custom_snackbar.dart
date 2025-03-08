import 'package:flutter/material.dart';

void showCustomSnackbar(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  final snackBar = SnackBar(
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor:
        isError ? Colors.red.shade800 : const Color.fromRGBO(0, 0, 100, 1),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
