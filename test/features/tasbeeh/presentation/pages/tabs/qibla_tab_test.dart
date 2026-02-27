import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/qibla_tab.dart';

void main() {
  testWidgets('QiblaTab shows demo direction and distance', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QiblaTab(
            t: (String key) {
              if (key == 'direction_label') {
                return 'Direction';
              }
              if (key == 'distance_label') {
                return 'Distance';
              }
              if (key == 'qibla_title') {
                return 'Qibla Direction';
              }
              if (key == 'qibla_placeholder') {
                return 'Qibla module is ready';
              }
              return key;
            },
            direction: 245,
            distanceKm: 4231,
          ),
        ),
      ),
    );

    expect(find.text('245°'), findsOneWidget);
    expect(find.text('Distance: 4231 km'), findsOneWidget);
    expect(find.text('Qibla Direction'), findsOneWidget);
  });
}
