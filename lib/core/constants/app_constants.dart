class AppConstants {
  const AppConstants._();

  static const List<ZikrMeta> zikrs = <ZikrMeta>[
    ZikrMeta(
      id: 'subhanallah',
      labelKey: 'zikr_subhanallah',
      arabicText: 'سُبْحَانَ ٱللَّٰهِ',
    ),
    ZikrMeta(
      id: 'alhamdulillah',
      labelKey: 'zikr_alhamdulillah',
      arabicText: 'ٱلْحَمْدُ لِلَّٰهِ',
    ),
    ZikrMeta(
      id: 'allahuakbar',
      labelKey: 'zikr_allahuakbar',
      arabicText: 'ٱللَّٰهُ أَكْبَرُ',
    ),
    ZikrMeta(
      id: 'astaghfirullah',
      labelKey: 'zikr_astaghfirullah',
      arabicText: 'أَسْتَغْفِرُ ٱللَّٰهَ',
    ),
  ];

  static final List<String> zikrIds = zikrs
      .map((ZikrMeta zikr) => zikr.id)
      .toList(growable: false);

  static const List<int> targetOptions = <int>[33, 99, 100, 1000];

  static const int qiblaDemoDirection = 245;
  static const int qiblaDemoDistanceKm = 4231;

  static const String hiveBoxName = 'tasbeeh_box';
  static const String hiveSessionKey = 'session_json';
}

class ZikrMeta {
  const ZikrMeta({
    required this.id,
    required this.labelKey,
    required this.arabicText,
  });

  final String id;
  final String labelKey;
  final String arabicText;
}
