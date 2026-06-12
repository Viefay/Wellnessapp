"""
==============================================================================
  ⚠️  BEST-GUESS PREPROCESSING — ASSUMPTIONS, NOT THE REAL TRAINING PIPELINE
==============================================================================

The model binaries were provided WITHOUT the feature-extraction / windowing
code used during training. The exact definition and ORDER of:

  * gait-event input channels  -> shape [100, 13]
  * FMA-LE time-series channels -> shape [400, 10]
  * FMA-LE tabular features     -> shape [11]
  * CVA engineered features     -> shape [187]

are therefore UNKNOWN and cannot be recovered from the binaries. Everything
below is a documented best guess so the end-to-end flow works for a demo.
Predictions are NOT clinically valid until this module is replaced with the
real pipeline from the model authors.

To make predictions valid: replace ONLY this file with the training
preprocessing. The rest of the backend (model loading, endpoint, Flutter
wiring) does not need to change — the function signatures here are the
contract.
==============================================================================
"""
from __future__ import annotations
import numpy as np

# ---- expected model input dimensions (confirmed from the binaries) ----------
GAIT_WIN = 100
GAIT_CH = 13
FMA_WIN = 400
FMA_CH = 10
FMA_TAB = 11
CVA_FEATS = 187


def _to_array(timeseries: list[dict]) -> np.ndarray:
    """Raw samples -> (N, 6) float array [accX,accY,accZ,gyrX,gyrY,gyrZ]."""
    if not timeseries:
        return np.zeros((1, 6), np.float32)
    cols = ("accX", "accY", "accZ", "gyrX", "gyrY", "gyrZ")
    arr = np.array(
        [[float(s.get(c, 0.0)) for c in cols] for s in timeseries],
        dtype=np.float32,
    )
    return arr if arr.size else np.zeros((1, 6), np.float32)


def _resample(sig: np.ndarray, length: int) -> np.ndarray:
    """Linearly resample (N, C) -> (length, C)."""
    n = sig.shape[0]
    if n == length:
        return sig
    if n < 2:
        return np.repeat(sig, length, axis=0)[:length]
    xp = np.linspace(0.0, 1.0, n)
    xq = np.linspace(0.0, 1.0, length)
    return np.stack(
        [np.interp(xq, xp, sig[:, c]) for c in range(sig.shape[1])], axis=1
    ).astype(np.float32)


def _derived(acc_gyr: np.ndarray) -> np.ndarray:
    """ASSUMPTION: augment 6 raw channels with simple derived signals.

    free-acc (gravity removed via per-axis mean), magnitudes, jerk. Order is
    a guess; the real training order is required for valid output.
    """
    acc = acc_gyr[:, 0:3]
    gyr = acc_gyr[:, 3:6]
    free = acc - acc.mean(axis=0, keepdims=True)          # 3  (FreeAcc)
    acc_mag = np.linalg.norm(acc, axis=1, keepdims=True)  # 1
    gyr_mag = np.linalg.norm(gyr, axis=1, keepdims=True)  # 1
    free_mag = np.linalg.norm(free, axis=1, keepdims=True)  # 1
    jerk = np.vstack([np.zeros((1, 3), np.float32), np.diff(acc, axis=0)])  # 3
    # 6 + 3 + 1 + 1 + 1 + 3 = 15 available channels to slice from
    return np.concatenate(
        [acc_gyr, free, acc_mag, gyr_mag, free_mag, jerk], axis=1
    ).astype(np.float32)


def _zscore(x: np.ndarray) -> np.ndarray:
    m = x.mean(axis=0, keepdims=True)
    s = x.std(axis=0, keepdims=True) + 1e-6
    return ((x - m) / s).astype(np.float32)


def gait_window(timeseries: list[dict]) -> np.ndarray:
    """-> (1, 100, 13) ASSUMPTION input for the gait-event models."""
    feat = _derived(_to_array(timeseries))          # (N, 15)
    feat = _resample(feat, GAIT_WIN)                 # (100, 15)
    feat = _zscore(feat)[:, :GAIT_CH]                # (100, 13)
    return feat[np.newaxis, ...].astype(np.float32)


