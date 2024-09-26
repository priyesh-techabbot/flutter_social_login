import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final Color? color;
  final String? message;
  const LoadingPage({this.color, this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: color ?? Colors.black.withOpacity(0.3),
      child: Center(
        child: Platform.isAndroid
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator(
                color: Colors.white,
                radius: 15,
              ),
      ),
    );
  }
}
