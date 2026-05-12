

Mockup dan UI/UX aku (kayak gini) = https://stitch.withgoogle.com/projects/7528417558586678709?pli=1

````markdown id="3ngy5n"
# Cursor AI Prompt: Build Flutter Wellness App UI + App Structure

Kamu adalah Senior Flutter Developer dan UI/UX Engineer.

Saya sedang membuat aplikasi Flutter bernama **Wellness App**. Project Flutter sudah ada. Tolong bantu saya membangun aplikasi ini secara langsung di project Flutter saya.

Fokus utama sekarang adalah:

1. Membuat UI/UX Flutter yang modern, clean, dan cocok untuk wellness/medical app.
2. Membuat struktur folder yang rapi.
3. Membuat halaman utama aplikasi.
4. Membuat flow aplikasi dari Home → Instruction → Foot Selection → Recording → Processing → Result.
5. Menyiapkan service placeholder untuk sensor, backend API, preprocessing, dan model integration.
6. Jangan membuat model machine learning dari awal. Model sudah diasumsikan tersedia dan nanti akan diintegrasikan.

Aplikasi ini adalah **Wellness App untuk gait analysis** menggunakan sensor HP. User akan meletakkan HP secara bergantian di kaki kanan dan kiri, merekam data accelerometer dan gyroscope, lalu aplikasi menampilkan hasil prediksi FMA-LE, gait events, dan semiogram.

---

# 1. Project Overview

Nama aplikasi:

```text
Wellness App
````

Tujuan aplikasi:

```text
Aplikasi mobile untuk analisis pola berjalan menggunakan sensor smartphone.
```

Fitur utama:

1. Prediksi keparahan FMA-LE.
2. Prediksi gait event:

   * Heel Strike
   * Toe Off
3. Perhitungan semiogram parameters.
4. Menampilkan hasil klasifikasi seperti Healthy atau CVA.
5. Menyimpan riwayat hasil tes.

Catatan penting:

* Model machine learning sudah tersedia.
* Fokus pekerjaan adalah UI, app structure, integration-ready service, dan pipeline.
* Jangan training model.
* Siapkan placeholder untuk `.tflite` model.
* Buat kode modular dan mudah dikembangkan.

---

# 2. Design Direction

Buat UI dengan style:

* Clean
* Modern
* Calm
* Medical
* Wellness
* Minimalist
* Friendly untuk pasien
* Flutter-ready
* Banyak whitespace
* Rounded cards
* Soft shadow
* Simple icon
* Easy to understand

Gunakan warna berikut:

```dart
class AppColors {
  static const primary = Color(0xFF2EC4B6);
  static const secondary = Color(0xFF1D3557);
  static const background = Color(0xFFF7F9FA);
  static const card = Color(0xFFFFFFFF);
  static const accent = Color(0xFFCBF3F0);
  static const success = Color(0xFF43AA8B);
  static const warning = Color(0xFFFF9F1C);
  static const danger = Color(0xFFE63946);
  static const mutedText = Color(0xFF6C757D);
  static const border = Color(0xFFE9ECEF);
}
```

Gunakan font style modern. Kalau belum ada font custom, pakai default Flutter dulu. Tapi siapkan theme dengan fontFamily `Poppins`.

---

# 3. Required Flutter Dependencies

Tolong update `pubspec.yaml` dengan dependencies berikut jika belum ada:

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  sensors_plus: ^6.0.0
  http: ^1.2.2
  provider: ^6.1.2
  fl_chart: ^0.69.0
  tflite_flutter: ^0.11.0
  uuid: ^4.5.1
  intl: ^0.19.0
```

Tambahkan juga asset model placeholder:

```yaml
flutter:
  assets:
    - assets/models/
```

Buat folder:

```text
assets/models/
```

Isi nanti:

```text
assets/models/fma_le_model.tflite
assets/models/gait_event_model.tflite
```

Kalau file model belum ada, jangan error. Cukup siapkan path dan service placeholder.

---

# 4. Folder Structure

