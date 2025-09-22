; *** 
; *** Import libraries routines to use
; *** 
.import NMIHandler
.import ReadController

;.import UpdateGameLogic, PaletteData, sprites


; ***
; *** Import library exported variables
; ***
    .segment "ZEROPAGE"
.import Frame_Ready
.import controller1, controller1_prev



    .segment "VECTORS"
  .addr nmiProc
  .addr StartProc
  .addr irqProc


    .segment "STARTUP"
;  .org $8000
.include "include/PaletteSprite.s"


    .segment "CHARS"
;MyBinaryData:
.incbin "chars/mario.chr"


    .segment "CODE"

.proc nmiProc
  JSR NMIHandler
  RTI
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
  INX
  STX $2000
  STX $2001
  STX $4010

WaitVBlank:
  BIT $2002
  BPL WaitVBlank


;MainLoop:

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









  ; DMA code to load sprite data in PPU memory
  ;LDA #$00
  ;STA $2003  ; set the low byte (00) of the RAM address
  ;LDA #$02
  ;STA $4014  ; set the high byte (02) of the RAM address, start the transfer

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






.include "macros/CheckButton.s"

LDA #1
STA Frame_Ready

MainLoop:
  LDA Frame_Ready
  BEQ MainLoop
  LDA #0
  STA Frame_Ready

  JSR ReadController
  ; Check A button
  CheckButton #%10000000, A_pressed, A_held, A_released
  ; Check B button
  CheckButton #%01000000, B_pressed, B_held, B_released

  LDA controller1
  STA controller1_prev

  ;JSR UpdateGameLogic
  ;JSR WaitFrame
  JMP MainLoop

A_held:
A_pressed:
  ;
  ;LDA #%00100000   ;intensify blues
  ;STA $2001  
  LDA $0203   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0203   ; save sprite X (horizontal) position

  ;JMP Continue
;A_held:
  ;
  JMP Continue
A_released:
  ;
  ;LDA #%10000000   ;intensify blues
  ;STA $2001    

  JMP Continue  

B_held:
B_pressed:
  ;
  LDA $0203   ; load sprite position
  SEC         ; make sure carry flag is set
  SBC #$01    ; A = A - 1
  STA $0203   ; save sprite position

  ;JMP Continue
;B_held:
  ;
  JMP Continue
B_released:
  ;
  JMP Continue  

Continue:
  ; Continue Mainloop
  JMP MainLoop


.endproc


.include "include/Header.s"
