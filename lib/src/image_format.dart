import 'dart:ui' as ui;

/// Supported image formats for widget capture.
enum ImageFormat {
  /// PNG format - lossless compression, supports transparency
  png,

  /// JPEG format - lossy compression, smaller file size, no transparency
  jpeg,

  /// Raw RGBA format - uncompressed pixel data
  rawRgba,

  /// Raw unmodified format
  rawUnmodified;

  /// Convert to Flutter's ImageByteFormat
  ui.ImageByteFormat get flutterFormat {
    switch (this) {
      case ImageFormat.png:
        return ui.ImageByteFormat.png;
      case ImageFormat.jpeg:
        return ui.ImageByteFormat.rawRgba;
      case ImageFormat.rawRgba:
        return ui.ImageByteFormat.rawRgba;
      case ImageFormat.rawUnmodified:
        return ui.ImageByteFormat.rawUnmodified;
    }
  }

  /// Get the typical file extension for this format
  String get fileExtension {
    switch (this) {
      case ImageFormat.png:
        return 'png';
      case ImageFormat.jpeg:
        return 'jpg';
      case ImageFormat.rawRgba:
        return 'rgba';
      case ImageFormat.rawUnmodified:
        return 'raw';
    }
  }

  /// Get the MIME type for this format
  String get mimeType {
    switch (this) {
      case ImageFormat.png:
        return 'image/png';
      case ImageFormat.jpeg:
        return 'image/jpeg';
      case ImageFormat.rawRgba:
        return 'application/octet-stream';
      case ImageFormat.rawUnmodified:
        return 'application/octet-stream';
    }
  }
}