Tolong refactor / buat struktur folder seperti ini:

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text.dart
│   │   └── app_routes.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── sensor_utils.dart
│       └── dummy_data.dart
├── data/
│   ├── models/
│   │   ├── sensor_data.dart
│   │   ├── gait_result.dart
│   │   ├── semiogram_result.dart
│   │   └── gait_session.dart
│   └── services/
│       ├── sensor_service.dart
│       ├── api_service.dart
│       ├── tflite_service.dart
│       └── local_storage_service.dart
├── presentation/
│   ├── pages/
│   │   ├── splash_page.dart
│   │   ├── onboarding_page.dart
│   │   ├── home_page.dart
│   │   ├── instruction_page.dart
│   │   ├── foot_selection_page.dart
│   │   ├── recording_page.dart
│   │   ├── processing_page.dart
│   │   ├── result_page.dart
│   │   ├── semiogram_detail_page.dart
│   │   ├── history_page.dart
│   │   └── profile_page.dart
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   ├── app_header.dart
│   │   ├── bottom_nav_shell.dart
│   │   ├── foot_selection_card.dart
│   │   ├── instruction_card.dart
│   │   ├── result_metric_card.dart
│   │   ├── sensor_status_card.dart
│   │   ├── semiogram_chart.dart
│   │   ├── session_history_card.dart
│   │   └── processing_step_tile.dart
│   └── providers/
│       ├── recording_provider.dart
│       └── session_provider.dart
└── routes/
    └── route_generator.dart
```

---

# 5. App Flow

Buat navigasi aplikasi seperti ini:

```text
Splash Page
  ↓
Onboarding Page
  ↓
Home Page
  ↓
Instruction Page
  ↓
Foot Selection Page
  ↓
Recording Page
  ↓
Processing Page
  ↓
Result Page
  ↓
Semiogram Detail Page
```

Tambahkan juga bottom navigation untuk:

```text
Home
Record
History
Profile
```

Untuk sekarang, boleh gunakan `Navigator.pushNamed` sederhana. Jangan terlalu kompleks.

---

# 6. Pages Requirement

## 6.1 Splash Page

Buat Splash Page dengan:

* Background soft gradient.
* Logo icon sederhana menggunakan Flutter icon:

  * `Icons.directions_walk_rounded`
  * atau kombinasi walking + favorite.
* Text:

  ```text
  Wellness App
  Smart gait assessment from your smartphone
  ```

Setelah 2 detik, arahkan ke Onboarding Page.

---

## 6.2 Onboarding Page

Buat onboarding sederhana dengan 3 konten:

Slide 1:

```text
Analyze Your Walking Pattern
Use your smartphone sensors to understand your gait quality.
```

Slide 2:

```text
Record Right and Left Foot
Place your phone alternately on each foot and follow the walking test.
```

Slide 3:

```text
Get Smart Gait Insights
View FMA-LE prediction, gait events, and semiogram results.
```

Komponen:

* Icon/illustration sederhana.
* Title.
* Description.
* Page indicator.
* Button:

  ```text
  Get Started
  ```
* Text button:

  ```text
  Skip
  ```

Arahkan ke Home Page.

---

## 6.3 Home Page

Buat Home Page dengan layout:

Top:

```text
Hello, welcome back
Ready for your gait assessment?
```

Hero card:

```text
Start a new gait test
Record your walking data using your phone sensors.
```

Button:

```text
Start Test
```

Arahkan ke Instruction Page.

Quick stats card:

```text
FMA-LE
24
Moderate

Classification
CVA
91% confidence

