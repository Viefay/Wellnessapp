"""End-to-end analysis: raw acc/gyr + profile -> GaitResult JSON.

The response shape matches the Flutter `GaitResult.fromJson` /
`SemiogramResult.fromJson` contract exactly so `ApiService` can parse it
directly.

NOTE: gait-event counts and the semiogram are signal heuristics (the gait
TFLite models need TF Flex which the runtime here can't execute, and no
semiogram feature spec was provided). FMA-LE and CVA come from the real
models but fed with the best-guess `preprocessing` module — see the warning
at the top of preprocessing.py.
"""
from __future__ import annotations
import numpy as np

import preprocessing as pp
from models import ModelBundle

_bundle: ModelBundle | None = None


def get_bundle() -> ModelBundle:
    global _bundle
    if _bundle is None:
        _bundle = ModelBundle()
    return _bundle


def _norm(v: float, lo: float, hi: float) -> float:
    return float(np.clip((v - lo) / (hi - lo + 1e-9), 0.0, 1.0))


def _gait_events(acc_gyr: np.ndarray, fs: int) -> tuple[int, int]:
    """Heuristic heel-strike / toe-off count via peak picking on the
    acceleration magnitude (placeholder for the Flex tflite models)."""
    if acc_gyr.shape[0] < 3:
        return 0, 0
    mag = np.linalg.norm(acc_gyr[:, 0:3], axis=1)
    mag = mag - mag.mean()
    thr = mag.std() * 0.6
    min_gap = max(int(fs * 0.3), 1)  # ≥0.3 s between steps
    peaks, last = [], -min_gap
    for i in range(1, len(mag) - 1):
        if mag[i] > thr and mag[i] >= mag[i - 1] and mag[i] > mag[i + 1] \
                and i - last >= min_gap:
            peaks.append(i)
            last = i
    heel = len(peaks)
    return heel, max(heel - 1, 0)


def _semiogram(acc_gyr: np.ndarray, fs: int) -> dict:
    """Heuristic semiogram (0..1 health-oriented), documented placeholder."""
    acc = acc_gyr[:, 0:3]
    gyr = acc_gyr[:, 3:6]
    mag = np.linalg.norm(acc, axis=1)
    rms = float(np.sqrt(np.mean(mag ** 2))) if mag.size else 0.0
    var = float(np.var(mag)) if mag.size else 0.0
    # signal regularity via autocorrelation peak
    reg = 0.0
    if mag.size > fs:
        m = mag - mag.mean()
        ac = np.correlate(m, m, "full")[len(m) - 1:]
        ac = ac / (ac[0] + 1e-9)
        reg = float(np.clip(ac[fs // 2: fs * 2].max(), 0.0, 1.0)) \
            if ac.size > fs * 2 else 0.0
    speed = _norm(rms, 8.0, 14.0)
    smooth = _norm(-var, -20.0, 0.0)
    sym = _norm(reg, 0.2, 0.9)
    spring = _norm(float(np.std(gyr)), 0.5, 4.0)
    return {
        "v": round(speed, 3),
        "strT": round(spring, 3),
        "utrT": round(0.5 * spring + 0.3, 3),
        "ldlja": round(smooth, 3),
        "sparcrot": round(0.6 * smooth + 0.2, 3),
        "sparctra": round(0.55 * smooth + 0.2, 3),
        "sparcver": round(0.5 * smooth + 0.25, 3),
        "mdifAP": round(0.5 * sym, 3),
        "mdifML": round(0.5 * sym + 0.1, 3),
        "cvStrideTime": round(1.0 - sym, 3),
        "cvStrideLength": round(1.0 - 0.9 * sym, 3),
        "symmetryIndex": round(sym, 3),
        "stepLengthLeft": round(0.45 + 0.2 * speed, 3),
        "stepLengthRight": round(0.45 + 0.2 * speed, 3),
        "stanceLeft": round(60.0 + 6.0 * (1.0 - sym), 1),
        "stanceRight": round(60.0 - 4.0 * (1.0 - sym), 1),
        "cadence": round(80.0 + 40.0 * speed, 1),
    }


def _severity(fma: int) -> str:
    if fma >= 29:
        return "Mild"
    if fma >= 21:
        return "Moderate"
    return "Severe"


def analyze(timeseries: list[dict], profile: dict, fs: int = 100) -> dict:
    b = get_bundle()
    acc_gyr = pp._to_array(timeseries)

    # FMA-LE (real model, best-guess preprocessing)
    fma_val = b.predict_fma(pp.fma_window(timeseries),
                            pp.fma_tabular(profile))
    if fma_val is None:
        # fallback from heuristic semiogram health when model unavailable/nan
        sym = _semiogram(acc_gyr, fs)["symmetryIndex"]
        fma_score = int(round(10 + 24 * sym))
    else:
        fma_score = int(round(float(np.clip(fma_val, 0, 34))))
    fma_score = int(np.clip(fma_score, 0, 34))

    # CVA classification (real model, best-guess 187 features)
    label, conf = b.predict_cva(pp.cva_features(timeseries, profile))
    if label is None:
        classification, confidence = "Unknown", 0.5
    else:
        classification = "CVA" if int(label) == 1 else "Non-CVA"
        confidence = float(np.clip(conf if conf is not None else 0.5,
                                   0.0, 1.0))

    heel, toe = _gait_events(acc_gyr, fs)

    return {
        "fmaLeScore": fma_score,
        "severity": _severity(fma_score),
        "classification": classification,
        "confidence": round(confidence, 4),
        "heelStrikeCount": heel,
        "toeOffCount": toe,
        "semiogram": _semiogram(acc_gyr, fs),
        "_meta": {
            "models": b.status,
            "samples": int(acc_gyr.shape[0]),
            "fma_raw": None if fma_val is None else round(float(fma_val), 4),
            "warning": "FMA/CVA use best-guess preprocessing; gait-event & "
                       "semiogram are heuristics. Not clinically valid until "
                       "the real feature pipeline replaces preprocessing.py.",
        },
    }
