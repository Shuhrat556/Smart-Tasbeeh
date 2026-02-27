import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/features/tasbeeh/domain/entities/theme_preference.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/glow_card.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.t,
    required this.themePreference,
    required this.localeCode,
    required this.vibrationEnabled,
    required this.soundEnabled,
    required this.dailyReminderEnabled,
    required this.fridayReminderEnabled,
    required this.onThemeChanged,
    required this.onLanguageTap,
    required this.onVibrationChanged,
    required this.onSoundChanged,
    required this.onDailyReminderChanged,
    required this.onFridayReminderChanged,
  });

  final String Function(String key) t;
  final ThemePreference themePreference;
  final String localeCode;
  final bool vibrationEnabled;
  final bool soundEnabled;
  final bool dailyReminderEnabled;
  final bool fridayReminderEnabled;
  final ValueChanged<ThemePreference> onThemeChanged;
  final VoidCallback onLanguageTap;
  final ValueChanged<bool> onVibrationChanged;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<bool> onDailyReminderChanged;
  final ValueChanged<bool> onFridayReminderChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: <Widget>[
          _SectionTitle(title: t('settings_general_section')),
          GlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  t('theme'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  t('settings_theme_subtitle'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                SegmentedButton<ThemePreference>(
                  segments: <ButtonSegment<ThemePreference>>[
                    ButtonSegment<ThemePreference>(
                      value: ThemePreference.system,
                      label: Text(t('theme_system')),
                    ),
                    ButtonSegment<ThemePreference>(
                      value: ThemePreference.light,
                      label: Text(t('theme_light')),
                    ),
                    ButtonSegment<ThemePreference>(
                      value: ThemePreference.dark,
                      label: Text(t('theme_dark')),
                    ),
                  ],
                  selected: <ThemePreference>{themePreference},
                  onSelectionChanged: (Set<ThemePreference> selected) {
                    onThemeChanged(selected.first);
                  },
                ),
                const Divider(height: 26),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: onLanguageTap,
                  leading: const Icon(Icons.language),
                  title: Text(t('language')),
                  subtitle: Text(t('settings_language_subtitle')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _labelByCode(localeCode),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionTitle(title: t('settings_feedback_section')),
          GlowCard(
            child: Column(
              children: <Widget>[
                _SwitchRow(
                  icon: Icons.vibration,
                  title: t('vibration'),
                  subtitle: t('settings_vibration_subtitle'),
                  value: vibrationEnabled,
                  onChanged: onVibrationChanged,
                ),
                const Divider(height: 10),
                _SwitchRow(
                  icon: Icons.volume_up_outlined,
                  title: t('sound'),
                  subtitle: t('settings_sound_subtitle'),
                  value: soundEnabled,
                  onChanged: onSoundChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionTitle(title: t('settings_reminders_section')),
          GlowCard(
            child: Column(
              children: <Widget>[
                _SwitchRow(
                  icon: Icons.notifications_none,
                  title: t('reminder_daily'),
                  subtitle: t('settings_reminder_daily_subtitle'),
                  value: dailyReminderEnabled,
                  onChanged: onDailyReminderChanged,
                ),
                const Divider(height: 10),
                _SwitchRow(
                  icon: Icons.calendar_month_outlined,
                  title: t('reminder_friday'),
                  subtitle: t('settings_reminder_friday_subtitle'),
                  value: fridayReminderEnabled,
                  onChanged: onFridayReminderChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _labelByCode(String code) {
    switch (code) {
      case 'uz':
        return 'Uzbek';
      case 'tj':
        return 'Tojik';
      case 'ru':
        return 'Русский';
      case 'en':
      default:
        return 'English';
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        CupertinoSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}
