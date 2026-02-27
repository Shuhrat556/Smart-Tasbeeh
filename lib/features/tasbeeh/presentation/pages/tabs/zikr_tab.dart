import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/glow_card.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/ring_progress.dart';

class ZikrTab extends StatelessWidget {
  const ZikrTab({
    super.key,
    required this.t,
    required this.items,
    required this.onSelectZikr,
    required this.onEditTarget,
  });

  final String Function(String key) t;
  final List<ZikrItemViewData> items;
  final ValueChanged<String> onSelectZikr;
  final ValueChanged<String> onEditTarget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (BuildContext context, int index) {
          final ZikrItemViewData item = items[index];
          final double progress = item.target <= 0
              ? 0
              : (item.count / item.target).clamp(0, 1).toDouble();

          return GlowCard(
            glow: item.isActive,
            borderColor: item.isActive
                ? AppPalette.accent.withValues(alpha: 0.85)
                : null,
            onTap: () => onSelectZikr(item.id),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if (item.isActive)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.circle,
                                color: AppPalette.accent,
                                size: 10,
                              ),
                            ),
                          Flexible(
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.arabic,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontFamily: 'NotoNaskhArabic',
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => onEditTarget(item.id),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '[ ${item.count} / ${item.target} ]',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                RingProgress(
                  progress: progress,
                  size: 74,
                  strokeWidth: 8,
                  child: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ZikrItemViewData {
  const ZikrItemViewData({
    required this.id,
    required this.label,
    required this.arabic,
    required this.count,
    required this.target,
    required this.isActive,
  });

  final String id;
  final String label;
  final String arabic;
  final int count;
  final int target;
  final bool isActive;
}
