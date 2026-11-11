@echo off
chcp 65001 >nul
REM Envia o Validador Tributario web para o GitHub (repositorio godimay5-create/validador-web-1).
REM Dois cliques neste arquivo, dentro da pasta do projeto. Precisa do Git instalado: https://git-scm.com
cd /d "%~dp0"

where git >nul 2>nul || (echo Git nao encontrado. Instale em https://git-scm.com e rode de novo. & pause & exit /b 1)

findstr /c:"# validador-web-1" README.md >nul 2>nul || echo # validador-web-1>> README.md

if not exist ".git" git init
git add .
git commit -m "first commit"
git branch -M main
git remote get-url origin >nul 2>nul || git remote add origin https://github.com/godimay5-create/validador-web-1.git
git push -u origin main || (
  echo.
  echo O GitHub recusou o envio. Tentando juntar com o que ja existe no repositorio...
  git pull origin main --allow-unrelated-histories --no-edit && git push -u origin main
)

echo.
echo Pronto. Agora no Vercel: Add New ^> Project ^> Import "validador-web-1" ^> Framework "Other" ^> Deploy.
pause
