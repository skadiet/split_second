;Method assumes you've set score_1 to A, score_2 to X, and score_3 to Y before calling it.

load_level_selector_screen:

  STA score_1
  JSR initiate_score_pointers

  LDA #$03
  JSR get_pts_for_ppu_address

  LDA score_1  
  CLC
  ROL A
  TAY
  LDA [number_ptr],y
  STA board_ptr
  INY
  LDA [number_ptr],y
  STA board_ptr+1

  LDA #$00
  STA box_ptr

  LDA #$00
  STA box_ptr
for_each_in_level_board:

  LDA box_ptr
  TAY
  LDA [board_ptr], y
  CMP #$FF
  BEQ .next_box
  CLC
  ROL A
  TAY

  ;++++++++ FIRST ROW +++++++++
  ;get text pointers
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  STA textPointer1Lo
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1
  STA textPointer1Hi

  ;get metatile PPU addresses
  LDA box_ptr
  CLC
  ROL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr ;like 21
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;like D2

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_y_coord
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_x_coord
  
  LDA ppu_x_coord
  TAY
  LDA ppu_y_coord

  JSR add_to_dbuffer

;++++++++ SECOND ROW +++++++++
  ;get text pointers
  LDA meta_tile_ptr
  CLC
  ADC #$03
  STA textPointer1Lo

  ;get metatile PPU Addresses
  LDY #$04 ;this gets the first x,y coord on the second line of the metatile
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_y_coord
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_x_coord
  
  LDA ppu_x_coord
  TAY
  LDA ppu_y_coord

  JSR add_to_dbuffer;

  LDA #$01
  STA needDrawBuffer

.next_box:
  LDA box_ptr
  CLC
  ADC #$01
  STA box_ptr
  CMP #$06
  BEQ .done_for_this_level
  JMP for_each_in_level_board

.done_for_this_level:
  RTS

load_score_screen: 
  ;Assumes A is the first digit of the top score
  ;Assumes Y is the second digit of the top score

  ;STA score_1
  ;STX score_2
  ;STY score_3

  JSR initiate_score_pointers
  
  LDA #$00
  STA score_looper
do_this_thrice:
  INC score_looper
  LDA score_looper
  CMP #$04
  BEQ .done_for_each_in_score_board
  CMP #$03
  BEQ .third_score
  CMP #$02
  BEQ .second_score
  LDA #$00
  JSR get_pts_for_ppu_address
  LDA score_1
  JMP .start_loop
.second_score:
  LDA #$01
  JSR get_pts_for_ppu_address
  LDA score_2
  CLC
  ADC #$0A
  STA score_2
  JMP .start_loop
.third_score:
  LDA #$02
  JSR get_pts_for_ppu_address
  LDA score_3
  JMP .start_loop
.done_for_each_in_score_board:
  JMP done_for_each_in_score_board
.start_loop:
  CLC
  ROL A
  TAY
  LDA [number_ptr],y
  STA board_ptr
  INY
  LDA [number_ptr],y
  STA board_ptr+1

  LDA #$00
  STA box_ptr
for_each_in_score_board:

  LDA box_ptr
  TAY
  LDA [board_ptr], y
  CMP #$FF
  BEQ .next_box
  CLC
  ROL A
  TAY

  ;++++++++ FIRST ROW +++++++++
  ;get text pointers
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  STA textPointer1Lo
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1
  STA textPointer1Hi

  ;get metatile PPU addresses
  LDA box_ptr
  CLC
  ROL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr ;like 21
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;like D2

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_y_coord
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_x_coord
  
  LDA ppu_x_coord
  TAY
  LDA ppu_y_coord

  JSR add_to_dbuffer

;++++++++ SECOND ROW +++++++++
  ;get text pointers
  LDA meta_tile_ptr
  CLC
  ADC #$03
  STA textPointer1Lo
  LDA textPointer1Hi
  ADC #$00
  STA textPointer1Hi

  ;get metatile PPU Addresses
  LDY #$04 ;this gets the first x,y coord on the second line of the metatile
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_y_coord
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_x_coord
  
  LDA ppu_x_coord
  TAY
  LDA ppu_y_coord

  JSR add_to_dbuffer;

  LDA #$01
  STA needDrawBuffer

