# Smart Tasbeeh

Play Market release uchun loyiha Android tomondan tayyorlab qo'yildi.

## Nimalar sozlandi
- Release signing endi `android/key.properties` yoki environment variable orqali olinadi.
- `applicationId` va `namespace` -> `uz.shuhrat.smarttasbeeh`.
- Release build uchun `R8` (`minify` + `shrinkResources`) yoqilgan.
- App label -> `Smart Tasbeeh`.

## 1) Upload keystore yarating
`android/` ichida quyidagi komandani ishga tushiring:

```bash
keytool -genkeypair -v \
  -keystore app/upload-keystore.jks \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

## 2) `key.properties` yarating

```bash
cp android/key.properties.example android/key.properties
```

`android/key.properties` ichidagi `CHANGE_ME` qiymatlarni haqiqiy parollaringiz bilan almashtiring.

## 3) Versionni oshiring
`pubspec.yaml` dagi version formati:

```yaml
version: 1.0.0+1
```

- `1.0.0` -> `versionName`
- `+1` -> `versionCode` (har release'da oshishi shart)

## 4) Release AAB build qiling

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Natija fayli:

`build/app/outputs/bundle/release/app-release.aab`

## 5) Play Console'ga yuklashdan oldingi checklist
- App icon: 512x512
- Feature graphic: 1024x500
- Kamida 2 ta screenshot (phone)
- Privacy policy URL (agar Play Console talab qilsa)
- App content bo'limlarini to'ldirish (Data safety, Ads, Content rating)
