/// A powerful Flutter package to convert widgets into high-quality images.
///
/// This library provides easy-to-use widgets and utilities for capturing
/// any Flutter widget as an image with customizable formats, quality settings,
/// and advanced features.
///
/// Example usage:
/// ```dart
/// WidgetsToImageController controller = WidgetsToImageController();
///
/// WidgetsToImage(
///   controller: controller,
///   child: MyWidget(),
/// )
///
/// // Capture the widget as PNG
/// Uint8List? bytes = await controller.capture();
///
/// // Capture with custom settings
/// Uint8List? bytes = await controller.capture(
///   format: ImageFormat.jpeg,
///   quality: 95,
///   pixelRatio: 3.0,
/// );
/// ```
library widgets_to_image;

export 'src/capture_options.dart';
export 'src/controller.dart';
export 'src/image_format.dart';
export 'src/widgets_to_image.dart';
