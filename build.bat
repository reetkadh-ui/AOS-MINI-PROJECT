@echo off
REM Builds the C engine on Windows (needs MinGW-w64 gcc). Optional: without gcc, run.bat uses the Python engine.
setlocal
pushd "%~dp0backend"
where gcc >nul 2>nul
if errorlevel 1 (
  echo [build] gcc not found - skipping C build ^(Python engine will be used^).
  popd
  exit /b 1
)
gcc -std=c11 -O2 -shared algorithms.c wasm_api.c -o io_pulse.dll || ( popd & exit /b 1 )
gcc -std=c11 -O2 algorithms.c wasm_api.c main.c -o io_pulse_cli.exe || ( popd & exit /b 1 )
gcc -std=c11 -O2 algorithms.c wasm_api.c test_algorithms.c -o test_algorithms.exe || ( popd & exit /b 1 )
echo [build] C engine built: io_pulse.dll, io_pulse_cli.exe
popd
exit /b 0
