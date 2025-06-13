# GitHub Pages Deployment

This document explains how to deploy the Widgets to Image demo to GitHub Pages.

## Setup

The project is configured with GitHub Actions to automatically deploy to GitHub Pages when changes are pushed to the main branch.

### Configuration Files

1. **GitHub Actions Workflow** (`.github/workflows/deploy.yml`)

   - Automatically builds and deploys the Flutter web app
   - Triggered on pushes to main/master branch
   - Uses Flutter 3.24.0 stable channel

2. **Web Configuration** (`example/web/index.html`)
   - Professional loading screen with package branding
   - SEO-optimized meta tags
   - Responsive design

## Deployment Process

### Automatic Deployment

When you push to the main branch:

1. GitHub Actions will automatically:
   - Setup Flutter environment
   - Install dependencies
   - Analyze code
   - Build web app with correct base href
   - Deploy to GitHub Pages

### Manual Deployment

To deploy manually:

```bash
cd example
flutter build web --base-href /widgets_to_image/
```

Then commit and push the changes.

## GitHub Pages Settings

1. Go to repository Settings > Pages
2. Set source to "Deploy from a branch"
3. Select "gh-pages" branch
4. The site will be available at: `https://USERNAME.github.io/widgets_to_image/`

## Features in the Demo

The deployed demo showcases:

### 🎯 Basic Widget Capture

- Simple one-click PNG capture
- Professional gradient card design
- Real-time file size display

### ⚙️ Advanced Configuration

- Multiple format support (PNG, JPEG, Raw)
- Quality settings for JPEG
- Pixel ratio customization
- Animation wait options

### 🎭 Animation Capture

- Rotating gradient animation
- Pause/play controls
- High-resolution capture

### 🎨 Modern UI Design

- Material 3 design system
- Indigo color scheme
- Responsive layout
- Professional typography
- Smooth animations

## Performance Optimizations

- Tree-shaking enabled for icons (99%+ reduction)
- Optimized font loading
- Service worker for caching
- Progressive loading screen

## Browser Compatibility

- Chrome/Chromium ✅
- Firefox ✅
- Safari ✅
- Edge ✅
- Mobile browsers ✅

## Development

To run locally:

```bash
cd example
flutter run -d chrome --web-port 8080
```

## Build Information

- Flutter: 3.24.0 stable
- Web renderer: Default (auto)
- Base href: `/widgets_to_image/`
- Tree-shaking: Enabled

## Troubleshooting

### Build Issues

- Ensure Flutter SDK is up to date
- Run `flutter clean && flutter pub get`
- Check GitHub Actions logs for detailed errors

### Display Issues

- Verify base href is correctly set
- Check browser console for errors
- Test on different browsers

## Updates

To update the demo:

1. Make changes to `example/lib/main.dart`
2. Test locally with `flutter run -d chrome`
3. Commit and push to main branch
4. GitHub Actions will automatically deploy

The deployment typically takes 2-3 minutes to complete.
