.export NMIHandler


; Make Sure "Frame_Ready" is included in ZeroPage like below
    .segment "ZEROPAGE"
.export Frame_Ready
Frame_Ready:          .res 1

.segment "CODE"
NMIHandler:
  ;bit $2002
  ;lda #0
  ;sta $2006
  ;sta $2006


  ; *
  ; * DMA code
  ; *
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

  INC Frame_Ready     ; Enable Flag so MainLoop can run (GameLogic)
  RTS
