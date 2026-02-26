import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/repositories/tasbeeh_repository.dart';

class SaveSessionUseCase {
  const SaveSessionUseCase(this._repository);

  final TasbeehRepository _repository;

  Future<void> call(TasbeehSession session) {
    return _repository.saveSession(session);
  }
}
