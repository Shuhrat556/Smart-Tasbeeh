import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/glow_card.dart';

const List<({String code, String label})> _localeOptions =
    <({String code, String label})>[
      (code: 'uz', label: 'Uzbek'),
      (code: 'tj', label: 'Tojik'),
      (code: 'ru', label: 'Русский'),
      (code: 'en', label: 'English'),
    ];

Future<void> showLanguageSheet({
  required BuildContext context,
  required String title,
  required String selectedCode,
  required ValueChanged<String> onSelected,
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
              const SizedBox(height: 12),
              ..._localeOptions.map((locale) {
                final bool selected = locale.code == selectedCode;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlowCard(
                    glow: selected,
                    borderColor: selected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    onTap: () {
                      onSelected(locale.code);
                      Navigator.of(context).pop();
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            locale.label,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (selected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
