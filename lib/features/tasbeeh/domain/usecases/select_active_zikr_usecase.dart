import 'package:smart_tasbeeh/core/constants/app_constants.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';

class SelectActiveZikrUseCase {
  const SelectActiveZikrUseCase();

  TasbeehSession call({
    required TasbeehSession session,
    required String zikrId,
  }) {
    final String validId = AppConstants.zikrIds.contains(zikrId)
        ? zikrId
        : session.activeZikrId;

    return session.copyWith(activeZikrId: validId);
  }
}
