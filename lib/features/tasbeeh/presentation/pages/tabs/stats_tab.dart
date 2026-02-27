import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';
import 'package:smart_tasbeeh/core/utils/day_key.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/glow_card.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({
    super.key,
    required this.t,
    required this.todayTotal,
    required this.weeklyTotal,
    required this.streakDays,
    required this.totalAllTime,
    required this.dailyHistory,
    required this.zikrTotals,
  });

  final String Function(String key) t;
  final int todayTotal;
  final int weeklyTotal;
  final int streakDays;
  final int totalAllTime;
  final Map<String, int> dailyHistory;
  final List<({String label, int value})> zikrTotals;

  @override
  Widget build(BuildContext context) {
    final List<({String label, int value})> sortedZikrs =
        List<({String label, int value})>.from(zikrTotals)
          ..sort((a, b) => b.value.compareTo(a.value));

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: <Widget>[
          _SummaryCard(
            icon: Icons.mosque_rounded,
            title: t('stats_today'),
            subtitle: '${t('stats_week')}: ${_formatNumber(weeklyTotal)}',
            value: _formatNumber(todayTotal),
          ),
          const SizedBox(height: 10),
          _SummaryCard(
            icon: Icons.local_fire_department,
            title: t('stats_streak_title'),
            subtitle: '$streakDays ${t('stats_days')}',
            value: _formatNumber(totalAllTime),
          ),
          const SizedBox(height: 12),
          GlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  t('stats_heatmap_title'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _StatsHeatMap(dailyHistory: dailyHistory),
                const SizedBox(height: 10),
                _LegendRow(
                  t: t,
                  maxValue: dailyHistory.values.fold<int>(0, math.max),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlowCard(
            child: _DistributionSection(t: t, zikrTotals: sortedZikrs),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF24473A), Color(0xFF0F241D)],
              ),
              border: Border.all(
                color: AppPalette.gold.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppPalette.gold, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: dark
                        ? Colors.white.withValues(alpha: 0.76)
                        : AppPalette.primary.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _StatsHeatMap extends StatelessWidget {
  const _StatsHeatMap({required this.dailyHistory});

  final Map<String, int> dailyHistory;

  static const int _columns = 24;
  static const int _rows = 7;
  static const double _cell = 10;
  static const double _gap = 3;
  static const double _rowLabelWidth = 28;
  static const double _monthLabelOffset = 32;

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime startDate = today.subtract(
      const Duration(days: _columns * _rows - 1),
    );
    final int maxDaily = dailyHistory.values.fold<int>(0, math.max);
    final List<String?> monthLabels = _monthMarkers(startDate);

    final double gridWidth = (_columns * _cell) + ((_columns - 1) * _gap);
    final double contentWidth = _monthLabelOffset + gridWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: contentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: _monthLabelOffset),
              child: Row(
                children: List<Widget>.generate(_columns, (int col) {
                  final String? label = monthLabels[col];
                  return SizedBox(
                    width: _cell + _gap,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label ?? '',
                        maxLines: 1,
                        softWrap: false,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),
            Column(
              children: List<Widget>.generate(_rows, (int row) {
                return Padding(
                  padding: EdgeInsets.only(bottom: row == _rows - 1 ? 0 : _gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: _rowLabelWidth,
                        child: Text(
                          _rowLabel(row),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      ...List<Widget>.generate(_columns, (int col) {
                        final DateTime date = startDate.add(
                          Duration(days: col * _rows + row),
                        );
                        final int value =
                            dailyHistory[DayKey.fromDate(date)] ?? 0;

                        return Container(
                          width: _cell,
                          height: _cell,
                          margin: EdgeInsets.only(
                            right: col == _columns - 1 ? 0 : _gap,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: _heatColor(
                              context,
                              value: value,
                              max: maxDaily,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<String?> _monthMarkers(DateTime startDate) {
    final List<String?> labels = List<String?>.filled(_columns, null);
    int prevMonth = -1;

    for (int col = 0; col < _columns; col++) {
      final DateTime date = startDate.add(Duration(days: col * _rows));
      if (col == 0 || date.month != prevMonth) {
        labels[col] = _shortMonth(date.month);
        prevMonth = date.month;
      }
    }

    return labels;
  }

  String _rowLabel(int row) {
    switch (row) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 3:
        return 'Wed';
      case 5:
        return 'Fri';
      default:
        return '';
    }
  }

  String _shortMonth(int month) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Color _heatColor(
    BuildContext context, {
    required int value,
    required int max,
  }) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final double ratio = max == 0 ? 0 : value / max;

    if (ratio <= 0) {
      return dark
          ? Colors.white.withValues(alpha: 0.05)
          : AppPalette.primary.withValues(alpha: 0.08);
    }

    final Color low = AppPalette.primary.withValues(alpha: dark ? 0.45 : 0.35);
    final Color high = AppPalette.accent.withValues(alpha: 0.95);
    final Color base = Color.lerp(low, high, ratio.clamp(0, 1)) ?? high;

    if (ratio > 0.82) {
      return Color.lerp(base, AppPalette.gold.withValues(alpha: 0.88), 0.24) ??
          base;
    }

    return base;
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.t, required this.maxValue});

  final String Function(String key) t;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(t('stats_low'), style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: List<Widget>.generate(12, (int i) {
              final double ratio = i / 11;
              final Color color = maxValue == 0
                  ? Colors.white.withValues(alpha: 0.08)
                  : Color.lerp(
                          AppPalette.primary.withValues(alpha: 0.35),
                          AppPalette.accent,
                          ratio,
                        )?.withValues(alpha: 0.95) ??
                        AppPalette.accent;

              return Expanded(
                child: Container(
                  height: 8,
                  margin: EdgeInsets.only(right: i == 11 ? 0 : 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        Text(t('stats_high'), style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _DistributionSection extends StatelessWidget {
  const _DistributionSection({required this.t, required this.zikrTotals});

  final String Function(String key) t;
  final List<({String label, int value})> zikrTotals;

  static const List<Color> _barColors = <Color>[
    AppPalette.accent,
    Color(0xFF76D66A),
    Color(0xFFA3CB4B),
    Color(0xFF8C7F36),
  ];

  @override
  Widget build(BuildContext context) {
    final int total = zikrTotals.fold<int>(
      0,
      (int sum, row) => sum + row.value,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(Icons.emoji_events_outlined, color: AppPalette.gold),
            const SizedBox(width: 8),
            Text(
              t('stats_distribution'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...zikrTotals.asMap().entries.map((entry) {
          final int index = entry.key;
          final ({String label, int value}) row = entry.value;
          final double percent = total == 0 ? 0 : (row.value / total) * 100;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: _DistributionRow(
              label: row.label,
              percentage: percent,
              color: _barColors[index % _barColors.length],
            ),
          );
        }),
      ],
    );
  }
}

class _DistributionRow extends StatelessWidget {
  const _DistributionRow({
    required this.label,
    required this.percentage,
    required this.color,
  });

  final String label;
  final double percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double ratio = (percentage / 100).clamp(0, 1);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Container(
                  height: 12,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                Container(
                  height: 12,
                  width: constraints.maxWidth * ratio,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[color.withValues(alpha: 0.72), color],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

String _formatNumber(int value) {
  final bool negative = value < 0;
  final String raw = value.abs().toString();
  final StringBuffer out = StringBuffer();

  for (int i = 0; i < raw.length; i++) {
    final int reversedIndex = raw.length - i;
    out.write(raw[i]);
    if (reversedIndex > 1 && reversedIndex % 3 == 1) {
      out.write('.');
    }
  }

  return negative ? '-$out' : '$out';
}
