import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_tasbeeh/core/constants/app_constants.dart';
import 'package:smart_tasbeeh/features/tasbeeh/data/datasources/tasbeeh_local_data_source.dart';
import 'package:smart_tasbeeh/features/tasbeeh/data/repositories/tasbeeh_repository_impl.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/repositories/tasbeeh_repository.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/increment_counter_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/load_session_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/reset_counter_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/save_session_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/select_active_zikr_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/undo_counter_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/update_preferences_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/usecases/update_target_usecase.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  if (sl.isRegistered<TasbeehCubit>()) {
    return;
  }

  await Hive.initFlutter();

  if (!Hive.isBoxOpen(AppConstants.hiveBoxName)) {
    await Hive.openBox<dynamic>(AppConstants.hiveBoxName);
  }

  sl.registerLazySingleton<Box<dynamic>>(
    () => Hive.box<dynamic>(AppConstants.hiveBoxName),
  );

  sl.registerLazySingleton<TasbeehLocalDataSource>(
    () => HiveTasbeehLocalDataSource(sl<Box<dynamic>>()),
  );

  sl.registerLazySingleton<TasbeehRepository>(
    () => TasbeehRepositoryImpl(localDataSource: sl<TasbeehLocalDataSource>()),
  );

  sl.registerLazySingleton<LoadSessionUseCase>(
    () => LoadSessionUseCase(sl<TasbeehRepository>()),
  );
  sl.registerLazySingleton<SaveSessionUseCase>(
    () => SaveSessionUseCase(sl<TasbeehRepository>()),
  );
  sl.registerLazySingleton<IncrementCounterUseCase>(
    IncrementCounterUseCase.new,
  );
  sl.registerLazySingleton<UndoCounterUseCase>(UndoCounterUseCase.new);
  sl.registerLazySingleton<ResetCounterUseCase>(ResetCounterUseCase.new);
  sl.registerLazySingleton<UpdateTargetUseCase>(UpdateTargetUseCase.new);
  sl.registerLazySingleton<SelectActiveZikrUseCase>(
    SelectActiveZikrUseCase.new,
  );
  sl.registerLazySingleton<UpdatePreferencesUseCase>(
    UpdatePreferencesUseCase.new,
  );

  sl.registerFactory<TasbeehCubit>(
    () => TasbeehCubit(
      loadSessionUseCase: sl<LoadSessionUseCase>(),
      saveSessionUseCase: sl<SaveSessionUseCase>(),
      incrementCounterUseCase: sl<IncrementCounterUseCase>(),
      undoCounterUseCase: sl<UndoCounterUseCase>(),
      resetCounterUseCase: sl<ResetCounterUseCase>(),
      updateTargetUseCase: sl<UpdateTargetUseCase>(),
      selectActiveZikrUseCase: sl<SelectActiveZikrUseCase>(),
      updatePreferencesUseCase: sl<UpdatePreferencesUseCase>(),
    ),
  );
}
