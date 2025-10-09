#!/bin/bash

# random_seq.sh - генератор случайной последовательности букв

LENGTH=${1:-10}  # длина последовательности, по умолчанию 10

generate_random_char() {
    # Генерируем случайное число и преобразуем в букву
    # $RANDOM возвращает число от 0 до 32767
    # Для получения буквы используем остаток от деления на 26
    local random_num=$((RANDOM % 26))
    local char=$(printf "\\$(printf '%03o' $((97 + random_num)))")
    echo -n "$char"
}

generate_random_sequence() {
    local len=$1
    local sequence=""
    
    for ((i = 0; i < len; i++)); do
        sequence="${sequence}$(generate_random_char)"
    done
    
    echo "$sequence"
}

echo "Генерация случайной последовательности из $LENGTH букв:"
result=$(generate_random_sequence $LENGTH)
echo "$result"

# Дополнительно: генерация последовательности в верхнем регистре
echo "Та же последовательность верхнем регистре:"
echo "$result" | tr '[:lower:]' '[:upper:]'