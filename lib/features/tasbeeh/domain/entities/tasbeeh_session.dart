import 'package:equatable/equatable.dart';
import 'package:smart_tasbeeh/core/constants/app_constants.dart';

import 'theme_preference.dart';

class TasbeehSession extends Equatable {
  const TasbeehSession({
    required this.localeCode,
    required this.themePreference,
    required this.activeZikrId,
    required this.counts,
    required this.targets,
    required this.dailyHistory,
    required this.vibrationEnabled,
    required this.soundEnabled,
    required this.dailyReminderEnabled,
    required this.fridayReminderEnabled,
  });

  factory TasbeehSession.initial() {
    return TasbeehSession(
      localeCode: 'uz',
      themePreference: ThemePreference.system,
      activeZikrId: AppConstants.zikrIds.first,
      counts: <String, int>{
        for (final String id in AppConstants.zikrIds) id: 0,
      },
      targets: <String, int>{
        for (final String id in AppConstants.zikrIds) id: 33,
      },
      dailyHistory: <String, int>{},
      vibrationEnabled: true,
      soundEnabled: false,
      dailyReminderEnabled: false,
      fridayReminderEnabled: false,
    );
  }

  final String localeCode;
  final ThemePreference themePreference;
  final String activeZikrId;
  final Map<String, int> counts;
  final Map<String, int> targets;
  final Map<String, int> dailyHistory;
  final bool vibrationEnabled;
  final bool soundEnabled;
  final bool dailyReminderEnabled;
  final bool fridayReminderEnabled;

  TasbeehSession copyWith({
    String? localeCode,
    ThemePreference? themePreference,
    String? activeZikrId,
    Map<String, int>? counts,
    Map<String, int>? targets,
    Map<String, int>? dailyHistory,
    bool? vibrationEnabled,
    bool? soundEnabled,
    bool? dailyReminderEnabled,
    bool? fridayReminderEnabled,
  }) {
    return TasbeehSession(
      localeCode: localeCode ?? this.localeCode,
      themePreference: themePreference ?? this.themePreference,
      activeZikrId: activeZikrId ?? this.activeZikrId,
      counts: counts ?? this.counts,
      targets: targets ?? this.targets,
      dailyHistory: dailyHistory ?? this.dailyHistory,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      fridayReminderEnabled:
          fridayReminderEnabled ?? this.fridayReminderEnabled,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    localeCode,
    themePreference,
    activeZikrId,
    _orderedEntries(counts),
    _orderedEntries(targets),
    _orderedEntries(dailyHistory),
    vibrationEnabled,
    soundEnabled,
    dailyReminderEnabled,
    fridayReminderEnabled,
  ];

  List<String> _orderedEntries(Map<String, int> map) {
    final List<String> entries = map.entries
        .map((MapEntry<String, int> entry) => '${entry.key}:${entry.value}')
        .toList();
    entries.sort();
    return entries;
  }
}
