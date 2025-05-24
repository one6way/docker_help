# Этап сборки
FROM golang:1.21-alpine AS builder

# Установка рабочей директории
WORKDIR /app

# Установка необходимых инструментов
RUN apk add --no-cache git ca-certificates tzdata && \
    update-ca-certificates

# Копирование модулей Go
COPY go.mod go.sum ./
RUN go mod download

# Копирование исходного кода
COPY . .

# Сборка приложения
# Флаги компиляции:
# -ldflags="-s -w" - убирает отладочную информацию для уменьшения размера
# CGO_ENABLED=0 - отключает CGO для создания статически скомпилированного бинарника
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /go/bin/app .

# Этап создания минимального образа
FROM scratch

# Копирование сертификатов для работы HTTPS
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Копирование временной зоны
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Установка переменных окружения
ENV TZ=UTC \
    APP_ENV=production

# Копирование скомпилированного приложения
COPY --from=builder /go/bin/app /app

# Открытие порта
EXPOSE 8080

# Запуск приложения
ENTRYPOINT ["/app"] 