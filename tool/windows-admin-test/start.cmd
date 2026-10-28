@echo off
setlocal
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js 22 ontbreekt. Zie LEESMIJ.md.
  pause
  exit /b 1
)
node start.mjs
if errorlevel 1 (
  echo.
  echo Starten is mislukt. Lees de melding hierboven en LEESMIJ.md.
  pause
  exit /b 1
)
