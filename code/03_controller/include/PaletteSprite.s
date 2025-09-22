PaletteData:
  .byte $0F,$31,$32,$33,$0F,$35,$36,$37,$0F,$39,$3A,$3B,$0F,$3D,$3E,$0F  ;background palette data
  .byte $0F,$1C,$15,$14,$0F,$02,$38,$3C,$0F,$1C,$15,$14,$0F,$02,$38,$3C  ;sprite palette
sprites:
     ;vert tile attr horiz
  .byte $80, $32, $00, $80   ;sprite 0
  .byte $80, $33, $00, $88   ;sprite 1
  .byte $88, $34, $00, $80   ;sprite 2
  .byte $88, $35, $00, $88   ;sprite 3