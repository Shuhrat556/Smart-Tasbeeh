import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SmartTasbeehApp());
}

class SmartTasbeehApp extends StatefulWidget {
  const SmartTasbeehApp({super.key});

  @override
  State<SmartTasbeehApp> createState() => _SmartTasbeehAppState();
}

class _SmartTasbeehAppState extends State<SmartTasbeehApp> {
  static const List<String> _zikrIds = <String>[
    'subhanallah',
    'alhamdulillah',
    'allahuakbar',
    'astaghfirullah',
  ];

  static const List<int> _targetOptions = <int>[33, 99, 100, 1000];
  static const Duration _fastCountInterval = Duration(milliseconds: 120);

  static const Map<String, Map<String, String>> _i18n =
      <String, Map<String, String>>{
        'uz': <String, String>{
          'app_title': 'Smart Tasbeeh',
          'tab_tasbeh': 'Tasbeh',
          'tab_zikrlar': 'Zikrlar',
          'tab_qibla': 'Qibla',
          'tab_stats': 'Statistika',
          'tab_settings': 'Sozlamalar',
          'current_zikr': 'Joriy zikr',
          'count': 'Sanoq',
          'target': 'Maqsad',
          'set_target': 'Maqsadni tanlang',
          'progress': 'Progress',
          'tap_hint': 'Bosish: +1',
          'long_press_hint': 'Uzoq bosish: tez sanash',
          'undo': 'Undo (-1)',
          'reset': 'Reset',
          'save_session': 'Sessiyani saqlash',
          'session_saved': 'Sessiya saqlandi',
          'session_auto_saved': 'Sessiya avtomatik saqlanadi',
          'reset_confirm_title': 'Sanoqni tiklash?',
          'reset_confirm_body': "Joriy zikr sanog'i 0 ga tushiriladi.",
          'cancel': 'Bekor qilish',
          'confirm': 'Tasdiqlash',
          'goal_reached_title': 'Maqsad bajarildi',
          'goal_reached_body': 'Tabriklaymiz! Maqsadga yetdingiz.',
          'stats_today': 'Bugun',
          'stats_week': 'Haftalik (7 kun)',
          'stats_month': 'Oylik (30 kun)',
          'most_used': "Eng ko'p ishlatilgan zikr",
          'no_data': "Ma'lumot yo'q",
          'theme': 'Mavzu',
          'theme_system': "Tizim bo'yicha",
          'theme_light': 'Kunduzgi',
          'theme_dark': 'Tungi',
          'language': 'Til',
          'choose_lang': 'Tilni tanlang',
          'vibration': 'Vibratsiya',
          'sound': 'Ovoz',
          'reminder_daily': 'Kunlik eslatma',
          'reminder_friday': 'Juma eslatmasi',
          'qibla_title': "Qibla yo'nalishi",
          'qibla_desc':
              "Kompas va joylashuv asosidagi Qibla funksiyasi uchun sensor va joylashuv integratsiyasi kerak.",
          'qibla_placeholder': 'Qibla moduli integratsiyaga tayyor.',
          'prayer_times': 'Namoz vaqtlari',
          'nearby_mosques': 'Yaqin masjidlar',
          'coming_soon': 'Tez orada',
          'mini_duas': 'Mini duolar',
          'dua_of_day': 'Kun duosi',
          'before_sleep': 'Uyqudan oldin zikr',
          'after_prayer': 'Namozdan keyingi zikr',
          'active': 'Faol',
          'zikr_subhanallah': 'Subhanalloh',
          'zikr_alhamdulillah': 'Alhamdulillah',
          'zikr_allahuakbar': 'Allohu Akbar',
          'zikr_astaghfirullah': "Astag'firulloh",
        },
        'tj': <String, String>{
          'app_title': 'Smart Tasbeeh',
          'tab_tasbeh': 'Тасбеҳ',
          'tab_zikrlar': 'Зикрҳо',
          'tab_qibla': 'Қибла',
          'tab_stats': 'Омор',
          'tab_settings': 'Танзимот',
          'current_zikr': 'Зикри ҷорӣ',
          'count': 'Шумора',
          'target': 'Ҳадаф',
          'set_target': 'Ҳадафро интихоб кунед',
          'progress': 'Пешрафт',
          'tap_hint': 'Ламс: +1',
          'long_press_hint': 'Пахши дароз: ҳисоби тез',
          'undo': 'Бозгашт (-1)',
          'reset': 'Аз нав',
          'save_session': 'Нигоҳдории сессия',
          'session_saved': 'Сессия нигоҳ дошта шуд',
          'session_auto_saved': 'Сессия худкор нигоҳ дошта мешавад',
          'reset_confirm_title': 'Шумора аз нав шавад?',
          'reset_confirm_body': 'Шумораи зикри ҷорӣ ба 0 мефарояд.',
          'cancel': 'Бекор',
          'confirm': 'Тасдиқ',
          'goal_reached_title': 'Ҳадаф иҷро шуд',
          'goal_reached_body': 'Табрик! Шумо ба ҳадаф расидед.',
          'stats_today': 'Имрӯз',
          'stats_week': 'Ҳафта (7 рӯз)',
          'stats_month': 'Моҳ (30 рӯз)',
          'most_used': 'Зикри бештар истифодашуда',
          'no_data': 'Маълумот нест',
          'theme': 'Намуд',
          'theme_system': 'Мувофиқи система',
          'theme_light': 'Равшан',
          'theme_dark': 'Торик',
          'language': 'Забон',
          'choose_lang': 'Забонро интихоб кунед',
          'vibration': 'Вибратсия',
          'sound': 'Овоз',
          'reminder_daily': 'Ёдрасии рӯзона',
          'reminder_friday': 'Ёдрасии ҷумъа',
          'qibla_title': 'Самти Қибла',
          'qibla_desc':
              'Барои самти Қибла ҳамгироии қутбнамо ва ҷойгиршавӣ лозим аст.',
          'qibla_placeholder': 'Модули Қибла барои ҳамгироӣ омода аст.',
          'prayer_times': 'Вақтҳои намоз',
          'nearby_mosques': 'Масҷидҳои наздик',
          'coming_soon': 'Ба наздикӣ',
          'mini_duas': 'Дуоҳои хурд',
          'dua_of_day': 'Дуои рӯз',
          'before_sleep': 'Зикр пеш аз хоб',
          'after_prayer': 'Зикр баъди намоз',
          'active': 'Фаъол',
          'zikr_subhanallah': 'Субҳоналлоҳ',
          'zikr_alhamdulillah': 'Алҳамдулиллоҳ',
          'zikr_allahuakbar': 'Аллоҳу Акбар',
          'zikr_astaghfirullah': 'Астағфируллоҳ',
        },
        'ru': <String, String>{
          'app_title': 'Smart Tasbeeh',
          'tab_tasbeh': 'Тасбих',
          'tab_zikrlar': 'Зикры',
          'tab_qibla': 'Кибла',
          'tab_stats': 'Статистика',
          'tab_settings': 'Настройки',
          'current_zikr': 'Текущий зикр',
          'count': 'Счет',
          'target': 'Цель',
          'set_target': 'Выберите цель',
          'progress': 'Прогресс',
          'tap_hint': 'Нажатие: +1',
          'long_press_hint': 'Долгое нажатие: быстрый счет',
          'undo': 'Отмена (-1)',
          'reset': 'Сброс',
          'save_session': 'Сохранить сессию',
          'session_saved': 'Сессия сохранена',
          'session_auto_saved': 'Сессия сохраняется автоматически',
          'reset_confirm_title': 'Сбросить счет?',
          'reset_confirm_body': 'Счет текущего зикра будет обнулен.',
          'cancel': 'Отмена',
          'confirm': 'Подтвердить',
          'goal_reached_title': 'Цель достигнута',
          'goal_reached_body': 'Поздравляем! Цель выполнена.',
          'stats_today': 'Сегодня',
          'stats_week': 'Неделя (7 дней)',
          'stats_month': 'Месяц (30 дней)',
          'most_used': 'Самый используемый зикр',
          'no_data': 'Нет данных',
          'theme': 'Тема',
          'theme_system': 'Системная',
          'theme_light': 'Светлая',
          'theme_dark': 'Темная',
          'language': 'Язык',
          'choose_lang': 'Выберите язык',
          'vibration': 'Вибрация',
          'sound': 'Звук',
          'reminder_daily': 'Ежедневное напоминание',
          'reminder_friday': 'Напоминание в пятницу',
          'qibla_title': 'Направление Киблы',
          'qibla_desc':
              'Для определения Киблы нужна интеграция компаса и геолокации.',
          'qibla_placeholder': 'Модуль Киблы готов к интеграции.',
          'prayer_times': 'Времена намаза',
          'nearby_mosques': 'Ближайшие мечети',
          'coming_soon': 'Скоро',
          'mini_duas': 'Мини-дуа',
          'dua_of_day': 'Дуа дня',
          'before_sleep': 'Зикр перед сном',
          'after_prayer': 'Зикр после намаза',
          'active': 'Активно',
          'zikr_subhanallah': 'Субханаллах',
          'zikr_alhamdulillah': 'Альхамдулиллях',
          'zikr_allahuakbar': 'Аллаху Акбар',
          'zikr_astaghfirullah': 'Астагфируллах',
        },
        'en': <String, String>{
          'app_title': 'Smart Tasbeeh',
          'tab_tasbeh': 'Tasbeeh',
          'tab_zikrlar': 'Zikrs',
          'tab_qibla': 'Qibla',
          'tab_stats': 'Statistics',
          'tab_settings': 'Settings',
          'current_zikr': 'Current zikr',
          'count': 'Count',
          'target': 'Target',
          'set_target': 'Select target',
          'progress': 'Progress',
          'tap_hint': 'Tap: +1',
          'long_press_hint': 'Long press: fast counting',
          'undo': 'Undo (-1)',
          'reset': 'Reset',
          'save_session': 'Save session',
          'session_saved': 'Session saved',
          'session_auto_saved': 'Session auto-save is enabled',
          'reset_confirm_title': 'Reset counter?',
          'reset_confirm_body': 'Current zikr counter will be set to 0.',
          'cancel': 'Cancel',
          'confirm': 'Confirm',
          'goal_reached_title': 'Target reached',
          'goal_reached_body': 'Congratulations! You reached your target.',
          'stats_today': 'Today',
          'stats_week': 'Weekly (7 days)',
          'stats_month': 'Monthly (30 days)',
          'most_used': 'Most used zikr',
          'no_data': 'No data',
          'theme': 'Theme',
          'theme_system': 'System',
          'theme_light': 'Light',
          'theme_dark': 'Dark',
          'language': 'Language',
          'choose_lang': 'Choose language',
          'vibration': 'Vibration',
          'sound': 'Sound',
          'reminder_daily': 'Daily reminder',
          'reminder_friday': 'Friday reminder',
          'qibla_title': 'Qibla Direction',
          'qibla_desc':
              'Compass and geolocation integration is needed for live Qibla direction.',
          'qibla_placeholder': 'Qibla module is ready for integration.',
          'prayer_times': 'Prayer times',
          'nearby_mosques': 'Nearby mosques',
          'coming_soon': 'Coming soon',
          'mini_duas': 'Mini duas',
          'dua_of_day': 'Dua of the day',
          'before_sleep': 'Before sleep zikr',
          'after_prayer': 'After prayer zikr',
          'active': 'Active',
          'zikr_subhanallah': 'Subhanallah',
          'zikr_alhamdulillah': 'Alhamdulillah',
          'zikr_allahuakbar': 'Allahu Akbar',
          'zikr_astaghfirullah': 'Astaghfirullah',
        },
      };

