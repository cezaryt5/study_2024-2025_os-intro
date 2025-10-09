#!/bin/bash

# semaphore.sh - упрощённый механизм семафоров

RESOURCE_LOCK="/tmp/semaphore.lock"
TIME_WAIT=${1:-5}  # время ожидания освобождения ресурса (t1), по умолчанию 5 секунд
TIME_USE=${2:-3}   # время использования ресурса (t2), по умолчанию 3 секунды
PROCESS_NAME=${3:-"Process $$"}  # имя процесса

echo "$PROCESS_NAME: Попытка захвата ресурса..."

# Цикл ожидания освобождения ресурса
attempts=0
while [ -f "$RESOURCE_LOCK" ]; do
    attempts=$((attempts + 1))
    echo "$PROCESS_NAME: Ресурс занят, ожидание... (попытка $attempts)"
    sleep 1
    
    # Если прошло больше времени, чем t1, выходим
    if [ $attempts -gt $TIME_WAIT ]; then
        echo "$PROCESS_NAME: Время ожидания истекло, выход."
        exit 1
    fi
done

# Захватываем ресурс
echo $$ > "$RESOURCE_LOCK"
echo "$PROCESS_NAME: Ресурс захвачен, использование в течение $TIME_USE секунд..."

# Используем ресурс
sleep $TIME_USE

# Освобождаем ресурс
rm -f "$RESOURCE_LOCK"
echo "$PROCESS_NAME: Ресурс освобождён"