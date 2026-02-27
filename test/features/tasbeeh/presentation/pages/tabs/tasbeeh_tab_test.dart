import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/tasbeeh_tab.dart';

void main() {
  testWidgets('TasbeehTab increments and opens target selector', (
    WidgetTester tester,
  ) async {
    int incrementTapCount = 0;
    int targetTapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TasbeehTab(
            t: (String key) => key,
            activeLabel: 'Subhanallah',
            activeArabic: 'سُبْحَانَ ٱللَّٰهِ',
            activeCount: 118,
            activeTarget: 99,
            progress: 1,
            canUndo: true,
            onIncrement: () => incrementTapCount++,
            onUndo: () {},
            onReset: () {},
            onSelectTarget: () => targetTapCount++,
          ),
        ),
      ),
    );

    expect(find.text('Subhanallah'), findsOneWidget);
    expect(find.text('118'), findsOneWidget);

    await tester.tap(find.text('+1'));
    await tester.pump();
    expect(incrementTapCount, 1);

    await tester.tap(find.text('set_target'));
    await tester.pump();
    expect(targetTapCount, 1);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
