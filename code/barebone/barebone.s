.segment "HEADER"
.byte "NES", $1A
.byte 1
.byte 0
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00


.segment "STARTUP"

.segment "VECTORS"

.segment "CHARS"

MainLoop:
  JMP MainLoop