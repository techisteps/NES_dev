.segment "VECTORS"
  .addr 0
  .addr StartProc
  .addr 0


.segment "STARTUP"
;  .org $8000

.segment "CHARS"
MyBinaryData:
  .incbin "mario.chr"


.segment "CODE"

.proc nmiProc
  bit $2002
  lda #0
  sta $2006
  sta $2006
  rti
.endproc

.proc irqProc
  rti
.endproc

.proc StartProc
Start:
  SEI               ; Disable interrupts
  CLD               ; Clear decimal mode
  LDX #$40
  STX $4017         ; Disable APU frame IRQ
  LDX #$FF
  TXS               ; Set stack pointer

WaitVBlank:
  BIT $2002
  BPL WaitVBlank

MainLoop:
  lda #$01
  ldx #$02
  inx
  LDA #%00100000   ;intensify blues
  STA $2001  
  JMP MainLoop
.endproc


.segment "HEADER"
  .byte "NES", $1A    
;  .byte $4E, $45, $53, $1A  ; iNES header identifier
  .byte 2                   ; 2x 16KB PRG-ROM Banks
  .byte 1                   ; 1x  8KB CHR-ROM
  .byte $01, $00            ; mapper 0, vertical mirroring