# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

This project uses Flutter for cross-platform mobile development:

- **Install dependencies**: `flutter pub get`
- **Run the application**: `flutter run`
- **Run tests**: `flutter test`
- **Run a specific test**: `flutter test test/widget_test.dart`
- **Build for release**: `flutter build apk` (Android) or `flutter build ios` (iOS)
- **Check for issues**: `flutter doctor`

## Documentation Commands

- **Build LaTeX documentation**: `docs/latex/build.sh`
- **Force rebuild documentation**: `docs/latex/build.sh --force`

## Architecture Overview

This is a Flutter application that simulates Risk (Risiko) battle probabilities. The app will be organized into several key components:

### Planned Core Components

- **Battle probability calculations**: Dart classes to calculate single dice roll probabilities for different attacker/defender combinations (1v1, 1v2, 2v1, 2v2, 3v1, 3v2)
- **Composite probability engine**: Advanced calculations for complex battle outcomes using recursive and matrix methods
- **UI components**: Flutter widgets for inputting battle parameters and displaying results
- **Visualization**: Charts and graphs to display probability distributions

### Key Algorithms (To Implement)

The application will implement multiple mathematical approaches:

1. **Recursive Method**: Direct recursive calculation of win probabilities
2. **Matrix Method**: Dynamic programming approach using matrices for efficient calculation
3. **Precise Calculations**: Methods to calculate exact probabilities for specific outcomes (e.g., winning with exactly N troops remaining)
4. **Safe Attack Mode**: Simulation of conservative attacks where attacker stops at 2 troops

### Testing

- Tests will be in `test/` directory using Flutter's testing framework
- Unit tests for probability calculation algorithms
- Widget tests for UI components
- Integration tests for complete user flows

### Dependencies

- **Flutter SDK**: Cross-platform mobile development framework
- **Dart**: Programming language for Flutter applications
- **Charts/visualization packages**: For displaying probability distributions

### Project Context

This is a learning project focused on:
- Building cross-platform mobile app capabilities
- Understanding app development fundamentals with Flutter
- Implementing mathematical probability calculations in Dart
- Creating intuitive mobile UIs for probability visualization

The application will calculate and visualize Risk battle probabilities with a native mobile interface.

## Code Style Requirements

**NO COMMENTS POLICY**: This project must not contain any comments in the code. All code should be self-documenting through clear naming and structure. Do not add comments to any files unless explicitly told.

**TRAILING NEWLINE REQUIREMENT**: All files must end with a newline character. Ensure every file has exactly one empty line at the end.

**FORMATTING**: Use `dart format --line-length=120` to format all code that is written and committed.

## Communication Style

**NO FILLER PHRASES**: Do not use unnecessary phrases like "Great question", "Excellent point", "Good catch", or similar validation language. Get straight to the technical content.