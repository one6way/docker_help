# Использование Alpine Linux для минимального размера
FROM nginx:1.25-alpine

# Создание непривилегированного пользователя
RUN addgroup -S appgroup && \
    adduser -S -G appgroup appuser && \
    # Создание необходимых директорий с правильными правами
    mkdir -p /var/cache/nginx /var/log/nginx && \
    chown -R appuser:appgroup /var/cache/nginx /var/log/nginx && \
    # Убедимся, что Nginx может писать временные файлы
    chmod -R 755 /var/cache/nginx

# Копирование конфигурации Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/

# Копирование статических файлов (если есть)
COPY html/ /usr/share/nginx/html/

# Проверка конфигурации Nginx
RUN nginx -t

# Изменение владельца файлов
RUN chown -R appuser:appgroup /usr/share/nginx/html /etc/nginx/conf.d

# Порты, которые будет слушать контейнер
EXPOSE 80 443

# Проверка доступности сервера
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q -O - http://localhost:80/health || exit 1

# Запуск Nginx от непривилегированного пользователя
# Примечание: для портов <1024 все равно потребуются дополнительные capabilities
USER appuser

# Запуск Nginx в основном процессе
CMD ["nginx", "-g", "daemon off;"] 