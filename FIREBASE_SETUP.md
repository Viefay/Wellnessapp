# Firebase Setup (Firestore + Storage, no auth)

Project: `wellnessapp-bae7b`. `google-services.json` and
`firebase_options.dart` are already in place; `firebase_core` is initialised
in `main.dart`. The app uses Firebase **without authentication**.

## Dependencies (already in `pubspec.yaml`)

- `cloud_firestore: ^6.0.0`, `firebase_storage: ^13.0.0`
- export deps: `shared_preferences`, `path_provider`, `share_plus`, `pdf`,
  `printing`

## Android (already applied)

- `android/app/build.gradle.kts`: `minSdk = maxOf(flutter.minSdkVersion, 23)`
  (Firebase requires 23). google-services plugin applied; `applicationId`
  `com.example.wellness_app` matches `google-services.json`.

## Security rules — REQUIRED (no login!)

Requests are unauthenticated, so default rules deny them. In the Firebase
console set test-mode rules:

**Firestore**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /profile/{doc}  { allow read, write: if true; }
    match /sessions/{doc} { allow read, write: if true; }
  }
}
```
**Storage**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /exports/{sessionId}/{file} { allow read, write: if true; }
  }
}
```
If rules are not relaxed (or device offline), every Firebase call fails
gracefully: profile falls back to local `shared_preferences`, sessions stay
in-memory for the session, uploads are skipped. The app never crashes — it
shows a non-fatal notice.

## Data model

| Path | Contents |
|---|---|
| `profile/current` | single `UserProfile` (no per-user split, no auth) |
| `sessions/{millisId}` | `GaitSession` JSON incl. `csvUrl`, `pdfUrl` |
| `exports/{sessionId}/timeseries.csv` | Storage: ACC+Gyr time series |
| `exports/{sessionId}/report.pdf` | Storage: PDF analysis report |

"Save Result to History" builds CSV + PDF, uploads both to Storage, writes
`sessions/{id}` with their download URLs.

## Build / troubleshooting

```
flutter pub get
flutter build apk --debug   # verified OK: app-debug.apk produced
```

**Gradle "Cannot lock file hash cache … already been locked by this
process":** caused by Android Studio's Gradle daemon locking
`android/.gradle` while a CLI build runs (often after an interrupted build).
Fix:

```
cd android && ./gradlew --stop        # stop daemons
pkill -f 'org.gradle.launcher.daemon' # kill any AS daemon --stop missed
rm -rf android/.gradle                # delete corrupt project cache (regenerated)
cd .. && flutter clean && flutter pub get && flutter build apk --debug
```

Don't run a Gradle sync/build in Android Studio at the same time as a CLI
build.
