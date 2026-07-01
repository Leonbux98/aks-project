import os
import time
from flask import Flask, jsonify, render_template
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

START_TIME = time.time()

REQUEST_COUNT = Counter(
    "app_requests_total",
    "Total HTTP requests",
    ["method", "endpoint", "status"],
)
REQUEST_LATENCY = Histogram(
    "app_request_latency_seconds",
    "HTTP request latency",
    ["endpoint"],
)


@app.route("/")
def index():
    REQUEST_COUNT.labels(method="GET", endpoint="/", status="200").inc()
    return render_template("index.html", version=os.getenv("APP_VERSION", "1.0.0"))


@app.route("/health")
def health():
    REQUEST_COUNT.labels(method="GET", endpoint="/health", status="200").inc()
    return jsonify({"status": "healthy"}), 200


@app.route("/ready")
def ready():
    REQUEST_COUNT.labels(method="GET", endpoint="/ready", status="200").inc()
    return jsonify({"status": "ready"}), 200


@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}


@app.route("/info")
def info():
    uptime = int(time.time() - START_TIME)
    return jsonify({
        "version": os.getenv("APP_VERSION", "1.0.0"),
        "environment": os.getenv("ENVIRONMENT", "production"),
        "uptime_seconds": uptime,
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)




