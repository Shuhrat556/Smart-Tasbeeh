import 'dart:convert';

import 'package:smart_tasbeeh/core/constants/app_constants.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/theme_preference.dart';

class TasbeehSessionModel {
  const TasbeehSessionModel({
    required this.localeCode,
    required this.themePreferenceIndex,
    required this.activeZikrId,
    required this.counts,
    required this.targets,
    required this.dailyHistory,
    required this.vibrationEnabled,
    required this.soundEnabled,
    required this.dailyReminderEnabled,
    required this.fridayReminderEnabled,
  });

  factory TasbeehSessionModel.fromEntity(TasbeehSession entity) {
    return TasbeehSessionModel(
      localeCode: entity.localeCode,
      themePreferenceIndex: entity.themePreference.index,
      activeZikrId: entity.activeZikrId,
      counts: entity.counts,
      targets: entity.targets,
      dailyHistory: entity.dailyHistory,
      vibrationEnabled: entity.vibrationEnabled,
      soundEnabled: entity.soundEnabled,
      dailyReminderEnabled: entity.dailyReminderEnabled,
      fridayReminderEnabled: entity.fridayReminderEnabled,
    );
  }

  factory TasbeehSessionModel.fromJson(String source) {
    final Object? decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      return TasbeehSessionModel.fromEntity(TasbeehSession.initial());
    }

    return TasbeehSessionModel(
      localeCode: decoded['locale_code'] as String? ?? 'uz',
      themePreferenceIndex: (decoded['theme_mode'] as num?)?.toInt() ?? 0,
      activeZikrId:
          decoded['active_zikr_id'] as String? ?? AppConstants.zikrIds.first,
      counts: _parseIntMap(decoded['counts']),
      targets: _parseIntMap(decoded['targets'], defaultValue: 33),
      dailyHistory: _parseIntMap(decoded['daily_history']),
      vibrationEnabled: decoded['vibration_enabled'] as bool? ?? true,
      soundEnabled: decoded['sound_enabled'] as bool? ?? false,
      dailyReminderEnabled: decoded['daily_reminder_enabled'] as bool? ?? false,
      fridayReminderEnabled:
          decoded['friday_reminder_enabled'] as bool? ?? false,
    );
  }

  final String localeCode;
  final int themePreferenceIndex;
  final String activeZikrId;
  final Map<String, int> counts;
  final Map<String, int> targets;
  final Map<String, int> dailyHistory;
  final bool vibrationEnabled;
  final bool soundEnabled;
  final bool dailyReminderEnabled;
  final bool fridayReminderEnabled;

  TasbeehSession toEntity() {
    final Map<String, int> normalizedCounts = <String, int>{
      for (final String id in AppConstants.zikrIds) id: counts[id] ?? 0,
    };
    final Map<String, int> normalizedTargets = <String, int>{
      for (final String id in AppConstants.zikrIds) id: targets[id] ?? 33,
    };

    return TasbeehSession(
      localeCode: localeCode,
      themePreference: ThemePreferenceX.fromIndex(themePreferenceIndex),
      activeZikrId: AppConstants.zikrIds.contains(activeZikrId)
          ? activeZikrId
          : AppConstants.zikrIds.first,
      counts: normalizedCounts,
      targets: normalizedTargets,
      dailyHistory: dailyHistory,
      vibrationEnabled: vibrationEnabled,
      soundEnabled: soundEnabled,
      dailyReminderEnabled: dailyReminderEnabled,
      fridayReminderEnabled: fridayReminderEnabled,
    );
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'locale_code': localeCode,
      'theme_mode': themePreferenceIndex,
      'active_zikr_id': activeZikrId,
      'counts': counts,
      'targets': targets,
      'daily_history': dailyHistory,
      'vibration_enabled': vibrationEnabled,
      'sound_enabled': soundEnabled,
      'daily_reminder_enabled': dailyReminderEnabled,
      'friday_reminder_enabled': fridayReminderEnabled,
    });
  }

  static Map<String, int> _parseIntMap(Object? source, {int defaultValue = 0}) {
    if (source is! Map) {
      return <String, int>{};
    }

    final Map<String, int> result = <String, int>{};
    for (final MapEntry<dynamic, dynamic> entry in source.entries) {
      final dynamic value = entry.value;
      result[entry.key.toString()] = value is num
          ? value.toInt()
          : defaultValue;
    }
    return result;
  }
}
