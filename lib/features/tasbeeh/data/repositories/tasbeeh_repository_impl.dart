import 'package:smart_tasbeeh/features/tasbeeh/data/datasources/tasbeeh_local_data_source.dart';
import 'package:smart_tasbeeh/features/tasbeeh/data/models/tasbeeh_session_model.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/repositories/tasbeeh_repository.dart';

class TasbeehRepositoryImpl implements TasbeehRepository {
  const TasbeehRepositoryImpl({required TasbeehLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final TasbeehLocalDataSource _localDataSource;

  @override
  Future<TasbeehSession> loadSession() async {
    final String? raw = await _localDataSource.readSessionJson();
    if (raw == null) {
      return TasbeehSession.initial();
    }

    return TasbeehSessionModel.fromJson(raw).toEntity();
  }

  @override
  Future<void> saveSession(TasbeehSession session) async {
    final TasbeehSessionModel model = TasbeehSessionModel.fromEntity(session);
    await _localDataSource.writeSessionJson(model.toJson());
  }
}
