.ifndef __CONTROLLER_DRIVER__
__CONTROLLER_DRIVER__ = 1

;.include "include/globals.inc"
.export ActController

.include "include/CheckButton.inc"

ActController:
  ; Check A button
  CheckButton ABUT,#%10000000, A_pressed, A_held, A_released
  ; Check B button
  CheckButton BBUT,#%01000000, B_pressed, B_held, B_released


; ***
; *** Controller Driver
; ***
A_held:
A_pressed:

  JSR action_MaveForward
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
  JSR action_MaveBackward
  ;JMP Continue
;B_held:
  ;
  JMP Continue
B_released:
  ;
  JMP Continue  

Continue:
  ; Continue Mainloop
  ; JMP MainLoop

RTS

.endif