.next_box:
  LDA box_ptr
  CLC
  ADC #$01
  STA box_ptr
  CMP #$06
  BEQ .done_for_this_score
  JMP for_each_in_score_board

.done_for_this_score
  LDA score_3
  CMP #$01
  BEQ .skip_change_bottom
  CMP #$04
  BEQ .skip_change_bottom
  CMP #$07
  BEQ .skip_change_bottom
  CMP #$09
  BEQ .skip_change_bottom

  JSR last_row_score

.skip_change_bottom:
  JSR waitVBlank
  JSR waitVBlank
  JMP do_this_thrice
done_for_each_in_score_board:
  ;draw the decimal
  ;This puts the board into the board_ptr
  LDA #LOW(nothing_yes_ball)   ;load the new meta tile bank
  STA textPointer1Lo
  LDA #HIGH(nothing_yes_ball)
  STA textPointer1Hi

  LDA #LOW(meta_tile_ppu_addr_16)   ;load the new meta tile bank
  STA meta_tile_ppu_addr_coord_ptr
  LDA #HIGH(meta_tile_ppu_addr_16)
  STA meta_tile_ppu_addr_coord_ptr+1

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_y_coord
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_x_coord
  
  LDA ppu_x_coord
  TAY
  LDA ppu_y_coord

  JSR add_to_dbuffer

  ;get metatile PPU Addresses
  LDA textPointer1Lo
  CLC
  ADC #$03
  STA textPointer1Lo

  LDY #$04 ;this gets the first x,y coord on the second line of the metatile
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_y_coord
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA ppu_x_coord
  
  LDA ppu_x_coord
  TAY
  LDA ppu_y_coord

  JSR add_to_dbuffer

  LDA #$01
  STA needDrawBuffer

  JSR waitVBlank
  JSR waitVBlank

get_pts_for_ppu_address:
  CLC
  ROL A
  TAY
  LDA [scores_ptr],y
  STA meta_tile_ppu_addr_coords_ptr
  INY
  LDA [scores_ptr],y
  STA meta_tile_ppu_addr_coords_ptr+1
  RTS

initiate_score_pointers:

  ;This puts the board into the board_ptr
  LDA #LOW(numbers)   ;load the new meta tile bank
  STA number_ptr
  LDA #HIGH(numbers)
  STA number_ptr+1

  ;This gets the address of the metatiles lookup table.
  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  ;This gets the address of the metatile_coordinate lookup table.
  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA #LOW(scores)   ;load the new meta tile bank
  STA scores_ptr
  LDA #HIGH(scores)
  STA scores_ptr+1

  RTS

last_row_score:
  LDA #LOW(top_bottom_edge)   ;load the new meta tile bank
  STA textPointer1Lo
  LDA #HIGH(top_bottom_edge)
  STA textPointer1Hi
  
  LDA #$6F
  TAY
  LDA #$22

  JSR add_to_dbuffer

  RTS
  
numbers:
  .word number_0, number_1, number_2, number_3, number_4
  .word number_5, number_6, number_7, number_8, number_9
  .word number_0_2, number_1_2, number_2_2, number_3_2, number_4_2
  .word number_5_2, number_6_2, number_7_2, number_8_2, number_9_2

scores:
  .word scores_0, scores_1, scores_2, level_selector

scores_0:
  .word meta_tile_ppu_addr_00, meta_tile_ppu_addr_01, meta_tile_ppu_addr_04
  .word meta_tile_ppu_addr_05, meta_tile_ppu_addr_08, meta_tile_ppu_addr_09
scores_1:
  .word meta_tile_ppu_addr_02, meta_tile_ppu_addr_03, meta_tile_ppu_addr_06
  .word meta_tile_ppu_addr_07, meta_tile_ppu_addr_10, meta_tile_ppu_addr_11
scores_2:
  .word meta_tile_ppu_addr_13, meta_tile_ppu_addr_14, meta_tile_ppu_addr_17
  .word meta_tile_ppu_addr_18, meta_tile_ppu_addr_21, meta_tile_ppu_addr_22
level_selector:
  .word meta_tile_ppu_addr_05, meta_tile_ppu_addr_06, meta_tile_ppu_addr_09
  .word meta_tile_ppu_addr_10, meta_tile_ppu_addr_13, meta_tile_ppu_addr_14
