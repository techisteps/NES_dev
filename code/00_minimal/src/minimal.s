;** Minimal NES program
;** Demonstrates a minimal NES program that sets up the PPU and enters an infinite loop
;** Assembled with ca65 and linked with ld65 from the cc65 suite


;** iNES Header, see https://www.nesdev.org/wiki/INES
.segment "HEADER"
  .byte "NES", $1A
;  .byte $4E, $45, $53, $1A   ; iNES header identifier
  .byte 2                     ; 2x 16KB PRG-ROM Banks
  .byte 1                     ; 1x  8KB CHR-ROM
  .byte $01                   ; FLAG 6: mapper 0, horizontal mirroring
  .byte $00                   ; FLAG 7: 
  .byte $01                   ; FLAG 8: 1x 8KB PRG-RAM 
  .byte $01                   ; FLAG 9: TV system (0: NTSC; 1: PAL)
  .byte $10                   ; FLAG 10: TV system, PRG-RAM presence
  .byte $00                   ; unused, should be zero
  .byte $00                   ; unused, should be zero
  .byte $00                   ; unused, should be zero
  .byte $00                   ; unused, should be zero
  .byte $00                   ; unused, should be zero


;** Vectors
;** NMI vector at $FFFA
;** Reset vector at $FFFC
;** IRQ/BRK vector at $FFFE
;** Note: Vectors must be at the end of the ROM, check your linker config!
;** See https://www.nesdev.org/wiki/CPU_memory_map#F000-EFFF_.28Cartridge_space.29
.segment "VECTORS"
  .addr nmiProc
  .addr StartProc
  .addr 0


.segment "STARTUP"


.segment "CHARS"
  .incbin "chars/kaboom.chr"


.segment "CODE"

;** NMI Handler
;** Called at the start of the vertical blanking interval
;** Here we just reset the PPU address to $0000
;** In a real program, you would update the PPU memory here
;** See https://www.nesdev.org/wiki/PPU_registers
.proc nmiProc
  bit $2002
  lda #0
  sta $2006
  sta $2006
  rti
.endproc


;** IRQ/BRK Handler
;** Not used in this minimal example
;* Just return from interrupt
;* See https://www.nesdev.org/wiki/CPU_interrupts
;* Note: If you enable IRQs in the APU, you must handle them here otherwise the program will crash
;* See https://www.nesdev.org/wiki/APU
;* In this example, we disable APU frame IRQs in StartProc
;* so this handler is not called but we still need to define it
.proc irqProc
  rti
.endproc


;** Reset Handler
;** Called on power-up or reset
;** Here we initialize the stack, disable interrupts, and enter the main loop
;** See https://www.nesdev.org/wiki/CPU_power_up_state
.proc StartProc
Start:
  SEI               ; Disable interrupts
  CLD               ; Clear decimal mode
  LDX #$40          ; Set up stack pointer
  STX $4017         ; Disable APU frame IRQ
  LDX #$FF          ; To set stack pointer to $FF
  TXS               ; Set stack pointer


;** Wait for the PPU to be ready, we wait for the start of the vertical blanking interval
;** by polling the VBlank flag in PPUSTATUS ($2002)
;** See https://www.nesdev.org/wiki/PPU_registers#PPUSTATUS
;** This is important because we should not write to PPU memory while the PPU is rendering
;** In a real program, you would typically wait for VBlank before updating the PPU
;** Here we just wait once at startup
;** See https://www.nesdev.org/wiki/PPU_registers#Vblank_flag
;** In a real program, you would typically enable NMI in $2000 and handle it in nmiProc
;** See https://www.nesdev.org/wiki/PPU_registers#PPUCTRL
WaitVBlank:
  BIT $2002
  BPL WaitVBlank


;*** Main Loop
;** Here we just enter an infinite loop
;** In a real program, you would update game logic and PPU memory here
;** For demonstration, we set the PPU mask to intensify RGB all three channels
;** See https://www.nesdev.org/wiki/PPU_registers#PPUMASK
;** In a real program, you would typically set this once at startup
;** and not in the main loop
;** This is just for demonstration purposes
MainLoop:
  lda #$01            ; Random operation to have something in the loop
  ldx #$02            ; Random operation to have something in the loop 
  inx                 ; Random operation to have something in the loop
  LDA #%11111000      ; Intensify RGB channels and show sprites and background
                      ; This may work differently on different emulators as default 
                      ; palette is not defined and set some default values
                      ; Check with Mesen and FCEUX
  STA $2001           ; Set PPU mask register
  JMP MainLoop        ; Infinite loop

.endproc

