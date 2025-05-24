#!/usr/bin/env sh
# Этот скрипт демонстрирует различия между bash и sh на разных дистрибутивах Linux

# Определение оболочки
echo "======================================================"
echo "Shell Detection and Environment"
echo "======================================================"
echo "Current shell: $0"
echo "SHELL env var: $SHELL"

# Проверка, запущен ли скрипт в bash
if [ -n "$BASH_VERSION" ]; then
    echo "Running in Bash version: $BASH_VERSION"
elif [ -n "$ZSH_VERSION" ]; then
    echo "Running in Zsh version: $ZSH_VERSION"
else
    echo "Running in plain sh (not Bash or Zsh)"
fi

# Проверка наличия типичных команд для определения дистрибутива
if command -v apt-get >/dev/null 2>&1; then
    echo "Debian/Ubuntu based system detected"
elif command -v apk >/dev/null 2>&1; then
    echo "Alpine Linux detected"
elif command -v microdnf >/dev/null 2>&1; then
    echo "Red Hat UBI detected"
elif command -v busybox >/dev/null 2>&1; then
    echo "BusyBox detected"
else
    echo "Unknown distribution"
fi

echo "\nSystem information:"
uname -a 2>/dev/null || echo "uname command not available"

echo "\n======================================================"
echo "Bash vs Sh Features Test"
echo "======================================================"

# Проверка наличия массивов (работает только в bash)
echo "\n1. Arrays support test:"
if [ -n "$BASH_VERSION" ]; then
    echo "  Arrays test (bash):"
    arr=("apple" "banana" "cherry")
    echo "  Array elements: ${arr[0]}, ${arr[1]}, ${arr[2]}"
else
    echo "  Arrays not supported in plain sh"
fi

# Проверка поддержки функций
echo "\n2. Function support test:"
echo "  Defining a simple function..."

test_function() {
    echo "  Function executed successfully"
    return 0
}

test_function

# Проверка поддержки строковых операций
echo "\n3. String operations test:"
test_string="Hello Docker World"
echo "  Original string: $test_string"
echo "  String length: ${#test_string}"

# В bash можно использовать подстроки
if [ -n "$BASH_VERSION" ]; then
    echo "  Substring (bash): ${test_string:6:6}"
else
    # В sh используем cut
    echo "  Substring (sh using cut): $(echo "$test_string" | cut -d ' ' -f 2)"
fi

# Проверка обработки ошибок
echo "\n4. Error handling test:"
(
    # Подавляем вывод ошибки
    set -e 2>/dev/null || echo "  set -e not supported (common in Bash)"
    echo "  Error handling enabled with set -e"
) || echo "  Error handling with set -e failed"

echo "\n======================================================"
echo "Compatibility Issues"
echo "======================================================"

# Демонстрация проблем совместимости с /bin/sh
echo "\n1. Bashisms that fail in plain sh:"

# Например, использование [[ ]] вместо [ ]
if [ -n "$BASH_VERSION" ]; then
    echo "  Using [[ ]] test (bash): [[ 'a' == 'a' ]] -> OK"
else
    echo "  Using [ ] test (sh): [ 'a' = 'a' ] -> OK"
    echo "  Note: [[ ]] syntax would fail in plain sh"
fi

echo "\nScript completed successfully!" 