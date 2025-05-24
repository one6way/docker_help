# Многоступенчатый Dockerfile для демонстрации различий в shell-скриптах
# между разными Linux дистрибутивами

# =========================================
# 1. Debian/Ubuntu (bash, полный набор утилит)
# =========================================
FROM debian:11-slim AS debian

# Обновление и установка базовых утилит
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    coreutils \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Копирование скрипта
COPY script.sh /script.sh
RUN chmod +x /script.sh

# Проверка shell-окружения
RUN echo "=== Debian environment ===" && \
    bash --version | head -n 1 && \
    echo "Shell: $SHELL" && \
    ls -la /bin/sh && \
    which bash

# Запуск скрипта для демонстрации
CMD ["/script.sh"]

# =========================================
# 2. Alpine Linux (BusyBox sh)
# =========================================
FROM alpine:3.18 AS alpine

# Установка bash для сравнения (обычно только BusyBox sh)
RUN apk add --no-cache bash

# Копирование скрипта
COPY script.sh /script.sh
RUN chmod +x /script.sh

# Проверка shell-окружения
RUN echo "=== Alpine environment ===" && \
    if command -v bash &> /dev/null; then bash --version | head -n 1; else echo "Bash not installed"; fi && \
    echo "Shell: $SHELL" && \
    ls -la /bin/sh && \
    which sh

# Запуск скрипта для демонстрации
CMD ["/script.sh"]

# =========================================
# 3. BusyBox (минимальная оболочка sh)
# =========================================
FROM busybox:1.36 AS busybox

# Копирование скрипта
COPY script.sh /script.sh
RUN chmod +x /script.sh

# Проверка shell-окружения
RUN echo "=== BusyBox environment ===" && \
    busybox | head -n 1 && \
    echo "Shell: $SHELL" && \
    ls -la /bin/sh && \
    which sh

# Запуск скрипта для демонстрации
CMD ["/script.sh"]

# =========================================
# 4. UBI (Red Hat Universal Base Image)
# =========================================
FROM registry.access.redhat.com/ubi8/ubi-minimal AS ubi

# Обновление и установка bash
RUN microdnf install -y bash && microdnf clean all

# Копирование скрипта
COPY script.sh /script.sh
RUN chmod +x /script.sh

# Проверка shell-окружения
RUN echo "=== UBI environment ===" && \
    bash --version | head -n 1 && \
    echo "Shell: $SHELL" && \
    ls -la /bin/sh && \
    which bash

# Запуск скрипта для демонстрации
CMD ["/script.sh"] 