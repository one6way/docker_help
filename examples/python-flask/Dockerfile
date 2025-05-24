# Использование Python 3.11 slim - компромисс между размером и совместимостью
FROM python:3.11-slim AS base

# Установка рабочей директории для приложения
WORKDIR /app

# Установка переменных окружения
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on

# Создание и активация непривилегированного пользователя
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Установка зависимостей для сборки
FROM base AS builder

# Установка необходимых пакетов для сборки
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Копирование файла зависимостей
COPY requirements.txt .

# Установка зависимостей
RUN pip install --user --no-warn-script-location -r requirements.txt

# Финальный образ
FROM base AS final

# Копирование зависимостей из образа builder
COPY --from=builder /root/.local /home/appuser/.local
ENV PATH=/home/appuser/.local/bin:$PATH

# Копирование исходного кода приложения
COPY app.py .

# Смена владельца файлов на непривилегированного пользователя
RUN chown -R appuser:appuser /app

# Переключение на непривилегированного пользователя
USER appuser

# Открытие порта
EXPOSE 5000

# Запуск приложения
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"] 