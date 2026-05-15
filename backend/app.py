"""Flask API for gait analysis.

Endpoints
  GET  /health   -> model load status
  POST /analyze   -> body: {"samplingRateHz": int,
                            "profile": {gender,age,heightM,weightKg,...},
                            "timeseries": [{accX,accY,accZ,gyrX,gyrY,gyrZ,
                                            footSide,timestamp}, ...]}
                     returns the GaitResult JSON consumed by the Flutter
                     ApiService.

Run:
  cd backend && .venv/bin/python app.py
  (listens on 0.0.0.0:5000 — Android emulator reaches it at 10.0.2.2:5000)
"""
from __future__ import annotations
from flask import Flask, request, jsonify
from flask_cors import CORS

from inference import analyze, get_bundle

app = Flask(__name__)
CORS(app)


@app.get("/health")
def health():
    return jsonify({"status": "ok", "models": get_bundle().status})


@app.post("/analyze")
def analyze_route():
    data = request.get_json(silent=True) or {}
    ts = data.get("timeseries", [])
    profile = data.get("profile", {})
    fs = int(data.get("samplingRateHz", 100) or 100)
    if not isinstance(ts, list) or len(ts) == 0:
        return jsonify({"error": "timeseries is empty or missing"}), 400
    try:
        return jsonify(analyze(ts, profile, fs))
    except Exception as e:  # pragma: no cover - defensive
        return jsonify({"error": f"analysis failed: {e!r}"[:300]}), 500


if __name__ == "__main__":
    get_bundle()  # warm-load models at startup
    app.run(host="0.0.0.0", port=5000, debug=False)
