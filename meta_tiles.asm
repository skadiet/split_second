left_no_ball:         ;0
  .db $22,$2C,$FF,$32,$34,$FF
top_no_ball:          ;1
  .db $40,$41,$FF,$3C,$34,$FF
left_and_top_no_ball: ;2
  .db $23,$24,$FF,$33,$34,$FF
nothing_no_ball:      ;3
  .db $03,$04,$FF,$13,$14,$FF
left_yes_ball:        ;4
  .db $27,$28,$FF,$37,$38,$FF
top_yes_ball:         ;5
  .db $25,$26,$FF,$35,$36,$FF
left_and_top_yes_ball:;6
  .db $20,$21,$FF,$30,$31,$FF
nothing_yes_ball:     ;7
  .db $29,$2A,$FF,$39,$3A,$FF
nothing_special_edge: ;8
  .db $2B,$0F,$FF,$3B,$0F,$FF
left_special_edge:    ;9
  .db $2D,$0F,$FF,$3D,$0F,$FF
nothing_bottom_edge:  ;0A
  .db $06,$07,$FF,$0F,$0F,$FF
top_bottom_edge:      ;0B
  .db $2E,$2F,$FF,$0F,$0F,$FF
nothing_bottom_corner:  ;0C
  .db $3F,$0F,$FF,$0F,$0F,$FF
top_bottom_corner:      ;0D
  .db $40,$41,$FF,$E0,$F1,$FF

meta_tiles:
  .word left_no_ball,top_no_ball,left_and_top_no_ball, nothing_no_ball
  .word left_yes_ball, top_yes_ball,left_and_top_yes_ball, nothing_yes_ball
  .word nothing_special_edge, left_special_edge, nothing_bottom_edge, top_bottom_edge
  .word nothing_bottom_corner, top_bottom_corner;, left_for_numbers
