import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'controller.dart';

/// A widget that wraps its child in a RepaintBoundary to enable image capture.
///
/// This widget automatically handles the underlying RepaintBoundary setup
/// and provides a clean API for capturing widgets as images.
///
/// Example usage:
/// ```dart
/// WidgetsToImageController controller = WidgetsToImageController();
///
/// WidgetsToImage(
///   controller: controller,
///   child: Container(
///     width: 200,
///     height: 100,
///     color: Colors.blue,
///     child: Text('Hello World'),
///   ),
/// )
///
/// // Later, capture the widget
/// Uint8List? imageBytes = await controller.capture();
/// ```
class WidgetsToImage extends StatelessWidget {
  /// The child widget to be captured.
  final Widget? child;

  /// The controller used to capture the widget.
  final WidgetsToImageController controller;

  /// Whether to clip the child widget.
  /// Default is false.
  final bool clipBehavior;

  /// Creates a [WidgetsToImage] widget.
  ///
  /// The [controller] parameter is required and used to capture the widget.
  /// The [child] parameter is the widget to be captured.
  const WidgetsToImage({
    super.key,
    required this.controller,
    this.child,
    this.clipBehavior = false,
  });

  @override
  Widget build(BuildContext context) {
    /// Wrap the child in a RepaintBoundary to capture widget to image
    return RepaintBoundary(
      key: controller.containerKey,
      child: clipBehavior ? ClipRect(child: child) : child,
    );
  }
}

/// A builder widget that provides capture functionality.
///
/// This widget is useful when you need to build different UI based on
/// the capture state or provide inline capture functionality.
class WidgetsToImageBuilder extends StatefulWidget {
  /// The controller used to capture the widget.
  final WidgetsToImageController controller;

  /// Builder function that provides the current capture state.
  final Widget Function(
    BuildContext context,
    bool isCapturing,
    Future<Uint8List?> Function() capture,
  ) builder;

  /// Creates a [WidgetsToImageBuilder] widget.
  const WidgetsToImageBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  State<WidgetsToImageBuilder> createState() => _WidgetsToImageBuilderState();
}

class _WidgetsToImageBuilderState extends State<WidgetsToImageBuilder> {
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.onCaptureStart = () {
      if (mounted) {
        setState(() {
          _isCapturing = true;
        });
      }
    };

    widget.controller.onCaptureComplete = (_) {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    };

    widget.controller.onCaptureError = (_) {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    };
  }

  Future<Uint8List?> _capture() async {
    return widget.controller.capture();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _isCapturing, _capture);
  }

  @override
  void dispose() {
    widget.controller.onCaptureStart = null;
    widget.controller.onCaptureComplete = null;
    widget.controller.onCaptureError = null;
    super.dispose();
  }
}