def fma_window(timeseries: list[dict]) -> np.ndarray:
    """-> (1, 400, 10) ASSUMPTION time-series input for FMA-LE."""
    feat = _derived(_to_array(timeseries))          # (N, 15)
    feat = _resample(feat, FMA_WIN)                  # (400, 15)
    feat = _zscore(feat)[:, :FMA_CH]                 # (400, 10)
    return feat[np.newaxis, ...].astype(np.float32)


def fma_tabular(profile: dict) -> np.ndarray:
    """-> (1, 11) ASSUMPTION tabular features for FMA-LE.

    Guess: [sex(0/1), age, height_m, weight_kg, bmi] + 6 zeros padding.
    Real training feature set/order is required for valid output.
    """
    sex = 1.0 if str(profile.get("gender", "M")).upper().startswith("M") else 0.0
    age = float(profile.get("age", 0))
    h = float(profile.get("heightM", 0))
    w = float(profile.get("weightKg", 0))
    bmi = w / (h * h) if h > 0 else 0.0
    vec = np.zeros((FMA_TAB,), np.float32)
    vec[:5] = [sex, age, h, w, bmi]
    return vec[np.newaxis, ...]


def _generic_features(sig: np.ndarray) -> np.ndarray:
    """Per-channel generic statistical/spectral features (ASSUMPTION set)."""
    feats = []
    for c in range(sig.shape[1]):
        x = sig[:, c]
        fft = np.abs(np.fft.rfft(x - x.mean())) if x.size > 1 else np.zeros(1)
        dom = float(np.argmax(fft)) if fft.size else 0.0
        feats += [
            float(x.mean()), float(x.std()), float(x.min()), float(x.max()),
            float(np.sqrt(np.mean(x ** 2))),               # RMS
            float(np.mean(np.abs(x))),                     # MAV
            float(((x[:-1] * x[1:]) < 0).sum()) if x.size > 1 else 0.0,  # ZCR
            float(np.percentile(x, 25)), float(np.percentile(x, 75)),
            float(fft.sum()), dom,
        ]
    return np.asarray(feats, np.float32)


def cva_features(timeseries: list[dict], profile: dict) -> np.ndarray:
    """-> (1, 187) ASSUMPTION engineered feature vector for the CVA model.

    The real 187-feature set is hand-crafted and unknown. We build a generic
    feature bank over the 15 derived channels, prepend demographics, then
    pad / truncate to exactly 187. Ordering will NOT match training — this is
    a structural placeholder so the model runs.
    """
    sig = _derived(_to_array(timeseries))             # (N, 15)
    bank = _generic_features(sig)                     # 15 * 11 = 165
    sex = 1.0 if str(profile.get("gender", "M")).upper().startswith("M") else 0.0
    demo = np.array(
        [
            float(profile.get("age", 0)),
            float(profile.get("heightM", 0)),
            float(profile.get("weightKg", 0)),
            (lambda h, w: w / (h * h) if h > 0 else 0.0)(
                float(profile.get("heightM", 0)),
                float(profile.get("weightKg", 0)),
            ),
            sex,
        ],
        np.float32,
    )
    vec = np.concatenate([demo, bank]).astype(np.float32)
    if vec.size < CVA_FEATS:
        vec = np.pad(vec, (0, CVA_FEATS - vec.size))
    return vec[:CVA_FEATS][np.newaxis, ...]


def apply_scaler(x: np.ndarray, offset: np.ndarray,
                  scale: np.ndarray) -> np.ndarray:
    """skl2onnx Scaler op: (x - offset) * scale. Done in numpy because the
    provided cva_scaler.onnx uses opset 22 (newer than onnxruntime supports);
    offset/scale are read from the .onnx graph at load time."""
    return ((x - offset) * scale).astype(np.float32)
