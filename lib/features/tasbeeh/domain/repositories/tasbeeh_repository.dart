import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/tasbeeh_session.dart';

abstract class TasbeehRepository {
  Future<TasbeehSession> loadSession();
  Future<void> saveSession(TasbeehSession session);
}
