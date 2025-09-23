
# Minimal NES program

Demonstrates a minimal NES program that sets up the PPU and enters an infinite loop.
This is assembled with ca65 and linked with ld65 from the cc65 suite.


Use below make commands.
```bash
# Clean directory
make clean

# Make ROM (Rom will be placed in build directory)
make

# Generate nl file to use debug symbols with FCEUX emulator
make sym
```

By default make will generate `.map` and `.dbg` files. Mesen emulator uses `.dbg` file for debug symbols, use `make sym` command to generate `.nl` file for debug symmbols for FCEUX emulator.