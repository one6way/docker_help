from flask import Flask, jsonify
import os

app = Flask(__name__)

# Получение переменных окружения с дефолтными значениями
API_VERSION = os.environ.get("API_VERSION", "1.0.0")
ENVIRONMENT = os.environ.get("ENVIRONMENT", "development")

@app.route("/")
def home():
    return jsonify({
        "status": "success",
        "message": "Flask API is running",
        "version": API_VERSION,
        "environment": ENVIRONMENT
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "up",
        "version": API_VERSION
    })

@app.route("/api/items")
def get_items():
    # Простой пример эндпоинта API
    items = [
        {"id": 1, "name": "Item 1"},
        {"id": 2, "name": "Item 2"},
        {"id": 3, "name": "Item 3"}
    ]
    return jsonify(items)

if __name__ == "__main__":
    # В production использовать gunicorn
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=ENVIRONMENT == "development") 