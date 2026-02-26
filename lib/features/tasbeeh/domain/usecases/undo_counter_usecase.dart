import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/undo_action.dart';

class UndoCounterUseCase {
  const UndoCounterUseCase();

  TasbeehSession call({
    required TasbeehSession session,
    required UndoAction action,
  }) {
    final int currentCount = session.counts[action.zikrId] ?? 0;
    final int nextCount = (currentCount - action.step).clamp(0, 1 << 31);

    final int todayCount = session.dailyHistory[action.dayKey] ?? 0;
    final int nextToday = (todayCount - action.step).clamp(0, 1 << 31);

    return session.copyWith(
      counts: <String, int>{...session.counts, action.zikrId: nextCount},
      dailyHistory: <String, int>{
        ...session.dailyHistory,
        action.dayKey: nextToday,
      },
    );
  }
}
