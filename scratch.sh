#!/bin/bash
# Задаем входную и выходную директории из переданных аргументов
input_directory=$1
output_directory=$2
if [ ! -d "$output_directory" ]; then # Проверяем, существует ли выходная директория, и если нет, то создаем ее
    mkdir -p "$output_directory"
fi
copy_and_rename_files() { # Функция для копирования и переименования файлов
    local src_dir="$1"
    local dest_dir="$2"
    local files=("$src_dir"/*)
    for file in "${files[@]}"; do # Перебираем файлы в исходной директории
        if [ -d "$file" ]; then # Если это директория, рекурсивно вызываем функцию для копирования вложенных файлов
            copy_and_rename_files "$file" "$dest_dir"
        elif [ -f "$file" ]; then # Если это файл, определяем его имя и путь в выходной директории
            filename=$(basename -- "$file")
            dest_file="$dest_dir/${filename}"
            if [ -f "$dest_file" ]; then # Если файл с таким именем уже существует, добавляем числовой суффикс к имени
                i=1
                while [ -f "$dest_dir/($i) ${filename}" ]; do
                    ((i++))
                done
                cp "$file" "$dest_dir/($i) ${filename} "
            else # Иначе просто копируем файл
                cp "$file" "$dest_file"
            fi
        fi
    done
}
copy_and_rename_files "$input_directory" "$output_directory" # Вызов функции с передачей входной и выходной директорий
