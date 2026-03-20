import logging
import pickle
import numpy as np
from fastapi import FastAPI, Response
from prometheus_client import Counter, Histogram, generate_latest

app = FastAPI()

logging.basicConfig(level=logging.INFO)

# Метрики
REQUEST_TIME = Histogram('predict_latency_seconds', 'Prediction latency')
PREDICTIONS_TOTAL = Counter('predictions_total', 'Total predictions')
DRIFT_COUNT = Counter('drift_detected_total', 'Drift detected count')

# Load model
MODEL_PATH = "model_artifacts/model.pkl"

with open(MODEL_PATH, "rb") as f:
    model = pickle.load(f)

BASELINE_MEAN = 3.5

def detect_drift(data):
    return abs(np.mean(data) - BASELINE_MEAN) > 2

@app.get("/")
def health():
    return {"status": "ok"}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type="text/plain")

@app.post("/predict")
@REQUEST_TIME.time()
def predict_api(features: list):
    PREDICTIONS_TOTAL.inc()

    pred = int(model.predict([features])[0])

    drift = detect_drift(features)

    if drift:
        DRIFT_COUNT.inc()
        logging.warning(f"DRIFT DETECTED: {features}")

    logging.info(f"Input: {features}, Prediction: {pred}")

    return {
        "prediction": pred,
        "drift": drift
    }