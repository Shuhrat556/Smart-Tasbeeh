import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tasbeeh/core/constants/app_constants.dart';
import 'package:smart_tasbeeh/core/localization/app_strings.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/theme_preference.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_state.dart';

class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  static const Duration _fastCountInterval = Duration(milliseconds: 120);

  Timer? _fastCountTimer;

  @override
  void dispose() {
    _stopFastCount();
    super.dispose();
  }

  String _t(TasbeehState state, String key) {
    return AppStrings.tr(state.session.localeCode, key);
  }

  String _zikrLabel(TasbeehState state, String zikrId) {
    return _t(state, 'zikr_$zikrId');
  }

  void _increment(BuildContext context, {required bool auto}) {
    final TasbeehCubit cubit = context.read<TasbeehCubit>();
    final bool reachedTarget = cubit.increment();
    final TasbeehState updatedState = cubit.state;

    if (!auto && updatedState.session.vibrationEnabled) {
      HapticFeedback.selectionClick();
    }
    if (!auto && updatedState.session.soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }

    if (reachedTarget) {
      if (updatedState.session.vibrationEnabled) {
        HapticFeedback.heavyImpact();
      }
      if (updatedState.session.soundEnabled) {
        SystemSound.play(SystemSoundType.alert);
      }
      _showGoalReachedDialog(context, updatedState);
    }
  }

  void _startFastCount(BuildContext context) {
    _fastCountTimer?.cancel();
    _fastCountTimer = Timer.periodic(_fastCountInterval, (_) {
      _increment(context, auto: true);
    });
  }

  void _stopFastCount() {
    _fastCountTimer?.cancel();
    _fastCountTimer = null;
  }

  Future<void> _saveSession(BuildContext context, TasbeehState state) async {
    await context.read<TasbeehCubit>().saveNow();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_t(state, 'session_saved'))));
  }

  Future<void> _confirmReset(BuildContext context, TasbeehState state) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_t(state, 'reset_confirm_title')),
          content: Text(_t(state, 'reset_confirm_body')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(_t(state, 'cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(_t(state, 'confirm')),
            ),
          ],
        );
      },
    );

    if (!context.mounted) {
      return;
    }
    if (confirmed == true) {
      context.read<TasbeehCubit>().resetActiveCounter();
    }
  }

  Future<void> _showGoalReachedDialog(
    BuildContext context,
    TasbeehState state,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_t(state, 'goal_reached_title')),
          content: Text(_t(state, 'goal_reached_body')),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_t(state, 'confirm')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (BuildContext context, TasbeehState state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final int activeCount = state.countOf(state.session.activeZikrId);
        final int activeTarget = state.targetOf(state.session.activeZikrId);
        final double progress = activeTarget <= 0
            ? 0
            : (activeCount / activeTarget).clamp(0, 1).toDouble();

        return Scaffold(
          appBar: AppBar(title: Text(_t(state, 'app_title'))),
          body: IndexedStack(
            index: state.selectedTab,
            children: <Widget>[
              _buildTasbehTab(
                context,
                state,
                activeCount: activeCount,
                activeTarget: activeTarget,
                progress: progress,
              ),
              _buildZikrTab(context, state),
              _buildQiblaTab(state),
              _buildStatsTab(state),
              _buildSettingsTab(context, state),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.selectedTab,
            onDestinationSelected: context.read<TasbeehCubit>().selectTab,
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: const Icon(Icons.touch_app_outlined),
                selectedIcon: const Icon(Icons.touch_app),
                label: _t(state, 'tab_tasbeh'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.list_alt_outlined),
                selectedIcon: const Icon(Icons.list_alt),
                label: _t(state, 'tab_zikrlar'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore),
                label: _t(state, 'tab_qibla'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: _t(state, 'tab_stats'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: _t(state, 'tab_settings'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTasbehTab(
    BuildContext context,
    TasbeehState state, {
    required int activeCount,
    required int activeTarget,
    required double progress,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${_t(state, 'current_zikr')}: '
                      '${_zikrLabel(state, state.session.activeZikrId)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_t(state, 'count')}: $activeCount',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('${_t(state, 'target')}: $activeTarget'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% '
                      '${_t(state, 'progress')}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_t(state, 'set_target')),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.targetOptions.map((int value) {
                        return ChoiceChip(
                          label: Text('$value'),
                          selected: activeTarget == value,
                          onSelected: (_) {
                            context.read<TasbeehCubit>().setTarget(
                              state.session.activeZikrId,
                              value,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => _increment(context, auto: false),
                onLongPressStart: (_) => _startFastCount(context),
                onLongPressEnd: (_) => _stopFastCount(),
                onLongPressCancel: _stopFastCount,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '+1',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_t(state, 'tap_hint')),
                      Text(_t(state, 'long_press_hint')),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: state.undoAction == null
                      ? null
                      : () => context.read<TasbeehCubit>().undo(),
                  icon: const Icon(Icons.undo),
                  label: Text(_t(state, 'undo')),
                ),
                OutlinedButton.icon(
                  onPressed: () => _confirmReset(context, state),
                  icon: const Icon(Icons.restart_alt),
                  label: Text(_t(state, 'reset')),
                ),
                TextButton.icon(
                  onPressed: () => _saveSession(context, state),
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_t(state, 'save_session')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _t(state, 'session_auto_saved'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _t(state, 'mini_duas'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.wb_sunny_outlined),
                      title: Text(_t(state, 'dua_of_day')),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.bedtime_outlined),
                      title: Text(_t(state, 'before_sleep')),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.mosque_outlined),
                      title: Text(_t(state, 'after_prayer')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZikrTab(BuildContext context, TasbeehState state) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: AppConstants.zikrIds.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final String zikrId = AppConstants.zikrIds[index];
          final int count = state.countOf(zikrId);
          final int currentTarget = state.targetOf(zikrId);
          final int dropdownTarget =
              AppConstants.targetOptions.contains(currentTarget)
              ? currentTarget
              : AppConstants.targetOptions.first;
          final bool isActive = state.session.activeZikrId == zikrId;

          return Card(
            child: ListTile(
              onTap: () => context.read<TasbeehCubit>().selectZikr(
                zikrId,
                openTasbeehTab: true,
              ),
              title: Text(_zikrLabel(state, zikrId)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: <Widget>[
                    Text('${_t(state, 'count')}: $count'),
                    const SizedBox(width: 16),
                    Text('${_t(state, 'target')}:'),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: dropdownTarget,
                      items: AppConstants.targetOptions.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        if (value != null) {
                          context.read<TasbeehCubit>().setTarget(zikrId, value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              trailing: isActive
                  ? Chip(
                      avatar: const Icon(Icons.check, size: 16),
                      label: Text(_t(state, 'active')),
                    )
                  : const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQiblaTab(TasbeehState state) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.explore,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _t(state, 'qibla_title'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_t(state, 'qibla_desc')),
                  const SizedBox(height: 8),
                  Text(
                    _t(state, 'qibla_placeholder'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(_t(state, 'prayer_times')),
              subtitle: Text(_t(state, 'coming_soon')),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(_t(state, 'nearby_mosques')),
              subtitle: Text(_t(state, 'coming_soon')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab(TasbeehState state) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _statCard(state, _t(state, 'stats_today'), state.todayTotal),
          const SizedBox(height: 8),
          _statCard(state, _t(state, 'stats_week'), state.weeklyTotal),
          const SizedBox(height: 8),
          _statCard(state, _t(state, 'stats_month'), state.monthlyTotal),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: Text(_t(state, 'most_used')),
              subtitle: Text(
                state.mostUsedZikr == null
                    ? _t(state, 'no_data')
                    : _zikrLabel(state, state.mostUsedZikr!),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: AppConstants.zikrIds.map((String id) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_zikrLabel(state, id)),
                        Text('${state.countOf(id)}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(TasbeehState state, String label, int value) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          '$value',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context, TasbeehState state) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _t(state, 'theme'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<ThemePreference>(
                    segments: <ButtonSegment<ThemePreference>>[
                      ButtonSegment<ThemePreference>(
                        value: ThemePreference.system,
                        label: Text(_t(state, 'theme_system')),
                      ),
                      ButtonSegment<ThemePreference>(
                        value: ThemePreference.light,
                        label: Text(_t(state, 'theme_light')),
                      ),
                      ButtonSegment<ThemePreference>(
                        value: ThemePreference.dark,
                        label: Text(_t(state, 'theme_dark')),
                      ),
                    ],
                    selected: <ThemePreference>{state.session.themePreference},
                    onSelectionChanged: (Set<ThemePreference> selected) {
                      context.read<TasbeehCubit>().setTheme(selected.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(_t(state, 'choose_lang')),
              subtitle: Text(_t(state, 'language')),
              trailing: DropdownButton<String>(
                value: state.session.localeCode,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(value: 'uz', child: Text('Uzbek')),
                  DropdownMenuItem<String>(value: 'tj', child: Text('Tojik')),
                  DropdownMenuItem<String>(value: 'ru', child: Text('Русский')),
                  DropdownMenuItem<String>(value: 'en', child: Text('English')),
                ],
                onChanged: (String? code) {
                  if (code != null) {
                    context.read<TasbeehCubit>().setLocale(code);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  value: state.session.vibrationEnabled,
                  onChanged: context.read<TasbeehCubit>().setVibration,
                  title: Text(_t(state, 'vibration')),
                ),
                SwitchListTile(
                  value: state.session.soundEnabled,
                  onChanged: context.read<TasbeehCubit>().setSound,
                  title: Text(_t(state, 'sound')),
                ),
                SwitchListTile(
                  value: state.session.dailyReminderEnabled,
                  onChanged: context.read<TasbeehCubit>().setDailyReminder,
                  title: Text(_t(state, 'reminder_daily')),
                ),
                SwitchListTile(
                  value: state.session.fridayReminderEnabled,
                  onChanged: context.read<TasbeehCubit>().setFridayReminder,
                  title: Text(_t(state, 'reminder_friday')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
