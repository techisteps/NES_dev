.export UpdateGameLogic, PaletteData, sprites

.segment "STARTUP"
;  .org $8000

PaletteData:
  .byte $0F,$31,$32,$33,$0F,$35,$36,$37,$0F,$39,$3A,$3B,$0F,$3D,$3E,$0F  ;background palette data
  .byte $0F,$1C,$15,$14,$0F,$02,$38,$3C,$0F,$1C,$15,$14,$0F,$02,$38,$3C  ;sprite palette
sprites:
     ;vert tile attr horiz
  .byte $80, $32, $00, $80   ;sprite 0
  .byte $80, $33, $00, $88   ;sprite 1
  .byte $88, $34, $00, $80   ;sprite 2
  .byte $88, $35, $00, $88   ;sprite 3



.segment "CODE"

UpdateGameLogic:
  ; DMA code to load sprite data in PPU memory
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

  ; Setup sprite data
  LDA #$80
  STA $0200        ;put sprite 0 in center ($80) of screen vertically
  STA $0203        ;put sprite 0 in center ($80) of screen horizontally
  LDA #$00
  STA $0201        ;tile number = 0
  STA $0202        ;color palette = 0, no flipping

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000

  LDA #%00010000   ; no intensify (black background), enable sprites
  STA $2001

  RTS