Sessions
12
Completed tests
```

Tambahkan bottom navigation.

---

## 6.4 Instruction Page

Buat halaman instruksi sebelum tes.

Title:

```text
Before You Start
```

Subtitle:

```text
Follow these steps for a safe and accurate gait assessment.
```

Instruction cards:

1. Attach Your Phone
   Secure your smartphone on the selected foot.

2. Walk Naturally
   Walk at a comfortable speed during the recording.

3. Record Both Feet
   Complete recording for right and left foot.

4. Stay Safe
   Make sure the walking area is clear and safe.

Button:

```text
Continue
```

Arahkan ke Foot Selection Page.

---

## 6.5 Foot Selection Page

Buat halaman pilih kaki.

Title:

```text
Select Foot Side
```

Subtitle:

```text
Choose which foot you want to record first.
```

Dua card besar:

1. Right Foot
   Place the phone securely on your right foot.

2. Left Foot
   Place the phone securely on your left foot.

Selected state:

* Border warna primary.
* Background accent mint.
* Check icon.

Button:

```text
Continue to Recording
```

Simpan selectedFootSide ke provider/state, lalu arahkan ke Recording Page.

---

## 6.6 Recording Page

Buat halaman recording sensor.

Title dinamis:

```text
Recording: Right Foot
```

atau:

```text
Recording: Left Foot
```

Subtitle:

```text
Keep walking naturally until the timer ends.
```

Komponen utama:

* Timer besar:

  ```text
  00:30
  ```
* Progress ring sederhana atau progress bar.
* Sensor status cards:

  * Accelerometer: Active
  * Gyroscope: Active
  * Sampling Rate: Stable
* Live Sensor Signal card.

  * Untuk sekarang gunakan placeholder mini chart dari `fl_chart`.
* Tombol besar:

  * Start
  * Stop
  * Process Data

Behavior:

* Saat Start ditekan:

  * Timer mulai.
  * Simulasi recording aktif.
  * SensorService mulai listen accelerometer dan gyroscope.
* Saat Stop ditekan:

  * Recording berhenti.
* Saat Process Data ditekan:

  * Arahkan ke Processing Page.

Kalau integrasi sensor asli terlalu panjang, buat dulu versi provider-ready dan dummy fallback. Tapi tetap buat service `SensorService` dengan struktur siap dipakai `sensors_plus`.

---

## 6.7 Processing Page

Buat halaman processing.

Title:

```text
Processing Your Gait Data
```

Subtitle:

```text
Please wait while we analyze your walking pattern.
```

Tampilkan progress stepper:

1. Validating sensor data
2. Calculating FreeAcc
3. Detecting gait events
4. Calculating semiogram
5. Predicting FMA-LE
6. Saving result

Buat simulasi proses selama beberapa detik. Setiap step berubah dari pending → active → completed.

Setelah selesai, arahkan ke Result Page dengan dummy result.

---

## 6.8 Result Page

Buat halaman hasil.

Header:

```text
Gait Analysis Result
Session completed successfully
```

Main result card:

```text
FMA-LE Score
24
Moderate
91% confidence
```

Classification card:

```text
Classification
CVA
```

Gait event card:

```text
Heel Strike
32 events

Toe Off
31 events
```

Semiogram summary:

* Average Speed
* Stability
* Symmetry
* Smoothness

Gunakan chart sederhana dengan `fl_chart`.

Buttons:

```text
View Semiogram Details
Save Result
New Test
```

`View Semiogram Details` arahkan ke Semiogram Detail Page.

`New Test` kembali ke Instruction Page.

---

## 6.9 Semiogram Detail Page

Buat halaman detail semiogram.

Title:

```text
Semiogram Details
```

Tampilkan chart dan grouped parameter cards.

Parameter yang harus ada:

```text
Average Speed
V: 0.82 m/s

Springiness
StrT: 0.61 s
UtrT: 0.44 s

Smoothness
LDLJₐ: -2.15
SPARCᵣₒₜ: -1.78

Steadiness
CVStrT: 8.2%
CVdstT: 7.5%
P1ₐcc: 0.72
P2ₐcc: 0.68

Sturdiness
SteL: 0.51 m

Stability
RMSₐML: 1.24 m/s²

Symmetry
iHRₐAP: 87%
iHRₐCC: 82%
iHRₐML: 79%
P1P2ₐcc: 0.91
swTᵣ: 0.96

Synchronization
dstT: 6.4%
```

Gunakan collapsible cards kalau memungkinkan. Kalau tidak, gunakan section cards biasa.

---

## 6.10 History Page

Buat halaman history.

Title:

```text
Test History
```

Tampilkan dummy session cards:

```text
Gait Test
12 March 2026

FMA-LE: 24
Severity: Moderate
Classification: CVA
```

Tambahkan badge status.

Jika data kosong, tampilkan empty state:

```text
No test history yet.
Start your first gait assessment.
```

---

## 6.11 Profile Page

Buat halaman profile/settings sederhana.

Komponen:

```text
User Profile
Name
Age
```

Settings list:

* Sensor Calibration
* Data Privacy
* Export Data
* Backend Connection Status
* About App

Footer:

```text
Wellness App v1.0
```

---

# 7. Data Models

Buat model berikut.

## SensorData

```dart
class SensorData {
  final int timestamp;
  final double accX;
  final double accY;
  final double accZ;
  final double gyrX;
  final double gyrY;
  final double gyrZ;
  final String footSide;

