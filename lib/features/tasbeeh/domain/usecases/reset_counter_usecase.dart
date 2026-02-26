import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';

class ResetCounterUseCase {
  const ResetCounterUseCase();

  TasbeehSession call({
    required TasbeehSession session,
    required String zikrId,
  }) {
    return session.copyWith(
      counts: <String, int>{...session.counts, zikrId: 0},
    );
  }
}
