"""Model loading + low-level inference.

- FMA-LE  : Keras 3 model (.keras). Needs unsafe deserialization (a Lambda
            stores a raw Python lambda) and `tf` exposed as a builtin because
            that lambda calls `tf.reduce_sum` with no import in its scope.
- CVA clf : ONNX TreeEnsembleClassifier (onnxruntime).
- CVA scl : skl2onnx Scaler. Its .onnx is opset 22 (newer than onnxruntime
            supports) so we read offset/scale from the graph and scale in
            numpy instead of running it.
- Gait    : .tflite with TF Flex ops (TensorList/LSTM). The bundled tf.lite
            interpreter in TF 2.20 cannot run Flex, so gait-event detection
            falls back to a documented signal heuristic. (The Flutter UI no
            longer shows the gait-event card, so this is low impact.)
"""
from __future__ import annotations
import os
import builtins
import warnings
import numpy as np

warnings.filterwarnings("ignore")
os.environ.setdefault("TF_CPP_MIN_LOG_LEVEL", "3")

MODELS_DIR = os.path.join(os.path.dirname(__file__), "models")


class ModelBundle:
    def __init__(self) -> None:
        self.fma = None
        self.cva = None
        self.cva_offset = None
        self.cva_scale = None
        self.status: dict[str, str] = {}
        self._load_fma()
        self._load_cva()
        self._load_scaler()

    # ---- FMA-LE -----------------------------------------------------------
    def _load_fma(self) -> None:
        try:
            import tensorflow as tf
            import keras

            builtins.tf = tf  # Lambda layer calls bare `tf.reduce_sum`
            keras.config.enable_unsafe_deserialization()
            self.fma = keras.models.load_model(
                os.path.join(MODELS_DIR, "fma_le.keras"),
                compile=False,
                safe_mode=False,
            )
            self.status["fma"] = "loaded"
        except Exception as e:  # pragma: no cover - defensive
            self.status["fma"] = f"unavailable: {e!r}"[:160]

    def _load_cva(self) -> None:
        try:
            import onnxruntime as ort

            self.cva = ort.InferenceSession(
                os.path.join(MODELS_DIR, "cva_classifier.onnx"),
                providers=["CPUExecutionProvider"],
            )
            self.status["cva"] = "loaded"
        except Exception as e:
            self.status["cva"] = f"unavailable: {e!r}"[:160]

    def _load_scaler(self) -> None:
        try:
            import onnx

            m = onnx.load(os.path.join(MODELS_DIR, "cva_scaler.onnx"))
            for n in m.graph.node:
                if n.op_type == "Scaler":
                    for a in n.attribute:
                        if a.name == "offset":
                            self.cva_offset = np.array(a.floats, np.float32)
                        elif a.name == "scale":
                            self.cva_scale = np.array(a.floats, np.float32)
            self.status["cva_scaler"] = (
                "loaded" if self.cva_offset is not None else "missing params"
            )
        except Exception as e:
            self.status["cva_scaler"] = f"unavailable: {e!r}"[:160]

    # ---- inference --------------------------------------------------------
    def predict_fma(self, ts: np.ndarray, tab: np.ndarray) -> float | None:
        if self.fma is None:
            return None
        try:
            y = self.fma.predict([ts, tab], verbose=0)
            v = float(np.ravel(y)[0])
            return None if not np.isfinite(v) else v
        except Exception:
            return None

    def predict_cva(self, feats187: np.ndarray):
        """Returns (label:int, confidence:float) or (None, None)."""
        if self.cva is None:
            return None, None
        try:
            x = feats187
            if self.cva_offset is not None and self.cva_scale is not None:
                x = (x - self.cva_offset) * self.cva_scale
            out = self.cva.run(None, {"float_input": x.astype(np.float32)})
            label = int(np.ravel(out[0])[0])
            conf = 0.5
            probs = out[1]
            if isinstance(probs, list) and probs and isinstance(probs[0], dict):
                conf = float(probs[0].get(label, max(probs[0].values())))
            return label, conf
        except Exception:
            return None, None
