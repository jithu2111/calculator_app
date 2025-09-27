// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_app/main.dart';

void main() {
  testWidgets('Calculator basic functionality test', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('Calculator'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();

    await tester.tap(find.text('+'));
    await tester.pump();

    await tester.tap(find.text('3'));
    await tester.pump();

    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.byWidgetPredicate((widget) => 
      widget is Text && 
      widget.data == '8' && 
      widget.style?.fontSize == 48.0
    ), findsOneWidget);
  });
}
