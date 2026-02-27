import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tasbeeh/core/constants/app_constants.dart';
import 'package:smart_tasbeeh/core/localization/app_strings.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';
import 'package:smart_tasbeeh/core/utils/day_key.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_cubit.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/cubit/tasbeeh_state.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/qibla_tab.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/settings_tab.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/stats_tab.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/tasbeeh_tab.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/pages/tabs/zikr_tab.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/language_sheet.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/premium_background.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/target_sheet.dart';

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

  ZikrMeta _metaById(String zikrId) {
    for (final ZikrMeta zikr in AppConstants.zikrs) {
      if (zikr.id == zikrId) {
        return zikr;
      }
    }
    return AppConstants.zikrs.first;
  }

  String _zikrLabel(TasbeehState state, String zikrId) {
    final ZikrMeta meta = _metaById(zikrId);
    return _t(state, meta.labelKey);
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

  Future<void> _openTargetSheet(
    BuildContext context,
    TasbeehState state, {
    required String zikrId,
  }) {
    return showTargetSheet(
      context: context,
      title: _t(state, 'target_sheet_title'),
      subtitle: _t(state, 'target_sheet_subtitle'),
      selected: state.targetOf(zikrId),
      onSelected: (int value) {
        context.read<TasbeehCubit>().setTarget(zikrId, value);
      },
    );
  }

  Future<void> _openLanguageSheet(BuildContext context, TasbeehState state) {
    return showLanguageSheet(
      context: context,
      title: _t(state, 'language_sheet_title'),
      selectedCode: state.session.localeCode,
      onSelected: context.read<TasbeehCubit>().setLocale,
    );
  }

  int _streakDays(TasbeehState state) {
    int streak = 0;
    DateTime cursor = DateTime.now();

    while (true) {
      final String key = DayKey.fromDate(cursor);
      final int value = state.session.dailyHistory[key] ?? 0;
      if (value <= 0) {
        break;
      }
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  int _totalAllTime(TasbeehState state) {
    return AppConstants.zikrs.fold<int>(
      0,
      (int sum, ZikrMeta z) => sum + state.countOf(z.id),
    );
  }

  String _titleForTab(TasbeehState state) {
    switch (state.selectedTab) {
      case 0:
        return _t(state, 'tab_tasbeh');
      case 1:
        return _t(state, 'tab_zikrlar');
      case 2:
        return _t(state, 'tab_qibla');
      case 3:
        return _t(state, 'tab_stats');
      case 4:
        return _t(state, 'tab_settings');
      default:
        return _t(state, 'app_title');
    }
  }

  Widget _tabBody(BuildContext context, TasbeehState state) {
    final int activeCount = state.countOf(state.session.activeZikrId);
    final int activeTarget = state.targetOf(state.session.activeZikrId);
    final double progress = activeTarget <= 0
        ? 0
        : (activeCount / activeTarget).clamp(0, 1).toDouble();

    switch (state.selectedTab) {
      case 0:
        final ZikrMeta activeMeta = _metaById(state.session.activeZikrId);
        return TasbeehTab(
          t: (String key) => _t(state, key),
          activeLabel: _zikrLabel(state, state.session.activeZikrId),
          activeArabic: activeMeta.arabicText,
          activeCount: activeCount,
          activeTarget: activeTarget,
          progress: progress,
          canUndo: state.undoAction != null,
          onIncrement: () => _increment(context, auto: false),
          onUndo: () => context.read<TasbeehCubit>().undo(),
          onReset: () => _confirmReset(context, state),
          onSelectTarget: () {
            _openTargetSheet(
              context,
              state,
              zikrId: state.session.activeZikrId,
            );
          },
          onLongPressStart: (_) => _startFastCount(context),
          onLongPressEnd: (_) => _stopFastCount(),
          onLongPressCancel: _stopFastCount,
        );
      case 1:
        return ZikrTab(
          t: (String key) => _t(state, key),
          items: AppConstants.zikrs.map((ZikrMeta zikr) {
            return ZikrItemViewData(
              id: zikr.id,
              label: _t(state, zikr.labelKey),
              arabic: zikr.arabicText,
              count: state.countOf(zikr.id),
              target: state.targetOf(zikr.id),
              isActive: state.session.activeZikrId == zikr.id,
            );
          }).toList(),
          onSelectZikr: (String id) {
            context.read<TasbeehCubit>().selectZikr(id, openTasbeehTab: true);
          },
          onEditTarget: (String id) {
            _openTargetSheet(context, state, zikrId: id);
          },
        );
      case 2:
        return QiblaTab(
          t: (String key) => _t(state, key),
          direction: AppConstants.qiblaDemoDirection,
          distanceKm: AppConstants.qiblaDemoDistanceKm,
        );
      case 3:
        return StatsTab(
          t: (String key) => _t(state, key),
          todayTotal: state.todayTotal,
          weeklyTotal: state.weeklyTotal,
          streakDays: _streakDays(state),
          totalAllTime: _totalAllTime(state),
          dailyHistory: state.session.dailyHistory,
          zikrTotals: AppConstants.zikrs
              .map(
                (ZikrMeta z) =>
                    (label: _t(state, z.labelKey), value: state.countOf(z.id)),
              )
              .toList(),
        );
      case 4:
        return SettingsTab(
          t: (String key) => _t(state, key),
          themePreference: state.session.themePreference,
          localeCode: state.session.localeCode,
          vibrationEnabled: state.session.vibrationEnabled,
          soundEnabled: state.session.soundEnabled,
          dailyReminderEnabled: state.session.dailyReminderEnabled,
          fridayReminderEnabled: state.session.fridayReminderEnabled,
          onThemeChanged: context.read<TasbeehCubit>().setTheme,
          onLanguageTap: () => _openLanguageSheet(context, state),
          onVibrationChanged: context.read<TasbeehCubit>().setVibration,
          onSoundChanged: context.read<TasbeehCubit>().setSound,
          onDailyReminderChanged: context.read<TasbeehCubit>().setDailyReminder,
          onFridayReminderChanged: context
              .read<TasbeehCubit>()
              .setFridayReminder,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (BuildContext context, TasbeehState state) {
        if (state.isLoading) {
          return const Scaffold(
            body: PremiumBackground(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_titleForTab(state)),
            forceMaterialTransparency: true,
          ),
          extendBodyBehindAppBar: false,
          body: PremiumBackground(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(state.selectedTab),
                child: _tabBody(context, state),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: _PremiumBottomNav(
              selectedIndex: state.selectedTab,
              onTap: (int index) {
                context.read<TasbeehCubit>().selectTab(index);
              },
              items: <_BottomNavItem>[
                _BottomNavItem(
                  label: _t(state, 'tab_tasbeh'),
                  icon: Icons.touch_app_outlined,
                  selectedIcon: Icons.touch_app,
                ),
                _BottomNavItem(
                  label: _t(state, 'tab_zikrlar'),
                  icon: Icons.list_alt_outlined,
                  selectedIcon: Icons.list_alt,
                ),
                _BottomNavItem(
                  label: _t(state, 'tab_qibla'),
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                ),
                _BottomNavItem(
                  label: _t(state, 'tab_stats'),
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart,
                ),
                _BottomNavItem(
                  label: _t(state, 'tab_settings'),
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PremiumBottomNav extends StatelessWidget {
  const _PremiumBottomNav({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  final int selectedIndex;
  final List<_BottomNavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        decoration: BoxDecoration(
          color: dark
              ? Colors.black.withValues(alpha: 0.34)
              : Colors.white.withValues(alpha: 0.84),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: 0.1)
                : AppPalette.primary.withValues(alpha: 0.14),
            width: 1,
          ),
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: List<Widget>.generate(items.length, (int index) {
              final _BottomNavItem item = items[index];
              final bool selected = index == selectedIndex;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onTap(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? AppPalette.accent.withValues(alpha: 0.22)
                                : Colors.transparent,
                            boxShadow: selected
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: AppPalette.accent.withValues(
                                        alpha: 0.24,
                                      ),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : const <BoxShadow>[],
                          ),
                          child: Icon(
                            selected ? item.selectedIcon : item.icon,
                            size: 20,
                            color: selected
                                ? AppPalette.accent
                                : (dark
                                      ? Colors.white.withValues(alpha: 0.85)
                                      : AppPalette.primary.withValues(
                                          alpha: 0.75,
                                        )),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: selected
                                    ? AppPalette.accent
                                    : (dark
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : AppPalette.primary.withValues(
                                              alpha: 0.78,
                                            )),
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
