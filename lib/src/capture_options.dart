import 'image_format.dart';

/// Configuration options for capturing widgets as images.
class CaptureOptions {
  /// The desired pixel ratio for the captured image.
  /// Higher values result in higher resolution images.
  /// Default is 1.0.
  final double pixelRatio;

  /// The format of the output image.
  /// Default is PNG.
  final ImageFormat format;

  /// Quality setting for lossy formats like JPEG (0-100).
  /// Only applies to JPEG format. Higher values mean better quality.
  /// Default is 95.
  final int quality;

  /// Whether to wait for animations to complete before capturing.
  /// Default is false.
  final bool waitForAnimations;

  /// Additional delay in milliseconds before capturing.
  /// Useful when you need to wait for network images or complex layouts.
  /// Default is 0.
  final int delayMs;

  const CaptureOptions({
    this.pixelRatio = 1.0,
    this.format = ImageFormat.png,
    this.quality = 95,
    this.waitForAnimations = false,
    this.delayMs = 0,
  })  : assert(pixelRatio > 0, 'Pixel ratio must be greater than 0'),
        assert(quality >= 0 && quality <= 100,
            'Quality must be between 0 and 100'),
        assert(delayMs >= 0, 'Delay must be non-negative');

  /// Create a copy of this options with some fields replaced.
  CaptureOptions copyWith({
    double? pixelRatio,
    ImageFormat? format,
    int? quality,
    bool? waitForAnimations,
    int? delayMs,
  }) {
    return CaptureOptions(
      pixelRatio: pixelRatio ?? this.pixelRatio,
      format: format ?? this.format,
      quality: quality ?? this.quality,
      waitForAnimations: waitForAnimations ?? this.waitForAnimations,
      delayMs: delayMs ?? this.delayMs,
    );
  }

  @override
  String toString() {
    return 'CaptureOptions('
        'pixelRatio: $pixelRatio, '
        'format: $format, '
        'quality: $quality, '
        'waitForAnimations: $waitForAnimations, '
        'delayMs: $delayMs)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CaptureOptions &&
        other.pixelRatio == pixelRatio &&
        other.format == format &&
        other.quality == quality &&
        other.waitForAnimations == waitForAnimations &&
        other.delayMs == delayMs;
  }

  @override
  int get hashCode {
    return Object.hash(
      pixelRatio,
      format,
      quality,
      waitForAnimations,
      delayMs,
    );
  }
}
