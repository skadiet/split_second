load_tiles_into_ram:

  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA ram_board_ptr
  SEC
  SBC #$18
  STA ram_board_ptr

  LDA #$00
  STA box_ptr; in this code, box pointer will be the ppu_ram_writing_X offset
  LDA #$60
  STA tempVar1
  LDA #$00
  STA tempVar2 ; needed for adjusting the ram_board_ptr at the end if tempVar2==1

  LDX #$00
  LDY #$00
.clear_A0_ram_loop:
  LDA dark_top_row, y
  STA $A0, x
  INX
  CPX #$50
  BEQ .finish_A0_ram_loop
  INY
  CPY #$10
  BNE .clear_A0_ram_loop
  LDY #$00
  JMP .clear_A0_ram_loop 

.finish_A0_ram_loop:
  LDY #$07
.final_A0_loop:
  LDA dark_bottom_bottom_row, y
  STA $F0, y
  DEY
  BPL .final_A0_loop

.exit_A0_ram_loop:
  JSR waitVBlank
  JSR waitVBlank

  LDA #$0F
  STA $F8
  STA $F9
  STA $FA
  STA $FB
  STA $FC
  STA $FD
  STA $FE

  ;LDA #$F1
  STA $FF

; Redraw the wall on the right side of the board.
  ;LDA #$D1
  ;STA $A7
  ;STA $AF
  ;STA $B7
  ;STA $BF
  ;STA $C7
  ;STA $CF
  ;STA $D7
  ;STA $DF
  ;STA $E7
  ;STA $EF
  ;STA $F7

  LDA current_game
  CMP #$03
  BNE .for_each_row_loop 

  LDA mad_maze_number
  AND #$01
  CMP #$01
  BEQ .write_bottom
  JMP .write_top

.write_bottom:
  LDA #$40
  STA box_ptr
  LDA ram_board_ptr
  CLC
  ADC #$10
  STA ram_board_ptr 
  JMP .for_each_row_loop

.write_top:
  LDA #$10
  STA tempVar1
  LDA #$01
  STA tempVar2

.for_each_row_loop:

  LDY ram_board_ptr
  LDA $200,y ; ram_board_ptr tells you where to fetch the metatile data
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  LDX box_ptr
  STA $A0, x
 
  ;STA top right of the box
  INY
  INX
  LDA [meta_tile_ptr],y
  STA $A0, x

  INC ram_board_ptr
  INC box_ptr
  INC box_ptr
  LDA ram_board_ptr

  ;figure out if ram_board_ptr is a multiple of 4
  CLC
  ROR A
  BCS .for_each_row_loop
  ROR A
  BCS .for_each_row_loop

  ;if it's divisible by 8 then
  ;do the routine over again for the bottom part of the boxes
  LDA ram_board_ptr
  SEC
  SBC #$04
  STA ram_board_ptr
  
.loop_bottom:
  LDY ram_board_ptr
  LDA $200,y ; ram_board_ptr tells you where to fetch the metatile data
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  ;STA bottom left of the box
  LDY #$03
  LDA [meta_tile_ptr],y
  LDX box_ptr
  STA $A0, x
 
  ;STA bottom right of the box
  INY
  INX
  LDA [meta_tile_ptr],y
  STA $A0, x

  INC ram_board_ptr
  INC box_ptr
  INC box_ptr
  LDA box_ptr
  CMP tempVar1
  BEQ .all_done
  LDA ram_board_ptr

  ;figure out if ram_board_ptr is a multiple of 4
  CLC
  ROR A
  BCS .loop_bottom
  ROR A
  BCS .loop_bottom

  JMP .for_each_row_loop

.all_done:
  LDA tempVar2
  CMP #$01
  BEQ .need_adjustment
  JMP .end
.need_adjustment:
  LDA ram_board_ptr
  CLC
  ADC #$14
  STA ram_board_ptr
.end:
  RTS

drawBoardRendering1:

  LDA #$21
  STA ppu_y_coord
  LDA #$2D
  STA ppu_x_coord

  LDY #$00
.ppu_address_loop:
  LDA ppu_y_coord
  STA $2006
  LDA ppu_x_coord
  STA $2006
  LDX #$08
