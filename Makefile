# Works on Linux/macOS (gcc) and Windows (MinGW-w64 / MSYS2: mingw32-make).
# On Windows you can also just run build.bat from the project folder.
CC     ?= gcc
CFLAGS  = -std=c11 -Wall -Wextra -O2 -D_DEFAULT_SOURCE
SRC     = algorithms.c wasm_api.c

ifeq ($(OS),Windows_NT)
  EXE = .exe
  LIB = io_pulse.dll
  PIC =
else
  EXE =
  LIB = libio_pulse.so
  PIC = -fPIC
endif

all: io_pulse_cli$(EXE) $(LIB)

io_pulse_cli$(EXE): $(SRC) main.c
	$(CC) $(CFLAGS) $(SRC) main.c -o $@

$(LIB): $(SRC)
	$(CC) $(CFLAGS) $(PIC) -shared $(SRC) -o $@

native: io_pulse_cli$(EXE)
	./io_pulse_cli$(EXE) --demo

test: test_algorithms$(EXE)
	./test_algorithms$(EXE)

test_algorithms$(EXE): $(SRC) test_algorithms.c
	$(CC) $(CFLAGS) $(SRC) test_algorithms.c -o $@

# Optional: needs Emscripten (emcc). Not required for the normal run.
wasm:
	emcc -std=c11 -O2 algorithms.c wasm_api.c -o ../frontend/io_pulse.js -s MODULARIZE=1 -s EXPORT_NAME=IO_PulseModule \
	  -s EXPORTED_FUNCTIONS=_io_pulse_run,_io_pulse_free -s EXPORTED_RUNTIME_METHODS=ccall,UTF8ToString

clean:
	rm -f io_pulse_cli io_pulse_cli.exe libio_pulse.so io_pulse.dll test_algorithms test_algorithms.exe

.PHONY: all native test wasm clean
