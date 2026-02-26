import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';

class UpdateTargetUseCase {
  const UpdateTargetUseCase();

  TasbeehSession call({
    required TasbeehSession session,
    required String zikrId,
    required int target,
  }) {
    return session.copyWith(
      targets: <String, int>{...session.targets, zikrId: target},
    );
  }
}
