import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/theme_preference.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/undo_action.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/increment_counter_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/load_session_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/reset_counter_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/save_session_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/select_active_zikr_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/undo_counter_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/update_preferences_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/update_target_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_state.dart';

class TasbeehCubit extends Cubit<TasbeehState> {
  TasbeehCubit({
    required LoadSessionUseCase loadSessionUseCase,
    required SaveSessionUseCase saveSessionUseCase,
    required IncrementCounterUseCase incrementCounterUseCase,
    required UndoCounterUseCase undoCounterUseCase,
    required ResetCounterUseCase resetCounterUseCase,
    required UpdateTargetUseCase updateTargetUseCase,
    required SelectActiveZikrUseCase selectActiveZikrUseCase,
    required UpdatePreferencesUseCase updatePreferencesUseCase,
  }) : _loadSessionUseCase = loadSessionUseCase,
       _saveSessionUseCase = saveSessionUseCase,
       _incrementCounterUseCase = incrementCounterUseCase,
       _undoCounterUseCase = undoCounterUseCase,
       _resetCounterUseCase = resetCounterUseCase,
       _updateTargetUseCase = updateTargetUseCase,
       _selectActiveZikrUseCase = selectActiveZikrUseCase,
       _updatePreferencesUseCase = updatePreferencesUseCase,
       super(TasbeehState.initial());

  final LoadSessionUseCase _loadSessionUseCase;
  final SaveSessionUseCase _saveSessionUseCase;
  final IncrementCounterUseCase _incrementCounterUseCase;
  final UndoCounterUseCase _undoCounterUseCase;
  final ResetCounterUseCase _resetCounterUseCase;
  final UpdateTargetUseCase _updateTargetUseCase;
  final SelectActiveZikrUseCase _selectActiveZikrUseCase;
  final UpdatePreferencesUseCase _updatePreferencesUseCase;

  Timer? _saveDebounce;

  Future<void> initialize() async {
    final session = await _loadSessionUseCase();
    emit(state.copyWith(isLoading: false, session: session, undoAction: null));
  }

  void selectTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }

  void selectZikr(String zikrId, {bool openTasbeehTab = false}) {
    final updated = _selectActiveZikrUseCase(
      session: state.session,
      zikrId: zikrId,
    );
    emit(
      state.copyWith(
        session: updated,
        selectedTab: openTasbeehTab ? 0 : state.selectedTab,
      ),
    );
    _scheduleSave();
  }

  void setTarget(String zikrId, int target) {
    final updated = _updateTargetUseCase(
      session: state.session,
      zikrId: zikrId,
      target: target,
    );
    emit(state.copyWith(session: updated));
    _scheduleSave();
  }

  bool increment() {
    final result = _incrementCounterUseCase(
      session: state.session,
      zikrId: state.session.activeZikrId,
      now: DateTime.now(),
    );
    emit(
      state.copyWith(session: result.session, undoAction: result.undoAction),
    );
    _scheduleSave();
    return result.reachedTarget;
  }

  void undo() {
    final UndoAction? action = state.undoAction;
    if (action == null) {
      return;
    }

    final updated = _undoCounterUseCase(session: state.session, action: action);
    emit(state.copyWith(session: updated, undoAction: null));
    _scheduleSave();
  }

  void resetActiveCounter() {
    final updated = _resetCounterUseCase(
      session: state.session,
      zikrId: state.session.activeZikrId,
    );
    emit(state.copyWith(session: updated, undoAction: null));
    _scheduleSave();
  }

  void setLocale(String localeCode) {
    final updated = _updatePreferencesUseCase(
      session: state.session,
      localeCode: localeCode,
    );
    emit(state.copyWith(session: updated));
    _scheduleSave();
  }

  void setTheme(ThemePreference preference) {
    final updated = _updatePreferencesUseCase(
      session: state.session,
      themePreference: preference,
    );
    emit(state.copyWith(session: updated));
    _scheduleSave();
  }

  void setVibration(bool enabled) {
    final updated = _updatePreferencesUseCase(
      session: state.session,
      vibrationEnabled: enabled,
    );
    emit(state.copyWith(session: updated));
    _scheduleSave();
  }

  void setSound(bool enabled) {
    final updated = _updatePreferencesUseCase(
      session: state.session,
      soundEnabled: enabled,
    );
    emit(state.copyWith(session: updated));
    _scheduleSave();
  }

  void setDailyReminder(bool enabled) {
    final updated = _updatePreferencesUseCase(
      session: state.session,
      dailyReminderEnabled: enabled,
    );
    emit(state.copyWith(session: updated));
    _scheduleSave();
  }

  void setFridayReminder(bool enabled) {
    final updated = _updatePreferencesUseCase(
      session: state.session,
      fridayReminderEnabled: enabled,
    );
    emit(state.copyWith(session: updated));
    _scheduleSave();
  }

  Future<void> saveNow() {
    return _saveSessionUseCase(state.session);
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 250), () async {
      await _saveSessionUseCase(state.session);
    });
  }

  @override
  Future<void> close() {
    _saveDebounce?.cancel();
    return super.close();
  }
}
