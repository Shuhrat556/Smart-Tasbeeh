import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/glow_card.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/ring_progress.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/tasbeeh_button_3d.dart';

class TasbeehTab extends StatelessWidget {
  const TasbeehTab({
    super.key,
    required this.t,
    required this.activeLabel,
    required this.activeArabic,
    required this.activeCount,
    required this.activeTarget,
    required this.progress,
    required this.canUndo,
    required this.onIncrement,
    required this.onUndo,
    required this.onReset,
    required this.onSelectTarget,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onLongPressCancel,
  });

  final String Function(String key) t;
  final String activeLabel;
  final String activeArabic;
  final int activeCount;
  final int activeTarget;
  final double progress;
  final bool canUndo;
  final VoidCallback onIncrement;
  final VoidCallback onUndo;
  final VoidCallback onReset;
  final VoidCallback onSelectTarget;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressEndCallback? onLongPressEnd;
  final VoidCallback? onLongPressCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GlowCard(
              glow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    t('active_zikr_label'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeLabel,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activeArabic,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'NotoNaskhArabic',
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.flag_circle_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${t('target')}: $activeTarget',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: onSelectTarget,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          t('set_target'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RingProgress(
                progress: progress,
                size: 280,
                strokeWidth: 16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                          '$activeCount',
                          key: ValueKey<int>(activeCount),
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        )
                        .animate(key: ValueKey<int>(activeCount))
                        .scale(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          begin: const Offset(0.84, 0.84),
                          end: const Offset(1, 1),
                        ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% ${t('progress')}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: TasbeehButton3D(
                onTap: onIncrement,
                onLongPressStart: onLongPressStart,
                onLongPressEnd: onLongPressEnd,
                onLongPressCancel: onLongPressCancel,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${t('tap_hint')} · ${t('long_press_hint')}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: canUndo ? onUndo : null,
                    icon: const Icon(Icons.undo),
                    label: Text(t('undo')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.restart_alt),
                    label: Text(t('reset')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