  int _selectedTab = 0;
  Locale _locale = const Locale('uz');
  ThemeMode _themeMode = ThemeMode.system;
  String _activeZikrId = _zikrIds.first;

  Map<String, int> _counts = <String, int>{};
  Map<String, int> _targets = <String, int>{};
  Map<String, int> _dailyHistory = <String, int>{};
  Map<String, bool> _goalReached = <String, bool>{};

  bool _vibrationEnabled = true;
  bool _soundEnabled = false;
  bool _dailyReminderEnabled = false;
  bool _fridayReminderEnabled = false;

  _UndoAction? _undoAction;
  Timer? _fastCountTimer;
  Timer? _saveDebounce;

  @override
  void initState() {
    super.initState();
    _setDefaults();
    _loadState();
  }

  @override
  void dispose() {
    _fastCountTimer?.cancel();
    _saveDebounce?.cancel();
    super.dispose();
  }

  void _setDefaults() {
    _counts = <String, int>{for (final String id in _zikrIds) id: 0};
    _targets = <String, int>{for (final String id in _zikrIds) id: 33};
    _goalReached = <String, bool>{for (final String id in _zikrIds) id: false};
  }

  String _t(String key) {
    final String code = _locale.languageCode;
    return _i18n[code]?[key] ?? _i18n['en']?[key] ?? key;
  }

