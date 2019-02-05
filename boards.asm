screen_intro:
  ; nametable 960 bytes long for the background

  .db $0F,$20                                                          ;;Blank

  .db $0F,$05,$17,$14,$0D,$0A,$18,$0F,$01,$17,$06,$04,$13,$12  ;;SPLIT SECOND
  .db $05,$0F,$01,$03,$1D,$0F,$01,$17,$0C,$02,$05,$0A,$06,$18,$0F,$04 ;;BY SKADIET

  .db $0F,$05,$0F,$02,$09,$02,$12,$08,$0F,$01,$18,$09
  .db $06,$0F,$01,$08,$02,$18,$06  ;;Blank
  .db $0F,$01,$08,$02,$0E,$06,$17,$0F,$06  ;;Blank

  ;.db $0F,$01,$3B,$3C,$3D,$3E,$0F,$09,$01,$13  ;;Blank
  .db $0F,$02,$23,$24,$25,$26,$27,$28,$0F,$06,$01,$13  ;;Castle Top
  ;.db $10,$00,$0F,$09,$3B,$3C,$3D,$3E,$0F,$01  ;;Blank
  .db $10,$00,$0F,$06,$23,$24,$25,$26,$27,$28,$0F,$02  ;;Castle Top

  ;.db $0F,$01,$4B,$4C,$4D,$4E,$0F,$16,$4B,$4C,$4D,$4E,$0F,$01  ;;Blank
  .db $0F,$02,$33,$34,$35,$36,$37,$38,$0F,$10,$33,$34,$35  ;;Castle Middle
  .db $36,$37,$38,$0F,$02  ;;Castle Middle

  .db $0F,$02,$43,$44,$45,$46,$47,$48,$0F,$04,$50,$51,$52,$53  ;;Blank
  .db $54,$55,$56,$57,$0F,$04,$43,$44,$45,$46,$47,$48,$0F,$02  ;;Blank

  .db $0F,$02,$20,$21,$22,$30,$31,$32,$0F,$04,$60,$61,$62,$63  ;;Blank
  .db $64,$65,$66,$67,$0F,$04,$20,$21,$22,$30,$31,$32,$0F,$02 ;;Blank

  .db $0F,$0C,$70,$71,$72,$73  ;;Blank
  .db $74,$75,$76,$77,$0F,$0C  ;;Blank

  .db $0F,$0C,$80,$81,$82,$83  ;;Blank
  .db $84,$85,$86,$87,$0F,$0C ;;Blank
  
  .db $0F,$0C,$90,$91,$92,$93  ;;Blank
  .db $94,$95,$96,$97,$0F,$0C  ;;Blank
  
  .db $0F,$0C,$A0,$A1,$A2,$A3  ;;Blank
  .db $A4,$A5,$A6,$A7,$0F,$0C  ;;Blank
  
  .db $0F,$0C,$B0,$B1,$B2,$B3  ;;Blank
  .db $B4,$B5,$B6,$B7,$0F,$0C ;;Blank
  
  .db $0F,$0C,$C0,$C1,$C2,$C3  ;;Blank
  .db $C4,$C5,$C6,$C7,$0F,$0C ;;Blank
  
  .db $0F,$0C,$D0,$D1,$D2,$D3  ;;Blank
  .db $D4,$D5,$D6,$D7,$0F,$0C ;;Blank
  
  .db $0F,$0C,$E0,$E1,$E2,$E3  ;;Blank
  .db $E4,$E5,$E6,$E7,$0F,$0C ;;Blank

  .db $0F,$0C,$58,$59,$5A,$5B  ;;Blank
  .db $5C,$5D,$5E,$5F,$0F,$0C  ;;Blank
  
  .db $0F,$0C,$68,$69,$6A,$6B  ;;Blank
  .db $6C,$6D,$6E,$6F,$0F,$0C ;;Blank
  
  .db $0F,$0C,$78,$79,$7A,$7B  ;;Blank
  .db $7C,$7D,$7E,$7F,$0F,$0C ;;Blank

  .db $0F,$0C,$88,$89,$8A,$8B  ;;Blank
  .db $8C,$8D,$8E,$8F,$0F,$0C ;;Blank

  .db $0F,$0C,$98,$99,$9A,$9B  ;;Blank
  .db $9C,$9D,$9E,$9F,$0F,$0C ;;Blank

  .db $0F,$0C,$A8,$A9,$AA,$AB  ;;Blank
  .db $AC,$AD,$AE,$AF,$0F,$0C  ;;Blank

  .db $0F,$0C,$B8,$B9,$BA,$BB  ;;Blank
  .db $BC,$BD,$BE,$BF,$0F,$0C ;;Blank

  .db $0F,$0C,$C8,$C9,$CA,$CB  ;;Blank
  .db $CC,$CD,$CE,$CF,$0F,$0C  ;;Blank
  
  .db $0F,$0C,$D8,$D9,$DA,$DB  ;;Blank
  .db $DC,$DD,$DE,$DF,$0F,$0C ;;Blank
  
  .db $0F,$0C,$E8,$E9,$EA,$EB  ;;Blank
  .db $EC,$ED,$EE,$EF,$0F,$0C ;;Blank
  
  .db $0F,$20  ;;Blank
  
  .db $0F,$03,$13,$16,$0A,$08,$0A,$12,$02,$0D,$0F,$01,$09,$02,$12,$05  ;;ORIGINAL HAND
  .db $09,$06,$0D,$05,$0F,$01,$08,$02,$0E,$06,$0F,$01,$03,$1D,$0F,$04  ;;HELD GAME BY
  
  .db $0F,$09,$14,$02,$16,$0C,$06,$16,$0F,$01  ;;PARKER
  .db $03,$16,$13,$18,$09,$06,$16,$17,$0F,$08  ;;BROTHERS
  
  .db $0F,$0E,$10,$00  ;;Blank
  .db $11,$13,$0F,$0E ;;Blank

  .db $0F,$20 ;;Blank

