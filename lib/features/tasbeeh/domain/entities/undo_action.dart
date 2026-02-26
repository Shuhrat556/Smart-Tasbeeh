import 'package:equatable/equatable.dart';

class UndoAction extends Equatable {
  const UndoAction({
    required this.zikrId,
    required this.step,
    required this.dayKey,
  });

  final String zikrId;
  final int step;
  final String dayKey;

  @override
  List<Object?> get props => <Object?>[zikrId, step, dayKey];
}
