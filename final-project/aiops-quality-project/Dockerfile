FROM python:3.10

WORKDIR /app

COPY app/ app/
COPY model_artifacts/ model_artifacts/

RUN pip install fastapi uvicorn scikit-learn numpy prometheus_client

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]