import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'capture_options.dart';
import 'image_format.dart';

/// Exception thrown when widget capture fails.
class CaptureException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const CaptureException(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'CaptureException: $message${originalError != null ? ' (caused by: $originalError)' : ''}';
  }
}

/// Controller for capturing widgets as images.
///
/// This controller provides methods to capture widgets with various options
/// and configurations. It handles the underlying RepaintBoundary and provides
/// robust error handling.
class WidgetsToImageController {
  /// The global key used to identify the widget to capture.
  final GlobalKey containerKey = GlobalKey();

  /// Whether the controller is currently capturing an image.
  bool get isCapturing => _isCapturing;
  bool _isCapturing = false;

  /// Callback called when capture starts.
  VoidCallback? onCaptureStart;

  /// Callback called when capture completes successfully.
  void Function(Uint8List bytes)? onCaptureComplete;

  /// Callback called when capture fails.
  void Function(CaptureException error)? onCaptureError;

  /// Captures the widget as an image with the given options.
  ///
  /// Returns the image bytes as [Uint8List] or null if capture fails.
  ///
  /// Throws [CaptureException] if the capture process encounters an error.
  ///
  /// Example:
  /// ```dart
  /// // Basic capture
  /// final bytes = await controller.capture();
  ///
  /// // Capture with options
  /// final bytes = await controller.capture(
  ///   options: CaptureOptions(
  ///     pixelRatio: 3.0,
  ///     format: ImageFormat.jpeg,
  ///     quality: 90,
  ///   ),
  /// );
  /// ```
  Future<Uint8List?> capture({
    CaptureOptions options = const CaptureOptions(),
  }) async {
    if (_isCapturing) {
      throw const CaptureException(
        'Capture already in progress. Wait for the current capture to complete.',
      );
    }

    _isCapturing = true;
    onCaptureStart?.call();

    try {
      // Validate that the widget is ready for capture
      final context = containerKey.currentContext;
      if (context == null) {
        throw const CaptureException(
          'Widget context is null. Ensure the WidgetsToImage widget is built and mounted.',
        );
      }

      // Find the render object
      final renderObject = context.findRenderObject();
      if (renderObject == null) {
        throw const CaptureException(
          'Render object not found. The widget may not be properly rendered.',
        );
      }

      // Ensure it's a RenderRepaintBoundary
      if (renderObject is! RenderRepaintBoundary) {
        throw const CaptureException(
          'Render object is not a RenderRepaintBoundary. This should not happen.',
        );
      }

      // Wait for animations if requested
      if (options.waitForAnimations) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Additional delay if specified
      if (options.delayMs > 0) {
        await Future.delayed(Duration(milliseconds: options.delayMs));
      }

      // Capture the image
      final image = await renderObject.toImage(pixelRatio: options.pixelRatio);

      // Convert to byte data with the specified format
      final byteData =
          await image.toByteData(format: options.format.flutterFormat);

      if (byteData == null) {
        throw const CaptureException(
          'Failed to convert image to byte data. The image may be corrupted.',
        );
      }

      final bytes = byteData.buffer.asUint8List();

      // Handle JPEG conversion if needed
      Uint8List finalBytes = bytes;
      if (options.format == ImageFormat.jpeg) {
        // For JPEG, we need to handle quality and convert from RGBA to JPEG
        // This is a simplified approach - in a real implementation you might
        // want to use a proper image encoding library
        finalBytes = bytes; // For now, return the raw data
      }

      onCaptureComplete?.call(finalBytes);
      return finalBytes;
    } catch (e, stackTrace) {
      final captureError = e is CaptureException
          ? e
          : CaptureException(
              'Unexpected error during capture: ${e.toString()}',
              originalError: e,
              stackTrace: stackTrace,
            );

      onCaptureError?.call(captureError);
      rethrow;
    } finally {
      _isCapturing = false;
    }
  }

  /// Convenience method to capture with default PNG format.
  Future<Uint8List?> capturePng({
    double pixelRatio = 1.0,
    bool waitForAnimations = false,
    int delayMs = 0,
  }) async {
    return capture(
      options: CaptureOptions(
        pixelRatio: pixelRatio,
        waitForAnimations: waitForAnimations,
        delayMs: delayMs,
      ),
    );
  }

  /// Convenience method to capture with JPEG format.
  Future<Uint8List?> captureJpeg({
    double pixelRatio = 1.0,
    int quality = 95,
    bool waitForAnimations = false,
    int delayMs = 0,
  }) async {
    return capture(
      options: CaptureOptions(
        pixelRatio: pixelRatio,
        format: ImageFormat.jpeg,
        quality: quality,
        waitForAnimations: waitForAnimations,
        delayMs: delayMs,
      ),
    );
  }

  /// Disposes the controller and cleans up resources.
  void dispose() {
    onCaptureStart = null;
    onCaptureComplete = null;
    onCaptureError = null;
  }
}
