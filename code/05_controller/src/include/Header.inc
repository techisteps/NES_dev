.ifndef __HEADER__

__HEADER__ = 1

.segment "HEADER"
  .byte "NES", $1A    
;  .byte $4E, $45, $53, $1A  ; iNES header identifier
  .byte 2                   ; 2x 16KB PRG-ROM Banks
  .byte 1                   ; 1x  8KB CHR-ROM
  .byte $01, $01            ; mapper 0, 0=vertical and 1=horizotal  mirroring 
  .byte $00, $01, $00, $00  ; Reserved  , Second byte set to $01 mark rom as PAL


.endif