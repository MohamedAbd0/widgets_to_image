import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Widgets to Image - Professional Demo',
        theme: _buildTheme(),
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      );

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1), // Indigo
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  // Controllers
  final WidgetsToImageController _basicController = WidgetsToImageController();
  final WidgetsToImageController _advancedController =
      WidgetsToImageController();
  final WidgetsToImageController _animatedController =
      WidgetsToImageController();

  // State
  Uint8List? _basicImageBytes;
  Uint8List? _advancedImageBytes;
  Uint8List? _animatedImageBytes;

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  ImageFormat _selectedFormat = ImageFormat.png;
  double _pixelRatio = 2.0;
  int _quality = 95;
  bool _waitForAnimations = false;

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _setupControllerCallbacks();
  }

  void _setupControllerCallbacks() {
    for (final controller in [
      _basicController,
      _advancedController,
      _animatedController
    ]) {
      controller.onCaptureStart = () {
        _showSnackBar('📸 Capturing widget...', Icons.camera_alt);
      };

      controller.onCaptureError = (error) {
        _showSnackBar('❌ Capture failed: ${error.message}', Icons.error,
            isError: true);
      };
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _basicController.dispose();
    _advancedController.dispose();
    _animatedController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, IconData icon, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildHeroSection()),
          SliverToBoxAdapter(child: _buildTabSection()),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(child: _buildContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Widgets to Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: 'About',
          onPressed: _showInfoDialog,
        ),
        IconButton(
          icon: const Icon(Icons.code),
          tooltip: 'View Source',
          onPressed: _launchGitHub,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.camera_alt_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Transform Flutter Widgets\ninto High-Quality Images',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Professional widget-to-image conversion with customizable formats, quality settings, and cross-platform support.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureChip('🎯 Simple API'),
              _buildFeatureChip('🖼️ Multiple Formats'),
              _buildFeatureChip('⚙️ Customizable'),
              _buildFeatureChip('📱 Cross Platform'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTabSection() {
    final tabs = [
      ('Basic Example', Icons.widgets),
      ('Advanced Options', Icons.tune),
      ('Animation Capture', Icons.animation),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final (title, icon) = entry.value;
            final isSelected = _selectedTabIndex == index;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedTabIndex = index);
                  }
                },
                avatar: Icon(icon, size: 18),
                label: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                side: BorderSide.none,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_selectedTabIndex) {
        0 => _buildBasicExample(),
        1 => _buildAdvancedExample(),
        2 => _buildAnimatedExample(),
        _ => _buildBasicExample(),
      },
    );
  }

  Widget _buildBasicExample() {
    return _buildExampleCard(
      key: const ValueKey('basic'),
      title: 'Basic Widget Capture',
      subtitle: 'Simple one-click widget to image conversion',
      icon: Icons.widgets,
      iconColor: Theme.of(context).colorScheme.primary,
      widget: WidgetsToImage(
        controller: _basicController,
        child: _buildSampleCard(),
      ),
      buttons: [
        FilledButton.icon(
          onPressed: _captureBasic,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Capture as PNG'),
        ),
        OutlinedButton.icon(
          onPressed: _basicImageBytes != null
              ? () => _copyToClipboard(_basicImageBytes!)
              : null,
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy'),
        ),
      ],
      result: _basicImageBytes,
    );
  }

  Widget _buildAdvancedExample() {
    return _buildExampleCard(
      key: const ValueKey('advanced'),
      title: 'Advanced Configuration',
      subtitle: 'Customize format, quality, and capture options',
      icon: Icons.tune,
      iconColor: Theme.of(context).colorScheme.secondary,
      widget: WidgetsToImage(
        controller: _advancedController,
        child: _buildComplexCard(),
      ),
      buttons: [
        FilledButton.icon(
          onPressed: _captureAdvanced,
          icon: const Icon(Icons.tune),
          label: const Text('Capture with Options'),
        ),
        OutlinedButton.icon(
          onPressed: _advancedImageBytes != null
              ? () => _copyToClipboard(_advancedImageBytes!)
              : null,
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy'),
        ),
      ],
      controls: _buildAdvancedControls(),
      result: _advancedImageBytes,
      formatInfo: _selectedFormat.name.toUpperCase(),
    );
  }

  Widget _buildAnimatedExample() {
    return _buildExampleCard(
      key: const ValueKey('animated'),
      title: 'Animation Capture',
      subtitle: 'Capture animated widgets at specific moments',
      icon: Icons.animation,
      iconColor: Theme.of(context).colorScheme.tertiary,
      widget: WidgetsToImage(
        controller: _animatedController,
        child: _buildAnimatedWidget(),
      ),
      buttons: [
        FilledButton.icon(
          onPressed: _captureAnimated,
          icon: const Icon(Icons.animation),
          label: const Text('Capture Animation'),
        ),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              if (_animationController.isAnimating) {
                _animationController.stop();
              } else {
                _animationController.repeat();
              }
            });
          },
          icon: Icon(_animationController.isAnimating
              ? Icons.pause
              : Icons.play_arrow),
          label: Text(_animationController.isAnimating ? 'Pause' : 'Play'),
        ),
      ],
      result: _animatedImageBytes,
    );
  }

  Widget _buildExampleCard({
    required Key key,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget widget,
    required List<Widget> buttons,
    Widget? controls,
    Uint8List? result,
    String? formatInfo,
  }) {
    return Card(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Widget to capture
            Center(child: widget),

            const SizedBox(height: 24),

            // Controls (if any)
            if (controls != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: controls,
              ),
              const SizedBox(height: 24),
            ],

            // Action buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: buttons,
            ),

            // Result
            if (result != null) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 20),
              _buildResultSection(result, formatInfo),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(Uint8List bytes, String? formatInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Captured Image${formatInfo != null ? ' ($formatInfo)' : ''}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(bytes.length / 1024).toStringAsFixed(1)} KB',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(bytes, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Capture Configuration',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 20),

        // Format and Pixel Ratio row
        Row(
          children: [
            Expanded(child: _buildFormatDropdown()),
            const SizedBox(width: 16),
            Expanded(child: _buildPixelRatioField()),
          ],
        ),

        // Quality slider (for JPEG)
        if (_selectedFormat == ImageFormat.jpeg) ...[
          const SizedBox(height: 20),
          _buildQualitySlider(),
        ],

        const SizedBox(height: 20),

        // Animation wait toggle
        _buildAnimationToggle(),
      ],
    );
  }

  Widget _buildFormatDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Output Format',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ImageFormat>(
          value: _selectedFormat,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          items: ImageFormat.values.map((format) {
            return DropdownMenuItem(
              value: format,
              child: Row(
                children: [
                  Icon(
                    format == ImageFormat.png
                        ? Icons.image
                        : format == ImageFormat.jpeg
                            ? Icons.photo
                            : Icons.code,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(format.name.toUpperCase()),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedFormat = value!),
        ),
      ],
    );
  }

  Widget _buildPixelRatioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pixel Ratio',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _pixelRatio.toString(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            suffixText: 'x',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final ratio = double.tryParse(value);
            if (ratio != null && ratio > 0) _pixelRatio = ratio;
          },
        ),
      ],
    );
  }

  Widget _buildQualitySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'JPEG Quality',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_quality%',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Slider(
            value: _quality.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: (value) => setState(() => _quality = value.round()),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimationToggle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(
          'Wait for animations',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        subtitle: Text(
          'Adds a delay to capture stable animation frames',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
        value: _waitForAnimations,
        onChanged: (value) => setState(() => _waitForAnimations = value),
      ),
    );
  }

  // Sample widgets
  Widget _buildSampleCard() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flutter_dash,
                    color: Colors.white, size: 28),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Flutter Widget Card',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Beautiful, responsive card component that showcases the power of Flutter widgets converted to high-quality images.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStat('Quality', '100%'),
              const SizedBox(width: 20),
              _buildStat('Format', 'PNG'),
              const SizedBox(width: 20),
              _buildStat('Ratio', '2x'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildComplexCard() {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Icon(Icons.landscape, size: 56, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Advanced Widget Demo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'This complex widget showcases advanced capture capabilities with custom formats, quality settings, and professional styling.',
                  style: TextStyle(color: Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildTag('Advanced', Colors.blue),
                    const SizedBox(width: 8),
                    _buildTag('Professional', Colors.green),
                    const SizedBox(width: 8),
                    _buildTag('Modern', Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAnimatedWidget() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [Colors.cyan, Colors.blue, Colors.purple],
                    transform: GradientRotation(
                        _rotationAnimation.value * 2 * 3.14159),
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.rotate_right,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Action methods
  Future<void> _captureBasic() async {
    try {
      final bytes = await _basicController.capturePng(pixelRatio: 2.0);
      setState(() => _basicImageBytes = bytes);
      if (bytes != null) {
        _showSnackBar('✅ Basic capture completed!', Icons.check_circle);
      }
    } catch (e) {
      _showSnackBar('❌ Capture failed: $e', Icons.error, isError: true);
    }
  }

  Future<void> _captureAdvanced() async {
    try {
      final bytes = await _advancedController.capture(
        options: CaptureOptions(
          format: _selectedFormat,
          pixelRatio: _pixelRatio,
          quality: _quality,
          waitForAnimations: _waitForAnimations,
          delayMs: _waitForAnimations ? 100 : 0,
        ),
      );
      setState(() => _advancedImageBytes = bytes);
      if (bytes != null) {
        _showSnackBar('✅ Advanced capture completed!', Icons.check_circle);
      }
    } catch (e) {
      _showSnackBar('❌ Capture failed: $e', Icons.error, isError: true);
    }
  }

  Future<void> _captureAnimated() async {
    try {
      final bytes = await _animatedController.capture(
        options: const CaptureOptions(
          pixelRatio: 3.0,
          waitForAnimations: true,
          delayMs: 100,
        ),
      );
      setState(() => _animatedImageBytes = bytes);
      if (bytes != null) {
        _showSnackBar('✅ Animation captured!', Icons.check_circle);
      }
    } catch (e) {
      _showSnackBar('❌ Capture failed: $e', Icons.error, isError: true);
    }
  }

  void _copyToClipboard(Uint8List bytes) {
    _showSnackBar(
      '📋 Image copied! (${(bytes.length / 1024).toStringAsFixed(1)} KB)',
      Icons.content_copy,
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Widgets to Image'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A powerful Flutter package for converting widgets into high-quality images.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Multiple formats (PNG, JPEG, Raw)'),
            Text('• Customizable quality & pixel ratio'),
            Text('• Animation capture support'),
            Text('• Cross-platform compatibility'),
            Text('• Professional-grade output'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _launchGitHub() {
    _showSnackBar(
      '🔗 Visit: github.com/MohamedAbd0/widgets_to_image',
      Icons.open_in_new,
    );
  }
}
