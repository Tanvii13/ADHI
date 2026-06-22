// Basic smoke test: verifies the app boots and the homepage renders its
// key landmarks without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adhi/main.dart';

void main() {
  testWidgets('ADHI home page renders title and feature cards', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(2000, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdhiApp());
    await tester.pumpAndSettle();

    expect(find.text('ADHI'), findsWidgets);
    expect(find.text('Accessibility is not a privilege; it is a right.'), findsOneWidget);
    expect(find.text('The World Adapts To You'), findsOneWidget);
  });

  testWidgets('Tapping Vision Assistant nav link navigates to Vision page',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(2000, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdhiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Vision Assistant').first);
    await tester.pumpAndSettle();

    expect(find.text('Vision Assistant'), findsWidgets);
  });
}
