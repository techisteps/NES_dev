; *** 
; *** Import libraries routines to use
; *** 
;.import NMIHandler
;.import ReadController
;.import LoadGraphics

.include "include/Header.inc"
.include "include/globals.inc"


;.import UpdateGameLogic, PaletteData, sprites



    .segment "ZEROPAGE"




    .segment "VECTORS"
.addr nmiProc
.addr StartProc
.addr irqProc
;;;;;


    .segment "STARTUP"
;  .org $8000
;.include "include/PaletteSprite.s"
;;;;;


    .segment "CHARS"
;MyBinaryData:
.incbin "chars/mario.chr"
;.incbin "chars/NewFile.chr"
;;;;;


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
  TXS               ; Set stack pointer to $01FF, $01 is implied in high byte
  INX
  STX $2000         ; Write 0 to PPUCTRL, set base nametable to $2000
                    ; Bit 7 = NMI enable ( 0 = Disable)
                    ; Bit 0-1 base nametable address (00 = $2000)
  
  STX $2001         ; Write 0 to PPUMASK, disable rendering
                    ; Bit 3 = Show background, Bit 4 show sprite, ALL bits 0 rendering off

  STX $4010         ; Write 0 to APU framecounter, disable IRQ from APU
                    ; This is for sound system, but also affects timing


JSR ClearRAM        ; This reoutine do not clean stack page from $0100-$01FF, 
                    ; if you want to clean stack as well do not use routine clear is inline 
                    ; If you clear stack routine pointer will get lost and routine will not work
;ClearRAM:
;  ldx #$00
;ClearLoop:
;  lda #$00
;  sta $0000,x
;  sta $0100,x
;  sta $0200,x
;  sta $0300,x
;  sta $0400,x
;  sta $0500,x
;  sta $0600,x
;  sta $0700,x
;  INX
;  bne ClearLoop


JSR WaitVBlank      ; Make sure PPU is up and running for first time after boot
;WaitVBlank:
;  BIT $2002
;  BPL WaitVBlank



JSR LoadGraphics    ; At the moment load it before main loop later load graphics based on game logic

;MainLoop:


.include "include/CheckButton.inc"

; ***
; *** Flag to check if NMI should run or MainLoop
; ***
LDA #1              
STA Frame_Ready
;;;;;


; ***
; *** MainLoop
; ***
MainLoop:
  LDA Frame_Ready
  BEQ MainLoop
  LDA #0
  STA Frame_Ready


; ***
; *** Read Controller and call actions
; ***  
  JSR ReadController
  ; Check A button
  CheckButton ABUT,#%10000000, A_pressed, A_held, A_released
  ; Check B button
  CheckButton BBUT,#%01000000, B_pressed, B_held, B_released

  LDA controller1
  STA controller1_prev
;;;;;


; ***
; *** Enable rendering
; ***
  LDA #%10010000 ;enable NMI, sprites from Pattern 0, background from Pattern 1
;       ---- ----
;       VPHBSINN
;       ||||||||
;       ||||||++- Base nametable address
;       ||||||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
;       |||||+--- VRAM address increment per CPU read/write of PPUDATA
;       |||||     (0: add 1, going across; 1: add 32, going down)
;       ||||+---- Sprite pattern table address for 8x8 sprites
;       ||||      (0: $0000; 1: $1000; ignored in 8x16 mode)
;       |||+------ Background pattern table address (0: $0000; 1: $1000)
;       ||+------- Sprite size (0: 8x8 pixels; 1: 8x16 pixels – see PPU OAM#Byte 1)
;       |+-------- PPU master/slave select
;       |          (0: read backdrop from EXT pins; 1: output color on EXT pins)
;       +--------- Vblank NMI enable (0: off, 1: on)
  STA $2000

  LDA #%11111110 ; enable sprites, enable background
;       --------
;       BGRsbMmG
;       ||||||||
;       |||||||+- Greyscale (0: normal color, 1: greyscale)
;       ||||||+-- 1: Show background in leftmost 8 pixels of screen, 0: Hide
;       |||||+--- 1: Show sprites in leftmost 8 pixels of screen, 0: Hide
;       ||||+---- 1: Enable background rendering
;       |||+------ 1: Enable sprite rendering
;       ||+------- Emphasize red (green on PAL/Dendy)
;       |+-------- Emphasize green (red on PAL/Dendy)
;       +--------- Emphasize blue
  STA $2001
;;;;;


  ;JSR UpdateGameLogic
  ;JSR WaitFrame
  JMP MainLoop




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
  JMP MainLoop


.endproc