  SensorData({
    required this.timestamp,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyrX,
    required this.gyrY,
    required this.gyrZ,
    required this.footSide,
  });

  Map<String, dynamic> toJson();

  factory SensorData.fromJson(Map<String, dynamic> json);
}
```

## SemiogramResult

Field:

```text
V
StrT
UtrT
LDLJa
SPARCrot
CVStrT
CVdstT
P1acc
P2acc
SteL
RMSaML
iHRaAP
iHRaCC
iHRaML
P1P2acc
swTr
dstT
```

## GaitResult

Field:

```text
fmaLeScore
severity
classification
confidence
heelStrikeCount
toeOffCount
semiogram
```

## GaitSession

Field:

```text
id
date
footSide
result
sensorData
```

---

# 8. Services

## SensorService

Buat service untuk:

* Start recording.
* Stop recording.
* Listen accelerometer.
* Listen gyroscope.
* Gabungkan data acc dan gyr ke `SensorData`.
* Sediakan dummy fallback kalau sensor belum jalan.

Gunakan package:

```dart
sensors_plus
```

## ApiService

Buat placeholder:

```dart
Future<GaitResult> analyzeGaitSession({
  required List<SensorData> rightFootData,
  required List<SensorData> leftFootData,
});
```

Untuk sekarang boleh return dummy result dulu.

Tapi siapkan struktur POST ke backend:

```http
POST /api/analyze
```

Payload:

```json
{
  "user_id": "user_001",
  "session_id": "session_001",
  "right_foot_data": [],
  "left_foot_data": []
}
```

## TfliteService

Buat placeholder service:

* Load FMA-LE model.
* Load gait event model.
* Run inference placeholder.
* Jangan error kalau file model belum ada.

Path:

```text
assets/models/fma_le_model.tflite
assets/models/gait_event_model.tflite
```

## LocalStorageService

Untuk sekarang gunakan in-memory dummy history dulu.

Nanti bisa diganti Firebase/Supabase/SQLite.

---

# 9. Preprocessing Utility

Buat utility untuk FreeAcc.

Formula:

```text
FreeAcc = AccTotal - Gravity
AccTotal = sqrt(acc_x^2 + acc_y^2 + acc_z^2)
Gravity = 9.81
```

Implementasi:

```dart
double calculateFreeAcc(double accX, double accY, double accZ) {
  final accTotal = sqrt(accX * accX + accY * accY + accZ * accZ);
  return accTotal - 9.81;
}
```

Tambahkan juga validator:

```dart
bool isValidSensorData(List<SensorData> data)
```

Validasi:

* Data tidak kosong.
* Timestamp valid.
* Tidak ada NaN.
* Jumlah sample cukup.
* Foot side valid.

---

# 10. UI Components

Buat reusable widgets.

## AppButton

Support:

* Primary
* Secondary
* Danger
* Loading state

## AppCard

Card dengan:

* White background
* Radius 24
* Soft shadow
* Padding 20

## SensorStatusCard

Props:

```dart
title
status
icon
isActive
```

## ResultMetricCard

Props:

```dart
title
value
subtitle
icon
color
```

## ProcessingStepTile

Props:

```dart
title
status // pending, active, completed
```

## FootSelectionCard

Props:

```dart
title
description
icon
selected
onTap
```

## SemiogramChart

Gunakan `fl_chart` dengan dummy data.

---

# 11. Backend-Ready Pipeline

Walaupun sekarang fokus Flutter, struktur app harus siap untuk pipeline berikut:

```text
Flutter Sensor Recording
        ↓
Send raw Acc + Gyr time-series to Backend
        ↓
Validate input data
        ↓
Compute FreeAcc
        ↓
Detect gait events
        ↓
Calculate semiogram parameters
        ↓
Run FMA-LE prediction model
        ↓
Classify result
        ↓
Save to database
        ↓
Return result to Flutter
        ↓
