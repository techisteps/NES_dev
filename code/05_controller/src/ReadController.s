.export ReadController


; Make sure below variable are defined in ZEROPAGE as shown below
    .segment "ZEROPAGE"
.export controller1, controller1_prev
controller1:          .res 1
controllerT:          .res 1
controller1_prev:     .res 1


.segment "CODE"

ReadController:
  ; Strobe the controller to latch button states
  LDA #$01
  STA $4016
  STA controllerT
  LSR A
  STA $4016  

ReadLoop:
  LDA $4016
  LSR A
  ROL controllerT       ; Shift into controllerT (bit 0 = A, bit 1 = B, etc.)
  BCC ReadLoop
  LDA controllerT
  STA controller1
  RTS

