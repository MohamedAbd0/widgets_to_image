import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

void main() {
  group('WidgetsToImageController', () {
    late WidgetsToImageController controller;

    setUp(() {
      controller = WidgetsToImageController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with correct default state', () {
      expect(controller.isCapturing, false);
    });

    test('should throw exception when capturing without mounted widget',
        () async {
      expect(
        () => controller.capture(),
        throwsA(isA<CaptureException>()),
      );
    });

    test('should throw exception when capture is already in progress',
        () async {
      // Mock a capture in progress
      unawaited(controller.capture().catchError((_) => null));

      expect(
        () => controller.capture(),
        throwsA(isA<CaptureException>()),
      );
    });

    group('CaptureOptions', () {
      test('should create with default values', () {
        const options = CaptureOptions();
        expect(options.pixelRatio, 1.0);
        expect(options.format, ImageFormat.png);
        expect(options.quality, 95);
        expect(options.waitForAnimations, false);
        expect(options.delayMs, 0);
      });

      test('should validate pixel ratio', () {
        expect(
          () => CaptureOptions(pixelRatio: 0),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => CaptureOptions(pixelRatio: -1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should validate quality', () {
        expect(
          () => CaptureOptions(quality: -1),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => CaptureOptions(quality: 101),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should validate delay', () {
        expect(
          () => CaptureOptions(delayMs: -1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should create copy with replaced values', () {
        const original = CaptureOptions();
        final copy = original.copyWith(pixelRatio: 2.0, quality: 80);

        expect(copy.pixelRatio, 2.0);
        expect(copy.quality, 80);
        expect(copy.format, original.format);
        expect(copy.waitForAnimations, original.waitForAnimations);
        expect(copy.delayMs, original.delayMs);
      });

      test('should compare equality correctly', () {
        const options1 = CaptureOptions(pixelRatio: 2.0, quality: 80);
        const options2 = CaptureOptions(pixelRatio: 2.0, quality: 80);
        const options3 = CaptureOptions(pixelRatio: 3.0, quality: 80);

        expect(options1, equals(options2));
        expect(options1, isNot(equals(options3)));
      });
    });
  });

  group('ImageFormat', () {
    test('should have correct file extensions', () {
      expect(ImageFormat.png.fileExtension, 'png');
      expect(ImageFormat.jpeg.fileExtension, 'jpg');
      expect(ImageFormat.rawRgba.fileExtension, 'rgba');
      expect(ImageFormat.rawUnmodified.fileExtension, 'raw');
    });

    test('should have correct MIME types', () {
      expect(ImageFormat.png.mimeType, 'image/png');
      expect(ImageFormat.jpeg.mimeType, 'image/jpeg');
      expect(ImageFormat.rawRgba.mimeType, 'application/octet-stream');
      expect(ImageFormat.rawUnmodified.mimeType, 'application/octet-stream');
    });
  });

  group('WidgetsToImage Widget', () {
    testWidgets('should render child widget correctly', (tester) async {
      final controller = WidgetsToImageController();
      const testChild = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetsToImage(
              controller: controller,
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.text('Test Widget'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('should wrap child in RepaintBoundary', (tester) async {
      final controller = WidgetsToImageController();
      const testChild = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetsToImage(
              controller: controller,
              child: testChild,
            ),
          ),
        ),
      );

      // Check that our specific RepaintBoundary exists (the one with our controller's key)
      expect(find.byKey(controller.containerKey), findsOneWidget);
      controller.dispose();
    });

    testWidgets('should clip child when clipBehavior is true', (tester) async {
      final controller = WidgetsToImageController();
      const testChild = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetsToImage(
              controller: controller,
              clipBehavior: true,
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.byType(ClipRect), findsOneWidget);
      controller.dispose();
    });
  });

  group('WidgetsToImageBuilder', () {
    testWidgets('should provide capture state to builder', (tester) async {
      final controller = WidgetsToImageController();
      bool? capturedIsCapturing;
      Future<Uint8List?> Function()? capturedCaptureFunction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetsToImageBuilder(
              controller: controller,
              builder: (context, isCapturing, capture) {
                capturedIsCapturing = isCapturing;
                capturedCaptureFunction = capture;
                return Text('Is capturing: $isCapturing');
              },
            ),
          ),
        ),
      );

      expect(capturedIsCapturing, false);
      expect(capturedCaptureFunction, isNotNull);
      expect(find.text('Is capturing: false'), findsOneWidget);

      controller.dispose();
    });
  });

  group('CaptureException', () {
    test('should format message correctly', () {
      const exception = CaptureException('Test error');
      expect(exception.toString(), 'CaptureException: Test error');
    });

    test('should include original error in message', () {
      const originalError = 'Original error';
      const exception = CaptureException(
        'Test error',
        originalError: originalError,
      );
      expect(
        exception.toString(),
        'CaptureException: Test error (caused by: Original error)',
      );
    });
  });
}