.copy_loop:
  LDA $A0, y    ;copy the contents of the drawing string to PPU
  STA $2007
  INY
  DEX
  BNE .copy_loop 
  LDA ppu_x_coord
  CLC
  ADC #$20
  STA ppu_x_coord
  LDA ppu_y_coord
  ADC #$00
  STA ppu_y_coord
  TYA
  CMP #$30
  BEQ .done_copying
  JMP .ppu_address_loop
.done_copying:
  RTS

drawBoardRendering2:

  LDA #$21
  STA ppu_y_coord
  LDA #$ED
  STA ppu_x_coord

  LDY #$30
.ppu_address_loop:
  LDA ppu_y_coord
  STA $2006
  LDA ppu_x_coord
  STA $2006
  LDX #$08
.copy_loop:
  LDA $A0, y    ;copy the contents of the drawing string to PPU
  STA $2007
  INY
  DEX
  BNE .copy_loop 
  LDA ppu_x_coord
  CLC
  ADC #$20
  STA ppu_x_coord
  LDA ppu_y_coord
  ADC #$00
  STA ppu_y_coord
  TYA
  CMP #$60
  BEQ .done_copying
  JMP .ppu_address_loop
.done_copying:
  RTS

mask_tiles_in_ram:

  LDA mad_maze_number
  AND #$01
  CMP #$01
  BEQ .mask_top
  JMP .mask_bottom

.mask_bottom:
  LDA #$0F
  LDX #$10
  LDY #$38
  JMP .loop

.mask_top:
  LDA #$0F
  LDX #$10
  LDY #$30
  JMP .loop

.loop:
  STA $A0, x
  INX
  DEY
  BNE .loop

  ; Redraw the wall on the right side of the board.
 ; LDA #$D1
 ; STA $B7
 ; STA $BF
 ; STA $C7
 ; STA $CF
 ; STA $D7
 ; STA $DF
 ; STA $E7

  LDA #$01
  STA needBoardRendering
  
  RTS

drawClearBoard:
  ;This method expects that the starting ppu_y_coord and ppu_x_coord will be set.

.overall_loop:
  JSR nextLine
  LDY #$00
  LDX #$07

  LDA ppu_y_coord
  STA $2006
  LDA ppu_x_coord
  STA $2006

.top_loop:
  LDA dark_top_row, y
  STA $2007
  INC ppu_x_coord
  INY
  DEX
  BNE .top_loop
 
  JSR nextLine

  LDY #$00
  LDX #$07

  LDA ppu_y_coord
  STA $2006
  LDA ppu_x_coord
  STA $2006
.bottom_loop:
  LDA dark_bottom_row, y
  STA $2007
  INC ppu_x_coord
  INY
  DEX
  BNE .bottom_loop

  LDA ppu_y_coord
  CMP #$22
  BEQ .check_for_second_time

  LDA ppu_x_coord
  CMP #$D3
  BMI .overall_loop
  JMP .end_method

.check_for_second_time:
  LDA ppu_x_coord
  CMP #$53
  BMI .overall_loop

  JSR last_row

.end_method:
  LDA #$00
  STA nmi_show_board_routine
  RTS

nextLine:
  LDA ppu_x_coord
  CLC
  ADC #$19
  STA ppu_x_coord
  LDA ppu_y_coord
  ADC #$00
  STA ppu_y_coord
  RTS

mask_tiles_in_ram_new:

  LDX #$10
  LDY #$00
  LDA #$0F
  STA counterLo
  LDA #$03
  STA counterHi

.save_mask_in_ram_loop:
  LDA dark_top_row,y
  STA $A0, x
  INY
  INX
  DEC counterLo
  LDA counterLo
  CMP #$FF
  BNE .save_mask_in_ram_loop
  LDA #$0F
  STA counterLo
  LDY #$00
  DEC counterHi
  BNE .save_mask_in_ram_loop

  LDA mad_maze_number
  AND #$01
  CMP #$01
  BEQ .mask_top
  JMP .mask_bottom


.mask_bottom:
  LDY #$07
.loop_bottom:
  LDA dark_top_row,y
  STA $E0, y
  DEY
  BPL .loop_bottom

.mask_top:
  ; Redraw the wall on the right side of the board.
  LDA #$0F
  STA $B7
  STA $BF
  STA $C7
  STA $CF
  STA $D7
  STA $DF
  STA $E7

  LDA #$01
  STA needBoardRendering
  
  RTS