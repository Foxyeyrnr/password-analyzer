#!/usr/bin/env bash
# ==============================================================================
# ЭТАП 1 (01.11 – 15.11)
# Базовый анализ (длина, типы символов, простые последовательности)
# Контрольная точка: скрипт выдаёт оценку стойкости (СЛАБЫЙ/СРЕДНИЙ/СИЛЬНЫЙ).
# ==============================================================================

analyze_strength() {
  local pwd="$1"
  local length="${#pwd}"
  local has_upper=0 has_lower=0 has_digit=0 has_special=0 seq_found=0

  # Проверка наличия символов
  [[ "$pwd" =~ [A-Z] ]] && has_upper=1
  [[ "$pwd" =~ [a-z] ]] && has_lower=1
  [[ "$pwd" =~ [0-9] ]] && has_digit=1
  [[ "$pwd" =~ [^a-zA-Z0-9] ]] && has_special=1

  # Поиск простых последовательностей
  if echo "$pwd" | grep -qiE '123|abc|qwerty|password'; then
    seq_found=1
  fi

  # Подсчёт баллов
  local score=0
  if (( length >= 8 ));  then (( score += 2 )) || true; fi
  if (( length >= 12 )); then (( score += 2 )) || true; fi
  (( score += has_upper + has_lower + has_digit + has_special )) || true
  if (( seq_found == 1 )); then (( score -= 2 )) || true; fi

  if (( score <= 3 )); then
    echo "СЛАБЫЙ"
  elif (( score <= 5 )); then
    echo "СРЕДНИЙ"
  else
    echo "СИЛЬНЫЙ"
  fi
}

usage() {
  cat <<EOF
Usage: $0 <password>

Пример: $0 "Cat123!"
EOF
  exit 1
}

if [[ $# -ne 1 ]]; then
  usage
fi

PASSWORD="$1"
STRENGTH="$(analyze_strength "$PASSWORD")"

echo "=== Анализ пароля (MiniPass CLI, этап 1) ==="
echo "Исходный пароль: $PASSWORD"
echo "Стойкость: $STRENGTH"
echo ""
echo "Примечание: учебный прототип. Не для реальных паролей."