fireworks_00:
  .db $03,$03,$03,$08
  .db $03,$03,$03,$08
  .db $03,$04,$00,$08
  .db $03,$03,$03,$08
  .db $03,$03,$03,$08
  .db $0A,$0A,$0A,$0C
fireworks_01:
  .db $03,$07,$03,$08
  .db $03,$03,$03,$08
  .db $03,$04,$00,$08
  .db $03,$03,$03,$08
  .db $03,$07,$03,$08
  .db $0A,$0A,$0A,$0C
fireworks_02:
  .db $03,$03,$03,$08
  .db $03,$07,$03,$08
  .db $03,$04,$00,$08
  .db $03,$07,$03,$08
  .db $03,$03,$03,$08
  .db $0A,$0A,$0A,$0C
fireworks_03:
  .db $03,$03,$03,$08
  .db $07,$03,$07,$08
  .db $03,$02,$00,$08
  .db $07,$01,$07,$08
  .db $03,$03,$03,$08
  .db $0A,$0A,$0A,$0C
fireworks_04:
  .db $03,$03,$03,$08
  .db $03,$04,$00,$08
  .db $05,$07,$05,$08
  .db $01,$04,$02,$08
  .db $03,$03,$03,$08
  .db $0A,$0A,$0A,$0C
fireworks_05:
  .db $03,$03,$03,$08
  .db $07,$07,$07,$08
  .db $07,$03,$07,$08
  .db $07,$07,$07,$08
  .db $03,$03,$03,$08
  .db $0A,$0A,$0A,$0C
fireworks_06:
  .db $03,$03,$03,$08
  .db $02,$01,$01,$09
  .db $00,$03,$03,$09
  .db $00,$03,$03,$09
  .db $01,$01,$01,$08
  .db $0A,$0A,$0A,$0C
fireworks_07:
  .db $03,$03,$03,$08
  .db $03,$00,$03,$08
  .db $03,$03,$01,$08
  .db $01,$03,$00,$08
  .db $03,$03,$03,$08
  .db $0A,$0A,$0A,$0C
fireworks_08:
  .db $03,$03,$03,$08
  .db $01,$03,$03,$09
  .db $03,$03,$03,$08
  .db $00,$03,$03,$08
  .db $03,$03,$01,$08
  .db $0A,$0A,$0A,$0C
fireworks_09:
  .db $00,$03,$03,$08
  .db $03,$03,$03,$08
  .db $03,$03,$03,$08
  .db $03,$03,$03,$08
  .db $03,$03,$03,$09
  .db $0A,$0A,$0A,$0C
number_0:
  .db $02,$00
  .db $00,$00
  .db $01,$FF
number_1:
  .db $FF,$00
  .db $FF,$00
  .db $FF,$FF
number_2:
  .db $01,$00
  .db $02,$FF
  .db $01,$FF
number_3:
  .db $01,$00
  .db $01,$00
  .db $01,$FF
number_4:
  .db $00,$00
  .db $01,$00
  .db $FF,$FF
number_5:
  .db $02,$FF
  .db $01,$00
  .db $01,$FF
number_6:
  .db $02,$FF
  .db $02,$00
  .db $01,$FF
number_7:
  .db $01,$00
  .db $FF,$00
  .db $FF,$FF
number_8:
  .db $02,$00
  .db $02,$00
  .db $01,$FF
number_9:
  .db $02,$00
  .db $01,$00
  .db $FF,$FF
number_0_2:
  .db $02,$09
  .db $00,$09
  .db $01,$FF
number_1_2:
  .db $FF,$09
  .db $FF,$09
  .db $FF,$FF
number_2_2:
  .db $01,$09
  .db $02,$FF
  .db $01,$FF
number_3_2:
  .db $01,$09
  .db $01,$09
  .db $01,$FF
number_4_2:
  .db $00,$09
  .db $01,$09
  .db $FF,$FF
number_5_2:
  .db $02,$FF
  .db $01,$09
  .db $01,$FF
number_6_2:
  .db $02,$FF
  .db $02,$09
  .db $01,$FF
number_7_2:
  .db $01,$09
  .db $FF,$09
  .db $FF,$FF
number_8_2:
  .db $02,$09
  .db $02,$09
  .db $01,$FF
number_9_2:
  .db $02,$09
  .db $01,$09
  .db $FF,$FF
