import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/repositories/tasbeeh_repository.dart';

class LoadSessionUseCase {
  const LoadSessionUseCase(this._repository);

  final TasbeehRepository _repository;

  Future<TasbeehSession> call() {
    return _repository.loadSession();
  }
}
