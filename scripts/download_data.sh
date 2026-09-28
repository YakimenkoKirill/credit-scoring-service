#!/usr/bin/env bash

set -euo pipefail

COMPETITION="home-credit-default-risk"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RAW_DIR="$ROOT_DIR/data/raw"
ARCHIVE="$RAW_DIR/$COMPETITION.zip"

EXPECTED_FILES=(
  application_train.csv
  application_test.csv
  bureau.csv
  bureau_balance.csv
  POS_CASH_balance.csv
  credit_card_balance.csv
  previous_application.csv
  installments_payments.csv
  HomeCredit_columns_description.csv
  sample_submission.csv
)

err() { echo "ERROR: $*" >&2; exit 1; }

all_files_present() {
  for f in "${EXPECTED_FILES[@]}"; do
    [[ -f "$RAW_DIR/$f" ]] || return 1
  done
}


command -v kaggle >/dev/null 2>&1 || err "Не найден kaggle CLI. Установи: pip install kaggle"
command -v unzip  >/dev/null 2>&1 || err "Не найдена утилита unzip"
[[ -f "$HOME/.kaggle/kaggle.json" || -n "${KAGGLE_USERNAME:-}" ]] \
  || err "Нет ~/.kaggle/kaggle.json и не заданы переменные KAGGLE_USERNAME/KAGGLE_KEY"

mkdir -p "$RAW_DIR"


if all_files_present && [[ "${1:-}" != "--force" ]]; then
  echo "Данные уже на месте. Для повторного скачивания: $0 --force"
  ls -lh "$RAW_DIR"
  exit 0
fi


trap 'rm -f "$ARCHIVE"' EXIT


echo "Скачиваю $COMPETITION в $RAW_DIR ..."
kaggle competitions download -c "$COMPETITION" -p "$RAW_DIR" --force \
  || err "Скачивание не удалось. Проверь, что правила соревнования приняты на Kaggle."


unzip -o -q "$ARCHIVE" -d "$RAW_DIR"
rm -f "$ARCHIVE"


all_files_present || err "Не все ожидаемые файлы найдены в $RAW_DIR"
echo "Все ${#EXPECTED_FILES[@]} файлов на месте."