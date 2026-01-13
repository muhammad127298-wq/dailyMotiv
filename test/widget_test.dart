// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Test 1: Basic widget test
  testWidgets('Find widgets in MaterialApp', (WidgetTester tester) async {
    // Create a test widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('DailyMotiv'),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Test Button'),
              ),
            ],
          ),
        ),
      ),
    ));

    // Verify text is found
    expect(find.text('DailyMotiv'), findsOneWidget);
    expect(find.text('Test Button'), findsOneWidget);
  });

  // Test 2: Test button tap
  testWidgets('Button tap test', (WidgetTester tester) async {
    var tapped = false;
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              tapped = true;
            },
            child: const Text('Tap me'),
          ),
        ),
      ),
    ));

    // Tap the button
    await tester.tap(find.text('Tap me'));
    await tester.pump();

    // Verify tap worked
    expect(tapped, true);
  });
}