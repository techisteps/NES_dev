.export LoadGraphics


    .segment "STARTUP"
PaletteData:
  .incbin "chars/kaboom.pal"          ;background palette data
  .incbin "chars/kaboom_sprite.pal"   ;sprite palette  


background01:
.incbin "chars/kaboom.nam"
background_end01:




    .segment "CODE"

LoadGraphics:

  ;;; Load palette data into PPU memory

  ;** Disable rendering while we update PPU memory
  ;** See https://www.nesdev.org/wiki/PPU_registers#PPUMASK
  LDA #$00
  STX $2001         ; Write 0 to PPUMASK, disable rendering
                    ; Bit 3 = Show background, Bit 4 show sprite, ALL bits 0 rendering off



  ;** Set PPU address to $3F00 (start of background memory)
  ;** See https://www.nesdev.org/wiki/PPU_registers#PPUADDR
  ;** We will load 16 bytes of palette data for background and 16 bytes for sprites (Hex 20 bytes total)
  ;** See https://www.nesdev.org/wiki/PPU_memory_map
  ;** Background palette memory is $3F00-$3F0F
  ;** Sprite palette memory is $3F10-$3F1F  
  ;** See https://www.nesdev.org/wiki/PPU_palettes

  LDA $2002    ; read PPU status to reset the high/low latch to high
  LDA #$3F
  STA $2006    ; write the high byte of $3F00 address
  LDA #$00
  STA $2006    ; write the low byte of $3F00 address

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




  ;;; Load background data into PPU memory

  ;** Disable rendering while we update PPU memory
  ;** See https://www.nesdev.org/wiki/PPU_registers#PPUMASK
  LDA #$00
  STX $2001         ; Write 0 to PPUMASK, disable rendering
                    ; Bit 3 = Show background, Bit 4 show sprite, ALL bits 0 rendering off

  ;** Set PPU address to $2000 (start of name table memory)
  ;** See https://www.nesdev.org/wiki/PPU_registers#PPUADDR
  ;** We will load 960 bytes of name table data for background + 64 bytes of attribute data (Hex 400 bytes total or 1024 decimal bytes)
  ;** See https://www.nesdev.org/wiki/PPU_memory_map
  ;** Name-table-0 memory is $2000-$23BF (960 bytes)
  ;** See https://www.nesdev.org/wiki/PPU_nametables
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address


  ;** Load background data from .nam file into PPU memory
  ;** We will use indirect indexed addressing mode to read from the .nam file
  ;** See https://www.nesdev.org/wiki/CPU_addressing_modes#Indirect_indexed
  ;** We will use zero page addresses $00 and $01 to hold the address of the .nam file
  ;** See https://www.nesdev.org/wiki/Sample_RAM_map
  ;** We will use Y register to index through the .nam file
  ;** See https://www.nesdev.org/wiki/CPU_registers#Indexes
  background_ptr_lo = $00
  background_ptr_hi = $01
  
  ;** Load address of background01 into zero page addresses, background01 is a lable defined as start of .nam file and background_end01 is end of .nam file
  ;** We will use the high byte to determine when we reach the end of the .nam file
  ;** We will increment the high byte when the low byte wraps around to 0
  ;** This is because the .nam file is larger than 256 bytes and the low byte will wrap around
  ;** See https://www.nesdev.org/wiki/CPU_addressing_modes#Indirect_indexed
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



  ;;;
  ;;; Below is optional, you can re-enable rendering here
  ;;; or in your main loop after you update PPU memory
  ;;; 
  
  ;** Re-enable rendering after we update PPU memory
  ;** See https://www.nesdev.org/wiki/PPU_registers#PPUMASK
  ;LDA #%00011000    ; Enable background and sprite rendering
  ;STA $2001         ; Write to PPUMASK
    RTS
