# Contributing to Widgets To Image

Thank you for your interest in contributing to this project! We welcome contributions from everyone.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with the following information:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Flutter and Dart versions
- Platform (iOS, Android, Web, etc.)
- Code samples if applicable

### Suggesting Features

We welcome feature suggestions! Please create an issue with:

- A clear and descriptive title
- Detailed description of the proposed feature
- Use cases and examples
- Why this feature would be useful

### Development Setup

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/widgets_to_image.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Install dependencies: `flutter pub get`
5. Run tests: `flutter test`

### Making Changes

1. Make your changes in your feature branch
2. Add tests for new functionality
3. Ensure all tests pass: `flutter test`
4. Check code formatting: `dart format lib test`
5. Run static analysis: `flutter analyze`
6. Update documentation if needed

### Testing

- Write tests for new features and bug fixes
- Ensure all existing tests still pass
- Test on multiple platforms when possible
- Update the example app if your changes affect the public API

### Code Style

- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Keep functions small and focused

### Commit Messages

Use clear and meaningful commit messages:

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

### Pull Request Process

1. Update the README.md with details of changes to the interface, if applicable
2. Update the CHANGELOG.md with your changes
3. Increase the version numbers in pubspec.yaml to the new version that this pull request would represent
4. Your pull request will be reviewed by maintainers
5. Address any feedback from reviewers
6. Once approved, your pull request will be merged

### Development Guidelines

#### API Design

- Keep the API simple and intuitive
- Maintain backward compatibility when possible
- Use clear and descriptive parameter names
- Provide comprehensive documentation

#### Performance

- Consider performance implications of changes
- Avoid unnecessary widget rebuilds
- Use efficient algorithms and data structures
- Test with large widgets and high pixel ratios

#### Error Handling

- Provide meaningful error messages
- Use custom exceptions when appropriate
- Handle edge cases gracefully
- Add proper validation for parameters

## Code of Conduct

This project follows the [Flutter Code of Conduct](https://github.com/flutter/flutter/blob/master/CODE_OF_CONDUCT.md). Please read and follow it in all your interactions with the project.

## Questions?

If you have questions about contributing, please create an issue with the "question" label, or reach out to the maintainers.

Thank you for contributing!
