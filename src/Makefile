CC = gcc
CFLAGS = -Wall `idris --include` `pkg-config --cflags SDL2_gfx`

sdl2.o: config sdl2.c sdl2.h

config: .PHONY
	echo "%flag C \"`pkg-config --libs SDL2`\"" > Graphics/Config.idr
	echo "%flag C \"`pkg-config --cflags SDL2`\"" >> Graphics/Config.idr
	echo "%flag C \"`pkg-config --libs SDL2_gfx`\"" > Graphics/Config.idr
	echo "%flag C \"`pkg-config --cflags SDL2_gfx`\"" >> Graphics/Config.idr

clean: .PHONY
	rm sdl2.o

.PHONY:
