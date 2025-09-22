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