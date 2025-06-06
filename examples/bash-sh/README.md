# Сравнение Bash/Sh в разных дистрибутивах Linux

Этот пример демонстрирует различия между оболочками `bash` и `sh` в разных дистрибутивах Linux, которые часто используются как базовые образы в Docker.

## Содержание примера

- Многоступенчатый Dockerfile с различными дистрибутивами:
  - Debian: полноценный bash и GNU-утилиты
  - Alpine: минималистичная система с BusyBox sh (с опционально устанавливаемым bash)
  - BusyBox: ультра-минималистичная система только с BusyBox sh
  - UBI (Red Hat Universal Base Image): корпоративный дистрибутив

- Тестовый скрипт `script.sh`, который демонстрирует:
  - Определение типа оболочки и окружения
  - Различия в синтаксисе между bash и sh
  - Работу с массивами, строками, функциями
  - Типичные проблемы совместимости

## Почему это важно в Docker

При создании Docker-образов важно учитывать различия между оболочками, особенно если:

1. Вы используете Alpine или BusyBox как базовый образ для минимизации размера
2. Ваши скрипты содержат Bash-специфичный синтаксис (bashisms)
3. Вы запускаете скрипты через `/bin/sh` (например, в RUN или CMD)

## Основные различия

| Функция | Debian (bash) | Alpine (sh/bash) | BusyBox (sh) | UBI (bash) |
|---------|---------------|------------------|--------------|------------|
| Массивы | ✅ | ❌ (sh) / ✅ (bash) | ❌ | ✅ |
| `[[` вместо `[` | ✅ | ❌ (sh) / ✅ (bash) | ❌ | ✅ |
| Подстроки `${var:start:len}` | ✅ | ❌ (sh) / ✅ (bash) | ❌ | ✅ |
| Process substitution `<(cmd)` | ✅ | ❌ (sh) / ✅ (bash) | ❌ | ✅ |
| Размер образа | ~115MB | ~5MB | ~1.2MB | ~130MB |

## Запуск примера

Сборка и запуск всех вариантов:

```bash
# Сборка всех образов
docker build -t shell-demo-debian --target debian .
docker build -t shell-demo-alpine --target alpine .
docker build -t shell-demo-busybox --target busybox .
docker build -t shell-demo-ubi --target ubi .

# Запуск образов для сравнения вывода
docker run --rm shell-demo-debian
docker run --rm shell-demo-alpine
docker run --rm shell-demo-busybox
docker run --rm shell-demo-ubi
```

## Рекомендации

1. Если вы используете Alpine или BusyBox, убедитесь, что ваши скрипты совместимы с sh или явно установите bash
2. Явно указывайте интерпретатор в шебанге: `#!/bin/bash` или `#!/bin/sh`
3. Проверяйте скрипты с помощью shellcheck для выявления проблем совместимости
4. Если размер образа не критичен, используйте Debian/Ubuntu для лучшей совместимости 