import 'package:flutter/material.dart';
import 'utils.dart';

class WidgetsToImage extends StatelessWidget {
  final Widget? child;
  final WidgetsToImageController controller;

  const WidgetsToImage({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// to capture widget to image by GlobalKey in RepaintBoundary
    return RepaintBoundary(
      key: controller.containerKey,
      child: child,
    );
  }
}
