import os
import mlflow
import mlflow.sklearn
from dotenv import load_dotenv

from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, log_loss

from prometheus_client import CollectorRegistry, Gauge, push_to_gateway


load_dotenv()

mlflow.set_tracking_uri(os.environ["MLFLOW_TRACKING_URI"])
mlflow.set_experiment("iris-experiments")


X, y = load_iris(return_X_y=True)

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)


def run_experiment(lr, epochs):

    with mlflow.start_run() as run:

        model = LogisticRegression(
            max_iter=epochs,
            C=max(0.0001, 1 / lr),
            random_state=42
        )

        model.fit(X_train, y_train)

        y_pred = model.predict(X_test)

        acc = accuracy_score(y_test, y_pred)

        loss = log_loss(
            y_test,
            model.predict_proba(X_test)
        )

        mlflow.log_param("learning_rate", lr)
        mlflow.log_param("epochs", epochs)

        mlflow.log_metric("accuracy", acc)
        mlflow.log_metric("loss", loss)

        mlflow.sklearn.log_model(model, "model")

        registry = CollectorRegistry()

        g_acc = Gauge(
            "mlflow_accuracy",
            "Model accuracy",
            ["run_id"],
            registry=registry
        )

        g_loss = Gauge(
            "mlflow_loss",
            "Model loss",
            ["run_id"],
            registry=registry
        )

        g_acc.labels(run_id=run.info.run_id).set(acc)
        g_loss.labels(run_id=run.info.run_id).set(loss)

        push_to_gateway(
            os.environ["PUSHGATEWAY_URL"],
            job="mlflow_experiments",
            registry=registry
        )

        return run.info.run_id, acc


params = [0.001, 0.01, 0.1, 1.0]

results = []

for lr in params:

    print(f"Running experiment lr={lr}")

    run_id, accuracy = run_experiment(lr, 200)

    results.append((run_id, accuracy))


best_run = max(results, key=lambda x: x[1])

print(f"Best run: {best_run}")


if not os.path.exists("../best_model"):
    os.makedirs("../best_model")


mlflow.artifacts.download_artifacts(
    run_id=best_run[0],
    artifact_path="model",
    dst_path="../best_model"
)

print("Best model saved to best_model/")