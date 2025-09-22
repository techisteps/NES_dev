.segment "ZEROPAGE"
controller1:          .res 1
controller1_prev:     .res 1


.segment "VECTORS"
  .addr nmiProc
  .addr StartProc
  .addr irqProc


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



.macro CheckButton buttonMask, labelPressed, labelHeld, labelReleased
  ; Check if button is currently pressed
  LDA controller1
  AND buttonMask
  BEQ :+

  ; Check if it was already pressed last frame
  LDA controller1_prev
  AND buttonMask
  BNE labelHeld                 ; if yes, it's being held
  JMP labelPressed              ; if no, it's a new press

: ; Check if it was released
  LDA controller1_prev
  AND buttonMask
  BEQ :+                        ; if not pressed before, skip
  JMP labelReleased             ; if was released

: ; Nothing happened
.endmacro

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

  LDA #%10000000
  STA $2000
  LDA #%00011110
  STA $2001

MainLoop:

  ; Save previous state
  JSR ReadController
  ; Check A button
  CheckButton #%10000000, A_pressed, A_held, A_released
  ; Check B button
  CheckButton #$02, B_pressed, B_held, B_released




  JMP MainLoop

A_pressed:
  ;
  ;LDA #%00100000   ;intensify blues
  ;STA $2001  
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006
  LDA #$15
  STA $2007

  JMP Continue
A_held:
  ;
  JMP Continue
A_released:
  ;
  ;LDA #%00000000   ;intensify blues
  ;STA $2001    
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006
  LDA #$01
  STA $2007

  JMP Continue  

B_pressed:
  ;
  JMP Continue
B_held:
  ;
  JMP Continue
B_released:
  ;
  JMP Continue  

Continue:
  ; Continue Mainloop
  JMP MainLoop




ReadController:
  ; Strobe the controller to latch button states
  LDA #$01
  STA $4016
  STA controller1
  LSR A
  STA $4016  

ReadLoop:
  LDA $4016
  LSR A
  ROL controller1       ; Shift into controller1 (bit 0 = A, bit 1 = B, etc.)
  BCC ReadLoop
  RTS



.endproc


.segment "HEADER"
  .byte "NES", $1A    
;  .byte $4E, $45, $53, $1A  ; iNES header identifier
  .byte 2                   ; 2x 16KB PRG-ROM Banks
  .byte 1                   ; 1x  8KB CHR-ROM
  .byte $01, $00            ; mapper 0, vertical mirroring