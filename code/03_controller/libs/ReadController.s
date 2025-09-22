.export ReadController


; Make sure below variable are defined in ZEROPAGE as shown below
    .segment "ZEROPAGE"
.export controller1, controller1_prev
controller1:          .res 1
controller1_prev:     .res 1


.segment "CODE"

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