Display result
```

---

# 12. Dummy Result Data

Gunakan dummy result berikut untuk Result Page:

```json
{
  "fma_le_score": 24,
  "severity": "Moderate",
  "classification": "CVA",
  "confidence": 0.91,
  "heel_strike_count": 32,
  "toe_off_count": 31,
  "semiogram": {
    "V": 0.82,
    "StrT": 0.61,
    "UtrT": 0.44,
    "LDLJa": -2.15,
    "SPARCrot": -1.78,
    "CVStrT": 8.2,
    "CVdstT": 7.5,
    "P1acc": 0.72,
    "P2acc": 0.68,
    "SteL": 0.51,
    "RMSaML": 1.24,
    "iHRaAP": 87,
    "iHRaCC": 82,
    "iHRaML": 79,
    "P1P2acc": 0.91,
    "swTr": 0.96,
    "dstT": 6.4
  }
}
```

---

# 13. Implementation Steps for Cursor

Tolong lakukan ini secara bertahap:

## Step 1

Cek struktur project Flutter saya saat ini.

## Step 2

Update `pubspec.yaml` dengan dependencies yang diperlukan.

## Step 3

Buat folder structure seperti yang diminta.

## Step 4

Buat theme, colors, constants, dan routes.

## Step 5

Buat data models.

## Step 6

Buat reusable widgets.

## Step 7

Buat semua pages.

## Step 8

Buat providers untuk recording dan session state.

## Step 9

Buat services placeholder.

## Step 10

Pastikan app bisa jalan dengan:

```bash
flutter pub get
flutter run
```

## Step 11

Jika ada error, perbaiki sampai project bisa build.

---

# 14. Coding Rules

Ikuti aturan berikut:

1. Gunakan Dart null safety.
2. Buat kode clean dan modular.
3. Jangan taruh semua kode di `main.dart`.
4. Gunakan widget kecil dan reusable.
5. Jangan over-engineer.
6. Gunakan dummy data dulu jika backend belum tersedia.
7. Pastikan UI tetap bisa berjalan tanpa model `.tflite`.
8. Jangan hapus file penting tanpa konfirmasi.
9. Jika ada konflik dependency, pilih versi yang stabil.
10. Jika route terlalu kompleks, gunakan route sederhana dulu.
11. Tambahkan comment secukupnya pada bagian penting.
12. Pastikan format kode rapi.

---

# 15. Expected Final Result

Saya ingin project Flutter saya memiliki:

1. UI Wellness App yang sudah bisa dijalankan.
2. Flow halaman lengkap.
3. Recording page dengan timer dan sensor UI.
4. Processing page dengan simulated stepper.
5. Result page dengan dummy result.
6. Semiogram detail page.
7. History page.
8. Profile page.
9. Struktur service siap backend.
10. Struktur model siap `.tflite`.
11. FreeAcc utility.
12. App theme yang konsisten.
13. Codebase yang siap dikembangkan.

---

# 16. Important Context

Aplikasi ini adalah wellness/medical style app untuk gait analysis.

Measurement protocol:

```text
User meletakkan HP secara bergantian di kaki kanan dan kaki kiri.
Data yang direkam adalah accelerometer dan gyroscope.
Data diproses menjadi FreeAcc, semiogram, gait event, dan FMA-LE prediction.
```

Core output:

```text
FMA-LE severity
Gait events: Heel Strike vs Toe Off
Semiogram parameters
Classification: Healthy / CVA / etc.
```

Tolong mulai implementasi dari UI dan struktur Flutter terlebih dahulu.

````

Tambahan kecil: sebelum paste prompt itu ke Cursor, kamu bisa kasih instruksi awal seperti ini:

```text id="6fv460"
Please inspect my current Flutter project first, then implement this step by step. Do not rewrite the whole project blindly. Keep existing Flutter configuration unless it conflicts with the requested structure.
````

Prompt ini sudah disusun supaya Cursor langsung paham bahwa fokusnya adalah **bikin aplikasi Flutter-nya dulu**, sementara model ML dan backend masih dibuat integration-ready. Ini juga sesuai konteks file *Wellness App* kamu: model FMA-LE, gait event, dan semiogram diasumsikan sudah tersedia, jadi fokus pengembangan adalah aplikasi dan integrasi model. 
