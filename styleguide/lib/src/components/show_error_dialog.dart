import 'package:flutter/material.dart';

void showErrorDialog(
  BuildContext context,
  String message,
) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message)),
    );
