#!/usr/bin/env bash
# Envia o Validador Tributário web para o GitHub (godimay5-create/validador-web-1). Rode dentro da pasta do projeto.
set -e
cd "$(dirname "$0")"
grep -q "# validador-web-1" README.md || echo "# validador-web-1" >> README.md
[ -d .git ] || git init
git add .
git commit -m "first commit"
git branch -M main
git remote get-url origin >/dev/null 2>&1 || git remote add origin https://github.com/godimay5-create/validador-web-1.git
git push -u origin main || { git pull origin main --allow-unrelated-histories --no-edit && git push -u origin main; }
