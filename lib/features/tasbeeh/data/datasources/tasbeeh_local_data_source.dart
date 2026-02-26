import 'package:hive/hive.dart';
import 'package:smart_tasbeeh/core/constants/app_constants.dart';

abstract class TasbeehLocalDataSource {
  Future<String?> readSessionJson();
  Future<void> writeSessionJson(String sessionJson);
}

class HiveTasbeehLocalDataSource implements TasbeehLocalDataSource {
  const HiveTasbeehLocalDataSource(this._box);

  final Box<dynamic> _box;

  @override
  Future<String?> readSessionJson() async {
    final Object? value = _box.get(AppConstants.hiveSessionKey);
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  @override
  Future<void> writeSessionJson(String sessionJson) async {
    await _box.put(AppConstants.hiveSessionKey, sessionJson);
  }
}
