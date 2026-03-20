# AIOps Quality Project


# Опис інфраструктури

Цей проєкт реалізує end-to-end MLOps pipeline для inference сервісу з контролем якості моделі.

aiops-quality-project/
├── app/
│  └── main.py         # FastAPI‑інференс
├── model/
│  └── train.py         # Скрипт для retrain
├── helm/
│  ├── Chart.yaml
│  ├── values.yaml
├── argocd/
│  └── application.yaml
├── .gitlab-ci.yml
├── grafana/
│  └── dashboards.json
├── prometheus/
│  └── additionalScrapeConfigs.yaml
├── loki/
│   ├── loki-config.yaml
│   └── promtail-config.yaml
├── README.md

# Основні компоненти:

FastAPI — inference API для моделі

Scikit-learn модель — проста модель класифікації (Iris)

Drift detector — перевірка вхідних даних на відхилення

Docker — контейнеризація сервісу

Kubernetes + Helm — деплой сервісу

ArgoCD — GitOps (автоматичний деплой із Git)

Prometheus — збір метрик

Grafana — візуалізація метрик

Loki + Promtail — централізоване логування

GitLab CI/CD — автоматичний retrain і деплой нової моделі

# Як запустити проєкт
1. Натренувати модель
python model/train.py

Це створить файл:

model_artifacts/model.pkl
2. Зібрати Docker-образ
docker build -t <your-dockerhub>/aiops-app .
docker push <your-dockerhub>/aiops-app
3. Задеплоїти через ArgoCD
kubectl apply -f argocd/application.yaml

ArgoCD автоматично створить Deployment і Service у кластері.

4. Відкрити доступ до сервісу
kubectl port-forward svc/aiops-service 8000:80

# Як протестувати запит
curl -X POST http://localhost:8000/predict \
-H "Content-Type: application/json" \
-d "[5.1,3.5,1.4,0.2]"

Очікувана відповідь:

{
  "prediction": 0,
  "drift": false
}

# Як перевірити логування
Через Kubernetes:
kubectl logs -l app=aiops
Через Grafana (Loki):

Відкрити Grafana

Перейти в Explore

Виконати запит:

{app="aiops"}

Там будуть логи:

Input дані

Prediction

Drift alerts

# Як перевірити спрацювання детектора дрейфу

Відправ аномальні дані:

curl -X POST http://localhost:8000/predict \
-H "Content-Type: application/json" \
-d "[20,20,20,20]"
Очікувано:

У відповіді:

"drift": true

У логах:

DRIFT DETECTED

У Grafana:
з’явиться запис про drift

# Як перевірити, що retrain-пайплайн працює
Запустити CI:
git commit --allow-empty -m "trigger retrain"
git push
Що відбудеться:

GitLab CI запускає job retrain

Модель перевчається

Створюється новий Docker image

Оновлюється helm/values.yaml (новий tag)

ArgoCD автоматично робить redeploy

Перевірка:

У GitLab → pipeline статус = success

У Kubernetes:

kubectl get pods

→ новий pod із новим image

# Як оновити модель
Варіант 1 (через CI)

Просто:
git push
CI:
тренує модель
білдить образ
деплоїть

Варіант 2 (локально)
python model/train.py
docker build -t <image>:new .
docker push <image>:new

Після цього оновити:

helm/values.yaml
tag: new

і запушити зміни — ArgoCD задеплоїть нову версію.

# Результат

FastAPI сервіс працює в Kubernetes
Метрики доступні через Prometheus
Логи збираються через Loki
Drift detection працює
CI/CD автоматично оновлює модель
ArgoCD забезпечує безперервний деплой

# Висновок

У проєкті реалізовано повноцінний MLOps pipeline:

inference
моніторинг
логування
контроль якості даних
автоматичне перевчання моделі
GitOps деплой