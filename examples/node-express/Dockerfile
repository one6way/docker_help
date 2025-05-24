# Используем Node.js 18 на Alpine Linux для минимального размера
FROM node:18-alpine AS base

# Установка рабочей директории
WORKDIR /app

# Добавление непривилегированного пользователя
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Установка зависимостей для сборки
FROM base AS deps

# Копирование файлов package.json и package-lock.json
COPY package*.json ./

# Установка зависимостей
RUN npm ci --only=production

# Сборка приложения (если требуется)
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Если требуется сборка (TypeScript, Webpack и т.д.)
# RUN npm run build

# Финальный образ
FROM base AS runner

# Установка переменных окружения
ENV NODE_ENV=production \
    PORT=3000

# Копирование зависимостей и собранных файлов
COPY --from=deps /app/node_modules ./node_modules
# Если была сборка
# COPY --from=builder /app/dist ./dist
# Иначе копируем исходный код
COPY index.js ./

# Смена владельца файлов
RUN chown -R appuser:appgroup /app

# Переключение на непривилегированного пользователя
USER appuser

# Открытие порта
EXPOSE 3000

# Проверка работоспособности
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q -O - http://localhost:3000/health || exit 1

# Запуск приложения
CMD ["node", "index.js"] 