  String _zikrLabel(String id) => _t('zikr_$id');

  Future<void> _loadState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String localeCode = prefs.getString('locale') ?? 'uz';
    final int themeModeIndex = prefs.getInt('theme_mode') ?? 0;

    final Map<String, int> loadedCounts = _decodeIntMap(
      prefs.getString('counts'),
      fallback: _counts,
    );
    final Map<String, int> loadedTargets = _decodeIntMap(
      prefs.getString('targets'),
      fallback: _targets,
    );
    final Map<String, int> loadedHistory = _decodeIntMap(
      prefs.getString('daily_history'),
      fallback: <String, int>{},
    );
    final String selectedZikr = prefs.getString('active_zikr') ?? _zikrIds.first;

    setState(() {
      _locale = Locale(localeCode);
      _themeMode = ThemeMode.values[themeModeIndex.clamp(0, 2)];
      _counts = _withRequiredKeys(loadedCounts, defaultValue: 0);
      _targets = _withRequiredKeys(loadedTargets, defaultValue: 33);
      _dailyHistory = loadedHistory;
      _activeZikrId = _zikrIds.contains(selectedZikr) ? selectedZikr : _zikrIds.first;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? false;
      _dailyReminderEnabled = prefs.getBool('daily_reminder') ?? false;
      _fridayReminderEnabled = prefs.getBool('friday_reminder') ?? false;
      _goalReached = <String, bool>{
        for (final String id in _zikrIds)
          id: (_counts[id] ?? 0) >= (_targets[id] ?? 33),
      };
    });
  }

  Map<String, int> _withRequiredKeys(Map<String, int> source, {required int defaultValue}) {
    return <String, int>{
      for (final String id in _zikrIds) id: source[id] ?? defaultValue,
    };
  }

  Map<String, int> _decodeIntMap(String? raw, {required Map<String, int> fallback}) {
    if (raw == null || raw.isEmpty) {
      return Map<String, int>.from(fallback);
    }
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded.map<String, int>(
          (String key, dynamic value) => MapEntry<String, int>(
            key,
            (value as num).toInt(),
          ),
        );
      }
    } catch (_) {
      return Map<String, int>.from(fallback);
    }
    return Map<String, int>.from(fallback);
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 250), _saveNow);
  }

  Future<void> _saveNow() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.wait(<Future<bool>>[
      prefs.setString('locale', _locale.languageCode),
      prefs.setInt('theme_mode', _themeMode.index),
      prefs.setString('active_zikr', _activeZikrId),
      prefs.setString('counts', jsonEncode(_counts)),
      prefs.setString('targets', jsonEncode(_targets)),
      prefs.setString('daily_history', jsonEncode(_dailyHistory)),
      prefs.setBool('vibration_enabled', _vibrationEnabled),
      prefs.setBool('sound_enabled', _soundEnabled),
      prefs.setBool('daily_reminder', _dailyReminderEnabled),
      prefs.setBool('friday_reminder', _fridayReminderEnabled),
    ]);
  }

  String _dayKey(DateTime date) {
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  int _sumLastDays(int days) {
    int total = 0;
    final DateTime now = DateTime.now();
    for (int i = 0; i < days; i++) {
      final String key = _dayKey(now.subtract(Duration(days: i)));
      total += _dailyHistory[key] ?? 0;
    }
    return total;
  }

  String? _mostUsedZikr() {
    String? id;
    int max = 0;
    for (final String zikrId in _zikrIds) {
      final int value = _counts[zikrId] ?? 0;
      if (value > max) {
        max = value;
        id = zikrId;
      }
    }
    return max > 0 ? id : null;
  }

  void _incrementCount({bool auto = false}) {
    final String todayKey = _dayKey(DateTime.now());
    final String currentId = _activeZikrId;
    final int currentValue = _counts[currentId] ?? 0;
    final int target = _targets[currentId] ?? 33;
    final int nextValue = currentValue + 1;
    final bool reachedNow = target > 0 && currentValue < target && nextValue >= target;

    setState(() {
      _counts[currentId] = nextValue;
      _dailyHistory[todayKey] = (_dailyHistory[todayKey] ?? 0) + 1;
      _undoAction = _UndoAction(currentId, 1);
      if (reachedNow) {
        _goalReached[currentId] = true;
      }
    });

    if (!auto && _vibrationEnabled) {
      HapticFeedback.selectionClick();
    }
    if (!auto && _soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    if (reachedNow) {
      _showGoalReachedDialog();
    }
    _scheduleSave();
  }

  void _startFastCount(LongPressStartDetails _) {
    _fastCountTimer?.cancel();
    _fastCountTimer = Timer.periodic(_fastCountInterval, (_) {
      _incrementCount(auto: true);
    });
  }

  void _stopFastCount() {
    _fastCountTimer?.cancel();
    _fastCountTimer = null;
  }

  void _undo() {
    final _UndoAction? action = _undoAction;
    if (action == null) {
      return;
    }
    final String todayKey = _dayKey(DateTime.now());
    setState(() {
      final int current = _counts[action.zikrId] ?? 0;
      final int nextValue = (current - action.step).clamp(0, 1 << 31);
      _counts[action.zikrId] = nextValue;

      final int today = _dailyHistory[todayKey] ?? 0;
      _dailyHistory[todayKey] = (today - action.step).clamp(0, 1 << 31);

      final int target = _targets[action.zikrId] ?? 33;
      if (nextValue < target) {
        _goalReached[action.zikrId] = false;
      }
      _undoAction = null;
    });
    _scheduleSave();
  }

  Future<void> _resetCurrentCounter() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_t('reset_confirm_title')),
          content: Text(_t('reset_confirm_body')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(_t('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(_t('confirm')),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    setState(() {
      _counts[_activeZikrId] = 0;
      _goalReached[_activeZikrId] = false;
      _undoAction = null;
    });
    _scheduleSave();
  }

  Future<void> _showGoalReachedDialog() async {
    if (_vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_t('goal_reached_title')),
          content: Text(_t('goal_reached_body')),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_t('confirm')),
            ),
          ],
        );
      },
    );
  }

  void _setTarget(String zikrId, int value) {
    setState(() {
      _targets[zikrId] = value;
      final int count = _counts[zikrId] ?? 0;
      _goalReached[zikrId] = count >= value;
    });
    _scheduleSave();
  }

  void _setLanguage(String code) {
    setState(() {
      _locale = Locale(code);
    });
    _scheduleSave();
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _scheduleSave();
  }

  Future<void> _manualSaveSession() async {
    await _saveNow();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_t('session_saved'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int activeCount = _counts[_activeZikrId] ?? 0;
    final int activeTarget = _targets[_activeZikrId] ?? 33;
    final double progress = activeTarget <= 0
        ? 0
        : (activeCount / activeTarget).clamp(0, 1).toDouble();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _t('app_title'),
      locale: _locale,
      supportedLocales: const <Locale>[
        Locale('uz'),
        Locale('tj'),
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1F8A70),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1F8A70),
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_t('app_title')),
        ),
        body: IndexedStack(
          index: _selectedTab,
          children: <Widget>[
            _buildTasbehTab(activeCount, activeTarget, progress),
            _buildZikrTab(),
            _buildQiblaTab(),
            _buildStatsTab(),
            _buildSettingsTab(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedTab,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.touch_app_outlined),
              selectedIcon: const Icon(Icons.touch_app),
              label: _t('tab_tasbeh'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.list_alt_outlined),
              selectedIcon: const Icon(Icons.list_alt),
              label: _t('tab_zikrlar'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore),
              label: _t('tab_qibla'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: _t('tab_stats'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: _t('tab_settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasbehTab(int activeCount, int activeTarget, double progress) {
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
                      '${_t('current_zikr')}: ${_zikrLabel(_activeZikrId)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_t('count')}: $activeCount',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('${_t('target')}: $activeTarget'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 4),
                    Text('${(progress * 100).toStringAsFixed(0)}% ${_t('progress')}'),
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
                    Text(_t('set_target')),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _targetOptions.map((int value) {
                        return ChoiceChip(
                          label: Text('$value'),
                          selected: activeTarget == value,
                          onSelected: (_) => _setTarget(_activeZikrId, value),
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
                onTap: _incrementCount,
                onLongPressStart: _startFastCount,
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
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(_t('tap_hint')),
                      Text(_t('long_press_hint')),
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
                  onPressed: _undoAction == null ? null : _undo,
                  icon: const Icon(Icons.undo),
                  label: Text(_t('undo')),
                ),
                OutlinedButton.icon(
                  onPressed: _resetCurrentCounter,
                  icon: const Icon(Icons.restart_alt),
                  label: Text(_t('reset')),
                ),
                TextButton.icon(
                  onPressed: _manualSaveSession,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_t('save_session')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _t('session_auto_saved'),
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
                      _t('mini_duas'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.wb_sunny_outlined),
                      title: Text(_t('dua_of_day')),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.bedtime_outlined),
                      title: Text(_t('before_sleep')),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.mosque_outlined),
                      title: Text(_t('after_prayer')),
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

  Widget _buildZikrTab() {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _zikrIds.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final String id = _zikrIds[index];
          final int count = _counts[id] ?? 0;
          final int target = _targets[id] ?? 33;
          final bool isActive = _activeZikrId == id;
          return Card(
            child: ListTile(
              onTap: () {
                setState(() {
                  _activeZikrId = id;
                  _selectedTab = 0;
                });
                _scheduleSave();
              },
              title: Text(_zikrLabel(id)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: <Widget>[
                    Text('${_t('count')}: $count'),
                    const SizedBox(width: 16),
                    Text('${_t('target')}:'),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: target,
                      items: _targetOptions.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        if (value != null) {
                          _setTarget(id, value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              trailing: isActive
                  ? Chip(
                      avatar: const Icon(Icons.check, size: 16),
                      label: Text(_t('active')),
                    )
                  : const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQiblaTab() {
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
                        _t('qibla_title'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_t('qibla_desc')),
                  const SizedBox(height: 8),
                  Text(
                    _t('qibla_placeholder'),
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
              title: Text(_t('prayer_times')),
              subtitle: Text(_t('coming_soon')),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(_t('nearby_mosques')),
              subtitle: Text(_t('coming_soon')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    final int today = _dailyHistory[_dayKey(DateTime.now())] ?? 0;
    final int week = _sumLastDays(7);
    final int month = _sumLastDays(30);
    final String? mostUsedId = _mostUsedZikr();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _statCard(_t('stats_today'), today),
          const SizedBox(height: 8),
          _statCard(_t('stats_week'), week),
          const SizedBox(height: 8),
          _statCard(_t('stats_month'), month),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: Text(_t('most_used')),
              subtitle: Text(
                mostUsedId == null ? _t('no_data') : _zikrLabel(mostUsedId),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _zikrIds.map((String id) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_zikrLabel(id)),
                        Text('${_counts[id] ?? 0}'),
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

  Widget _statCard(String label, int value) {
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

  Widget _buildSettingsTab() {
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
                    _t('theme'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<ThemeMode>(
                    segments: <ButtonSegment<ThemeMode>>[
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        label: Text(_t('theme_system')),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        label: Text(_t('theme_light')),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        label: Text(_t('theme_dark')),
                      ),
                    ],
                    selected: <ThemeMode>{_themeMode},
                    onSelectionChanged: (Set<ThemeMode> values) {
                      _setThemeMode(values.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(_t('choose_lang')),
              subtitle: Text(_t('language')),
              trailing: DropdownButton<String>(
                value: _locale.languageCode,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(value: 'uz', child: Text('Uzbek')),
                  DropdownMenuItem<String>(value: 'tj', child: Text('Tojik')),
                  DropdownMenuItem<String>(value: 'ru', child: Text('Русский')),
                  DropdownMenuItem<String>(value: 'en', child: Text('English')),
                ],
                onChanged: (String? code) {
                  if (code != null) {
                    _setLanguage(code);
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
                  value: _vibrationEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                    _scheduleSave();
                  },
                  title: Text(_t('vibration')),
                ),
                SwitchListTile(
                  value: _soundEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                    _scheduleSave();
                  },
                  title: Text(_t('sound')),
                ),
                SwitchListTile(
                  value: _dailyReminderEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _dailyReminderEnabled = value;
                    });
                    _scheduleSave();
                  },
                  title: Text(_t('reminder_daily')),
                ),
                SwitchListTile(
                  value: _fridayReminderEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _fridayReminderEnabled = value;
                    });
                    _scheduleSave();
                  },
                  title: Text(_t('reminder_friday')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UndoAction {
  const _UndoAction(this.zikrId, this.step);
  final String zikrId;
  final int step;
}
