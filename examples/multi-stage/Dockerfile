# =========================================
# 1. Этап сборки Frontend (React)
# =========================================
FROM node:18-alpine AS frontend-builder

# Установка рабочей директории
WORKDIR /app/frontend

# Установка зависимостей
COPY frontend/package*.json ./
RUN npm ci

# Копирование исходного кода
COPY frontend/ ./

# Сборка приложения
RUN npm run build

# =========================================
# 2. Этап сборки Backend (Node.js)
# =========================================
FROM node:18-alpine AS backend-builder

# Установка рабочей директории
WORKDIR /app/backend

# Установка зависимостей
COPY backend/package*.json ./
RUN npm ci --only=production

# Копирование исходного кода
COPY backend/ ./

# Если есть шаг сборки backend, например TypeScript
# RUN npm run build

# =========================================
# 3. Финальный этап
# =========================================
FROM node:18-alpine AS final

# Установка переменных окружения
ENV NODE_ENV=production \
    PORT=3000

# Создание непривилегированного пользователя
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Установка рабочей директории
WORKDIR /app

# Копирование собранного frontend из первого этапа
COPY --from=frontend-builder /app/frontend/build /app/public

# Копирование backend зависимостей и кода
COPY --from=backend-builder /app/backend/node_modules /app/node_modules
COPY --from=backend-builder /app/backend /app

# Настройка прав доступа
RUN chown -R appuser:appgroup /app

# Переключение на непривилегированного пользователя
USER appuser

# Открытие порта
EXPOSE 3000

# Проверка работоспособности
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q -O - http://localhost:3000/api/health || exit 1

# Запуск приложения
CMD ["node", "server.js"] 