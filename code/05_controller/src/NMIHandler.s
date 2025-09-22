.export NMIHandler

; Make Sure "Frame_Ready" is included in ZeroPage like below
    .segment "ZEROPAGE"
.export Frame_Ready
.export NTINDEX                     ; Used for background scrolling bit flip

Frame_Ready:          .res 1
SCROLL:               .res 1        ; Used for background scrolling - counter
NTINDEX:              .res 1        ; Used for background scrolling bit flip

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




  ; *
  ; * Background scrolling start
  ; *
  LDA #$00      
  STA $2006     ; Cleanup PPU register address
  STA $2006

  INC SCROLL

NTcheck:
  LDA SCROLL
  BNE NTcheckDone

  LDA NTINDEX
  EOR #$01
  STA NTINDEX

NTcheckDone:
  LDA #$00      
  STA $2006     ; Cleanup PPU register address
  STA $2006

;  INC SCROLL
  LDA SCROLL

  STA $2005     ; Scroll X axis
  LDA #$00
  STA $2005     ; Scroll Y axis
  ; *
  ; * Background scrolling end
  ; *



  INC Frame_Ready     ; Enable Flag so MainLoop can run (GameLogic)
  RTS
