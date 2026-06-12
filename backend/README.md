# Gait Analysis — Python Flask backend

Serves ML inference for the Flutter app (the app's `ApiService` POSTs the
recorded accelerometer/gyroscope time series here and gets a `GaitResult`).

## ⚠️ Read this first — preprocessing is a best guess

The model binaries were provided **without the training feature-extraction
code**. The exact channel/feature definitions and ordering are unknown:

| Model | Input (confirmed) | Output |
|---|---|---|
| `gait_left/right.tflite` | `[100, 13]` | `[100, 1]` per-frame prob |
| `cva_classifier.onnx` | `[187]` | label + probability |
| `cva_scaler.onnx` | StandardScaler `[187]` | scaled `[187]` |
| `fma_le.keras` | `[400, 10]` + `[11]` | 1 regression value |

`preprocessing.py` contains a **documented best-guess** pipeline so the flow
works end to end. **Predictions are NOT clinically valid** until that single
file is replaced with the real training pipeline. The function signatures in
`preprocessing.py` are the contract — nothing else needs to change.

Also note:
- Gait-event `.tflite` use TF **Flex ops**; the runtime here can't execute
  them, so heel-strike/toe-off use a signal heuristic (the Flutter UI no
  longer shows that card). They also won't run in Flutter `tflite_flutter`
  on Android without `tensorflow-lite-select-tf-ops`.
- `cva_scaler.onnx` is ONNX opset 22 (newer than onnxruntime supports); its
  offset/scale are read from the graph and applied in numpy.
- FMA-LE `.keras` has a `Lambda` with a raw Python lambda calling `tf` — it
  is loaded with unsafe deserialization and `tf` exposed as a builtin.

## Setup

```bash
cd backend
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt   # tensorflow-cpu is large
```

## Run

```bash
cd backend
.venv/bin/python app.py        # serves on 0.0.0.0:5000
```

- `GET  /health` → `{status, models:{fma,cva,cva_scaler}}`
- `POST /analyze` → body `{samplingRateHz, profile, timeseries[]}` →
  `GaitResult` JSON (matches Flutter `GaitResult.fromJson`).

## Connecting the Flutter app

`ApiService.baseUrl` defaults to `http://10.0.2.2:5000` (Android emulator →
host machine). Override per environment:

```bash
flutter run --dart-define=API_BASE_URL=http://<PC-LAN-IP>:5000   # real device
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000     # iOS sim
```

Android cleartext HTTP is already enabled in the main manifest for dev. If
the backend is unreachable, the app shows a sample result and a notice
(flow never dead-ends).
