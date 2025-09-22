.export WaitVBlank, ClearRAM

WaitVBlank:
  BIT $2002
  BPL WaitVBlank
  RTS



ClearRAM:
  ldx #$00
ClearLoop:
  lda #$00
  sta $0000,x
  ;sta $0100,x
  sta $0200,x
  sta $0300,x
  sta $0400,x
  sta $0500,x
  sta $0600,x
  sta $0700,x
  INX
  bne ClearLoop
  RTS