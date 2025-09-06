// This is a basic Flutter widget test for the Weather App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:minimalweatherapp/main.dart';

void main() {
  // Setup for tests
  setUpAll(() async {
    // Load test environment variables
    dotenv.testLoad(fileInput: 'WEATHER_API_KEY=test_key_for_testing');
  });

  testWidgets('Weather app starts and shows basic UI', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Give it a moment to start rendering
    await tester.pump();

    // Verify that there's some initial UI element
    final hasContainer = find.byType(Container);
    final hasScaffold = find.byType(Scaffold);

    // At least one of these should be present
    expect(
      hasContainer.evaluate().isNotEmpty || hasScaffold.evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('App has proper Material design structure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Verify that the app uses MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that there's a Scaffold structure
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
