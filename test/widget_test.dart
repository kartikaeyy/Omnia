// Smoke test for the splash screen that `MyApp` shows on launch.
//
// `MyApp` itself does not touch Firebase (that is initialised in `main()`), so
// it can be pumped directly. Tapping through is deliberately not exercised here:
// the splash pushes `WidgetTREEE`, which reads `FirebaseAuth.instance` and so
// needs a live Firebase app that a plain widget test cannot provide.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:omnia/main.dart';

void main() {
  testWidgets('splash screen renders', (WidgetTester tester) async {
    // The splash lays out against a phone-sized canvas rather than the default
    // 800x600 test surface.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Tap'), findsOneWidget);
    expect(find.byIcon(Icons.touch_app), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);
  });
}
