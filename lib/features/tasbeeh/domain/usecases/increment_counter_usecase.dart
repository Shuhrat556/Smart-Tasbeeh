import 'package:equatable/equatable.dart';
import 'package:smart_tasbeeh/core/utils/day_key.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/undo_action.dart';

class IncrementCounterUseCase {
  const IncrementCounterUseCase();

  IncrementResult call({
    required TasbeehSession session,
    required String zikrId,
    required DateTime now,
  }) {
    final int current = session.counts[zikrId] ?? 0;
    final int target = session.targets[zikrId] ?? 33;
    final int nextValue = current + 1;
    final String today = DayKey.fromDate(now);

    final Map<String, int> nextCounts = <String, int>{
      ...session.counts,
      zikrId: nextValue,
    };
    final Map<String, int> nextHistory = <String, int>{
      ...session.dailyHistory,
      today: (session.dailyHistory[today] ?? 0) + 1,
    };

    final TasbeehSession nextSession = session.copyWith(
      counts: nextCounts,
      dailyHistory: nextHistory,
    );

    return IncrementResult(
      session: nextSession,
      reachedTarget: current < target && nextValue >= target,
      undoAction: UndoAction(zikrId: zikrId, step: 1, dayKey: today),
    );
  }
}

class IncrementResult extends Equatable {
  const IncrementResult({
    required this.session,
    required this.reachedTarget,
    required this.undoAction,
  });

  final TasbeehSession session;
  final bool reachedTarget;
  final UndoAction undoAction;

  @override
  List<Object?> get props => <Object?>[session, reachedTarget, undoAction];
}
