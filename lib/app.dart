import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_tasbeeh/core/di/service_locator.dart';
import 'package:smart_tasbeeh/core/localization/app_strings.dart';
import 'package:smart_tasbeeh/core/theme/app_theme.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_state.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tasbeeh_page.dart';

class SmartTasbeehRoot extends StatelessWidget {
  const SmartTasbeehRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasbeehCubit>(
      create: (_) => sl<TasbeehCubit>()..initialize(),
      child: BlocBuilder<TasbeehCubit, TasbeehState>(
        builder: (BuildContext context, TasbeehState state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.tr(state.session.localeCode, 'app_title'),
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            locale: state.locale,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const TasbeehPage(),
          );
        },
      ),
    );
  }
}
