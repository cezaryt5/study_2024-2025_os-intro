#!/bin/bash

# myman.sh - реализация команды man

COMMAND=$1

if [ -z "$COMMAND" ]; then
    echo "Использование: $0 <команда>"
    echo "Пример: $0 ls"
    exit 1
fi

# Проверяем наличие справки в /usr/share/man/man1/
MANPAGE="/usr/share/man/man1/$COMMAND.1.gz"

if [ -f "$MANPAGE" ]; then
    echo "Найдена справка для команды: $COMMAND"
    echo "=========================================="
    zcat "$MANPAGE" | less
elif [ -f "/usr/share/man/man1/$COMMAND.1" ]; then
    MANPAGE="/usr/share/man/man1/$COMMAND.1"
    echo "Найдена справка для команды: $COMMAND"
    echo "=========================================="
    cat "$MANPAGE" | less
else
    # Проверяем другие разделы man, если не нашли в man1
    for section in {2..8}; do
        if [ -f "/usr/share/man/man$section/$COMMAND.$section.gz" ]; then
            MANPAGE="/usr/share/man$section/$COMMAND.$section.gz"
            echo "Найдена справка для команды: $COMMAND (раздел $section)"
            echo "=================================================="
            zcat "$MANPAGE" | less
            exit 0
        elif [ -f "/usr/share/man/man$section/$COMMAND.$section" ]; then
            MANPAGE="/usr/share/man/man$section/$COMMAND.$section"
            echo "Найдена справка для команды: $COMMAND (раздел $section)"
            echo "=================================================="
            cat "$MANPAGE" | less
            exit 0
        fi
    done
    
    # Если не найдено нигде
    echo "Справка для команды '$COMMAND' не найдена."
    exit 1
fi