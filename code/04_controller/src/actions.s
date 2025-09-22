.export action_MaveForward, action_MaveBackward

action_MaveForward:
    LDX #$00
:
  LDA $0203,X   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0203,X   ; save sprite X (horizontal) position
  INX
  INX
  INX
  INX
  CPX #$10
  BNE :-
  RTS



  LDA $0203   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0203   ; save sprite X (horizontal) position

  LDA $0207   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0207   ; save sprite X (horizontal) position

  LDA $020B   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $020B   ; save sprite X (horizontal) position  

  LDA $020F   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $020F   ; save sprite X (horizontal) position  

RTS

action_MaveBackward:

  LDA $0203   ; load sprite position
  SEC         ; make sure carry flag is set
  SBC #$01    ; A = A - 1
  STA $0203   ; save sprite position

  LDA $0207   ; load sprite position
  SEC         ; make sure carry flag is set
  SBC #$01    ; A = A - 1
  STA $0207   ; save sprite position  

  LDA $020B   ; load sprite position
  SEC         ; make sure carry flag is set
  SBC #$01    ; A = A - 1
  STA $020B   ; save sprite position    

  LDA $020F   ; load sprite position
  SEC         ; make sure carry flag is set
  SBC #$01    ; A = A - 1
  STA $020F   ; save sprite position    

RTS