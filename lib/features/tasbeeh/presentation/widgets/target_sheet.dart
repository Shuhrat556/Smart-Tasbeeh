import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/constants/app_constants.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/glow_card.dart';

Future<void> showTargetSheet({
  required BuildContext context,
  required String title,
  required String subtitle,
  required int selected,
  required ValueChanged<int> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppConstants.targetOptions.map((int value) {
                  final bool isSelected = selected == value;
                  return GlowCard(
                    glow: isSelected,
                    borderColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    onTap: () {
                      onSelected(value);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '$value',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
