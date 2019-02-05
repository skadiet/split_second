game_1_load_board:

;Here are the basket-up commands:
;1 - get random number
;2 - use bottom two bits for deriving position of the top catcher
;2.5 - ALWAYS write a blank row next for basket_up levels 
;3 - loop 3 times
;  3A - get random number
;  3B - Jump to middle loop to load middle lines
;4 - use bottom two bits for deriving position of the top catcher

;Load board into RAM.
  LDA mad_maze_number
  AND #$01 ;is mad_maze_number even?  If not, load basket_down_level
  BNE .load_basket_bottom
 
;otherwise,load basket_up_level if  mad_maze_number is even

.load_basket_top:
  JMP load_basket_top
.load_basket_bottom:
  JMP load_basket_bottom

load_basket_top:

  ;place the top basket
  JSR rand_num
  LDA seed
  AND #$03
  TAX
  CMP #$00
  BEQ .place_top_colA
  TXA
  CMP #$01
  BEQ .place_top_colB
  TXA
  CMP #$02
  BEQ .place_top_colC

.place_top_colA:
  LDX ram_board_ptr
  LDA #$02
  STA $200,x
  INX
  LDA #$00
  STA $200,x
  INX
  LDA #$03
  STA $200,x
  INX
  LDA #$08
  STA $200,x
  JMP .skip_second_row
  
.place_top_colB:
  LDX ram_board_ptr
  LDA #$03
  STA $200,x
  INX
  LDA #$02
  STA $200,x
  INX
  LDA #$00
  STA $200,x
  INX
  LDA #$08
  STA $200,x
  JMP .skip_second_row

.place_top_colC:
  LDX ram_board_ptr
  LDA #$03
  STA $200,x
  INX
  LDA #$03
  STA $200,x
  INX
  LDA #$02
  STA $200,x
  INX
  LDA #$09
  STA $200,x
  JMP .skip_second_row

.skip_second_row:
  LDA ram_board_ptr
  CLC
  ADC #$08
  STA ram_board_ptr

.run_middle_loop:
  JSR run_loop_middle
  JMP .place_ball

.place_ball:
  LDX ram_board_ptr
  LDA #$0A
  STA $200,x
  INX
  STA $200,x
  INX
  STA $200,x
  INX
  LDA #$0C
  STA $200,x 

 JMP done_creating_basket_top_board

load_basket_bottom:

.all_blanks_on_top:
  LDX ram_board_ptr
  LDA #$03
  STA $200,x
  INX
  STA $200,x
  INX
  STA $200,x
  INX
  LDA #$08
  STA $200,x
 
  LDA ram_board_ptr
  CLC
  ADC #$04
  STA ram_board_ptr

  JSR run_loop_middle

;place the bottom basket
  JSR rand_num
  LDA seed
  AND #$03
  TAX
  CMP #$00
  BEQ .place_bottom_colA
  TXA
  CMP #$01
  BEQ .place_bottom_colB
  TXA
  CMP #$02
  BEQ .place_bottom_colC

.place_bottom_colA:
  LDX ram_board_ptr
  LDA #$00
  STA $200,x
  INX
  LDA #$00
  STA $200,x
  INX
  LDA #$03
  STA $200,x
  INX
  LDA #$08
  STA $200,x
  INX
  LDA #$0B
  STA $200,x
  INX
  LDA #$0A
  STA $200,x
  INX
  STA $200,x
  INX
  LDA #$0C
  STA $200,x
  JMP done_creating_bottom_board
  
.place_bottom_colB:
  LDX ram_board_ptr
  LDA #$03
  STA $200,x
  INX
  LDA #$00
  STA $200,x
  INX
  LDA #$00
  STA $200,x
  INX
  LDA #$08
  STA $200,x
  INX
  LDA #$0A
  STA $200,x
  INX
  LDA #$0B
  STA $200,x
  INX
  LDA #$0A
  STA $200,x
  INX
  LDA #$0C
  STA $200,x
  JMP done_creating_bottom_board

.place_bottom_colC:
  LDX ram_board_ptr
  LDA #$03
  STA $200,x
  INX
  LDA #$03
  STA $200,x
  INX
  LDA #$00
  STA $200,x
  INX
  LDA #$09
  STA $200,x
  INX
  LDA #$0A
  STA $200,x
  INX
  LDA #$0A
  STA $200,x
  INX
  LDA #$0B
  STA $200,x  
  INX
  LDA #$0C
  STA $200,x 

  JMP done_creating_bottom_board

done_creating_basket_top_board:
  LDA ram_board_ptr
  CLC
  ADC #$04
  STA ram_board_ptr
  JMP done_creating_board

done_creating_bottom_board:
  LDA ram_board_ptr
  CLC
  ADC #$08
  STA ram_board_ptr
  JMP done_creating_board
  
done_creating_board:

  LDA ram_board_ptr
  SEC
  SBC #$18
  TAX
  
.done_with_increasing:

  RTS

run_loop_middle:
  LDY #$03
loop_middle:
  JSR rand_num
  LDA seed
  AND #$07
  TAX
  CMP #$00
  BEQ loop_middle
  TXA
  CMP #$01
  BEQ .write_left_only
  TXA
  CMP #$02
  BEQ .write_mid_only
  TXA
  CMP #$03
  BEQ .write_right_only
  TXA
  CMP #$04
  BEQ .write_left_mid
  TXA
  CMP #$05
  BEQ .write_mid_right
  TXA
  CMP #$06
  BEQ .write_left_right
  TXA
  CMP #$07
  BEQ loop_middle

.write_left_only:
  write_left_only
  JMP .next_row

.write_mid_only:
  write_mid_only
  JMP .next_row

.write_right_only:
  write_right_only
  JMP .next_row

.write_left_mid:
  write_left_mid
  JMP .next_row

.write_mid_right:
  write_mid_right
  JMP .next_row

.write_left_right:
  write_left_right
  JMP .next_row

.next_row:
  LDA ram_board_ptr
  CLC
  ADC #$04
  STA ram_board_ptr

  DEY
  TYA
  CMP #$00
  BNE .loop_middle
  RTS
.loop_middle:
  JMP loop_middle
