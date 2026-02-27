import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/theme_preference.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/settings_tab.dart';

void main() {
  testWidgets('SettingsTab handles language tap and toggles', (
    WidgetTester tester,
  ) async {
    int languageTapCount = 0;
    int vibrationChangeCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsTab(
            t: (String key) => key,
            themePreference: ThemePreference.system,
            localeCode: 'uz',
            vibrationEnabled: true,
            soundEnabled: false,
            dailyReminderEnabled: false,
            fridayReminderEnabled: false,
            onThemeChanged: (_) {},
            onLanguageTap: () => languageTapCount++,
            onVibrationChanged: (_) => vibrationChangeCount++,
            onSoundChanged: (_) {},
            onDailyReminderChanged: (_) {},
            onFridayReminderChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('language'));
    await tester.pump();
    expect(languageTapCount, 1);

    await tester.tap(find.byType(CupertinoSwitch).first);
    await tester.pump();
    expect(vibrationChangeCount, 1);
  });
}
