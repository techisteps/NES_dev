.export WaitVBlank

WaitVBlank:
  BIT $2002
  BPL WaitVBlank
  RTS