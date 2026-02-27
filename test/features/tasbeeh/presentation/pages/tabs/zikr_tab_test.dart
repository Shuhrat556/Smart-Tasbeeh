import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/zikr_tab.dart';

void main() {
  testWidgets('ZikrTab renders rows and handles tap', (
    WidgetTester tester,
  ) async {
    String? selected;
    String? edited;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ZikrTab(
            t: (String key) => key,
            items: const <ZikrItemViewData>[
              ZikrItemViewData(
                id: 'subhanallah',
                label: 'Subhanallah',
                arabic: 'سُبْحَانَ ٱللَّٰهِ',
                count: 118,
                target: 99,
                isActive: true,
              ),
              ZikrItemViewData(
                id: 'alhamdulillah',
                label: 'Alhamdulillah',
                arabic: 'ٱلْحَمْدُ لِلَّٰهِ',
                count: 0,
                target: 33,
                isActive: false,
              ),
            ],
            onSelectZikr: (String id) => selected = id,
            onEditTarget: (String id) => edited = id,
          ),
        ),
      ),
    );

    expect(find.text('Subhanallah'), findsOneWidget);
    expect(find.text('ٱلْحَمْدُ لِلَّٰهِ'), findsOneWidget);

    await tester.tap(find.text('Subhanallah'));
    await tester.pump();
    expect(selected, 'subhanallah');

    await tester.tap(find.text('[ 118 / 99 ]'));
    await tester.pump();
    expect(edited, 'subhanallah');
  });
}
