.export LoadGraphics

;.include "../globals.inc"

    .segment "STARTUP"
;;  .org $8000
;.include "include/PaletteSprite.s"
PaletteData:
  .byte $0f,$00,$10,$30,$0f,$01,$21,$31,$0f,$06,$16,$26,$0f,$09,$19,$29  ;background palette data
  .byte $0F,$1C,$2B,$39,$0F,$06,$15,$36,$0A,$05,$26,$30,$22,$16,$27,$18  ;sprite palette

sprites:
     ;vert tile attr horiz
  .byte $80, $00, $11, $80   ;sprite 0
  .byte $80, $01, $11, $88   ;sprite 1
  .byte $88, $02, $11, $80   ;sprite 2
  .byte $88, $03, $11, $88   ;sprite 3
  .byte $92, $04, $11, $92   ;sprite 0
  .byte $92, $05, $11, $96   ;sprite 1
  .byte $96, $06, $11, $92   ;sprite 2
  .byte $96, $07, $11, $96   ;sprite 3  


background01:
.incbin "chars/background01.nam"
background_end01:
background02:
.incbin "chars/background02.nam"
background_end02:




attribute:
  ;.byte %00000000, %00010000, %01010000, %00010000, %00000000, %00000000, %00000000, %00110000
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;
;palette:
;  .byte $0F,$17,$28,$39,$0F,$30,$26,$05,$0F,$20,$10,$00,$0F,$13,$23,$33  ;background palette data













    .segment "CODE"

LoadGraphics:

  LDA #$00
  STX $2001         ; Write 0 to PPUMASK, disable rendering
                    ; Bit 3 = Show background, Bit 4 show sprite, ALL bits 0 rendering off


  LDA $2002    ; read PPU status to reset the high/low latch to high
  LDA #$3F
  STA $2006    ; write the high byte of $3F10 address
  LDA #$10
  STA $2006    ; write the low byte of $3F10 address

  ; Populate PaletteData
  LDX #$00                ; start out at 0
LoadPalettesLoop:
  LDA PaletteData, x      ; load data from address (PaletteData + the value in x)
                          ; 1st time through loop it will load PaletteData+0
                          ; 2nd time through loop it will load PaletteData+1
                          ; 3rd time through loop it will load PaletteData+2
                          ; etc
  STA $2007               ; write to PPU
  INX                     ; X = X + 1
  CPX #$20                ; Compare X to hex $20, decimal 32
  BNE LoadPalettesLoop    ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                          ; if compare was equal to 32, keep going down
; Populate Sprites
LoadSprites:
  LDX #$00              ; start at 0
LoadSpritesLoop:
  LDA sprites, x        ; load data from address (sprites + x)
  STA $0200, x          ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$10              ; Compare X to hex $10, decimal 16
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 16, continue down

; *** 
; *** OPTION 1
; *** 
;  LDA $2002             ; read PPU status to reset the high/low latch
;  LDA #$20
;  STA $2006             ; write the high byte of $2000 address
;  LDA #$00
;  STA $2006             ; write the low byte of $2000 address
;LoadBackgroundLoop:
;  LDA background, x     ; load data from address (background + the value in x)
;  STA $2007             ; write to PPU
;  INX                   ; X = X + 1
;  CPX #$80              ; Compare X to hex $80, decimal 128 - copying 128 bytes
;  BNE LoadBackgroundLoop  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero
;                        ; if compare was equal to 128, keep going down
;
;
;
;LoadAttribute:
;  LDA $2002             ; read PPU status to reset the high/low latch
;  LDA #$23
;  STA $2006             ; write the high byte of $23C0 address
;  LDA #$C0
;  STA $2006             ; write the low byte of $23C0 address
;
;  LDX #$00              ; start out at 0
;LoadAttributeLoop:
;  LDA attribute, x      ; load data from address (attribute + the value in x)
;  STA $2007             ; write to PPU
;  INX                   ; X = X + 1
;  CPX #$80              ; Compare X to hex $08, decimal 8 - copying 8 bytes
;  BNE LoadAttributeLoop







; *** 
; *** OPTION 2
; *** Load first table
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address

background_ptr_lo = $00
background_ptr_hi = $01

LDA #<background01
STA background_ptr_lo
LDA #>background01
STA background_ptr_hi

LDY #$00
BGLOOP01:
  LDA (background_ptr_lo), Y
  STA $2007

  INY
  BNE BGLOOP01

  INC background_ptr_hi
  LDA background_ptr_hi
  CMP #>background_end01
  BNE BGLOOP01  

; *** 
; *** OPTION 2
; *** Load second table
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$24
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address

;background_ptr_lo = $00
;background_ptr_hi = $01

LDA #<background02
STA background_ptr_lo
LDA #>background02
STA background_ptr_hi

LDY #$00
BGLOOP02:
  LDA (background_ptr_lo), Y
  STA $2007

  INY
  BNE BGLOOP02

  INC background_ptr_hi
  LDA background_ptr_hi
  CMP #>background_end02
  BNE BGLOOP02    

    RTS
