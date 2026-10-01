@echo off
cd /d "%~dp0"
set PYTHONIOENCODING=utf-8
set PYTHONDONTWRITEBYTECODE=1
if not exist ".venv\Scripts\python.exe" (
  echo Windstock Python environment is missing.
  pause
  exit /b 1
)
echo Close any existing Windstock server before launching this one.
".venv\Scripts\python.exe" "src\server\__main__.py"
pause
