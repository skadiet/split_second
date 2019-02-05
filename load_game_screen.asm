load_game_screen:
  
  ;Idea is this....
  ;1 - Get the first tile number from the boards file.
  ;2 - Using this tile number, get the first nametable tile associated with that number
  ;3 - get the x and y coordinate from the meta_tiles.asm file.
  ;4 - load that data into the textPointer and call add_to_dbuffer
  ;5 - repeat steps 2 through 4, 24 times so that we add load the entire screen into RAM.
  
  LDA ram_board_ptr
  SEC
  SBC #$18 ;always start 24 boxes before the end of the current position of the RAM pointer.
  STA board_ptr
  LDA #$02
  STA board_ptr+1

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

  LDA #$00 ;init box_ptr
  STA box_ptr
for_each_in_board:

  LDA box_ptr
  CMP #$04
  BEQ .wait_for_ppu
  CMP #$08
  BEQ .wait_for_ppu
  CMP #$0A
  BEQ .wait_for_ppu
  CMP #$10
  BEQ .wait_for_ppu
  ;CMP #$14
  BEQ .wait_for_ppu
  JMP .no_ppu_wait
.wait_for_ppu:
  JSR waitVBlank
.no_ppu_wait:
  TAY
  LDA [board_ptr], y
  CMP #$03
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

  JSR add_to_dbuffer;

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
  CMP #$18
  BEQ .done_for_each_in_board
  JMP for_each_in_board

.done_for_each_in_board

  RTS
