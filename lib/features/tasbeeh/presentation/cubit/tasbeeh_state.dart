import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/utils/day_key.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/theme_preference.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/undo_action.dart';

class TasbeehState extends Equatable {
  const TasbeehState({
    required this.isLoading,
    required this.session,
    required this.selectedTab,
    this.undoAction,
  });

  factory TasbeehState.initial() {
    return TasbeehState(
      isLoading: true,
      session: TasbeehSession.initial(),
      selectedTab: 0,
    );
  }

  final bool isLoading;
  final TasbeehSession session;
  final int selectedTab;
  final UndoAction? undoAction;

  ThemeMode get themeMode => session.themePreference.toThemeMode();
  Locale get locale => Locale(session.localeCode);

  int countOf(String zikrId) => session.counts[zikrId] ?? 0;
  int targetOf(String zikrId) => session.targets[zikrId] ?? 33;

  int get todayTotal {
    final String key = DayKey.fromDate(DateTime.now());
    return session.dailyHistory[key] ?? 0;
  }

  int get weeklyTotal => DayKey.sumLastDays(session.dailyHistory, 7);
  int get monthlyTotal => DayKey.sumLastDays(session.dailyHistory, 30);

  String? get mostUsedZikr {
    String? id;
    int max = 0;
    for (final MapEntry<String, int> entry in session.counts.entries) {
      if (entry.value > max) {
        max = entry.value;
        id = entry.key;
      }
    }
    return max > 0 ? id : null;
  }

  TasbeehState copyWith({
    bool? isLoading,
    TasbeehSession? session,
    int? selectedTab,
    Object? undoAction = _notSet,
  }) {
    return TasbeehState(
      isLoading: isLoading ?? this.isLoading,
      session: session ?? this.session,
      selectedTab: selectedTab ?? this.selectedTab,
      undoAction: undoAction == _notSet
          ? this.undoAction
          : undoAction as UndoAction?,
    );
  }

  static const Object _notSet = Object();

  @override
  List<Object?> get props => <Object?>[
    isLoading,
    session,
    selectedTab,
    undoAction,
  ];
}
