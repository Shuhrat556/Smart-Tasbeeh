import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/theme_preference.dart';

class UpdatePreferencesUseCase {
  const UpdatePreferencesUseCase();

  TasbeehSession call({
    required TasbeehSession session,
    String? localeCode,
    ThemePreference? themePreference,
    bool? vibrationEnabled,
    bool? soundEnabled,
    bool? dailyReminderEnabled,
    bool? fridayReminderEnabled,
  }) {
    return session.copyWith(
      localeCode: localeCode,
      themePreference: themePreference,
      vibrationEnabled: vibrationEnabled,
      soundEnabled: soundEnabled,
      dailyReminderEnabled: dailyReminderEnabled,
      fridayReminderEnabled: fridayReminderEnabled,
    );
  }
}
