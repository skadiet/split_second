drawShip:

  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This logic is for the lefthand side of the ship  
  LDA #$04
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA ship_box
  ASL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;load bottom
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  LDY #$03
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This logic is for the righthand side of the ship 

  LDA ship_box
  LSR A
  LSR A
  BCC .need_regular_right_side

.need_right_side_board_edge:
  LDA #$09 ; left special_edge
  ASL A
  TAY
  JMP .continue

.need_regular_right_side:
  LDA #$00 ; left noball
  ASL A
  TAY
  JMP .continue

.continue:
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA ship_box
  CLC
  ADC #$01
  ASL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;load bottom
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  LDY #$03
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

.end_loop:
  RTS

eraseShipUpdate:

  LDA ship_box
  CMP ship_box_old
  BEQ .end_loop
  JMP .continue

.end_loop:
  JMP game_4_end_erase_loop

.continue:
  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA #$03
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

;This is for the lefthand side of the ship.
  LDA ship_box_old
  ASL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;load bottom
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  LDY #$03
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This is for the righthand side of the ship.

  LDA ship_box_old
  LSR A
  LSR A
  BCC .no_wall
.yes_wall:
  LDA #$08
  JMP .continue_wall
.no_wall:
  LDA #$03
.continue_wall:

  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed


  LDA ship_box_old
  CLC 
  ADC #$01
  ASL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;load bottom
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  LDY #$03
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

game_4_end_erase_loop:
  RTS

flickOff:

.continue:
  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA #$03
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

;This is for the lefthand side of the ship.
  LDA ship_box
  ASL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;load bottom
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  LDY #$03
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This is for the righthand side of the ship.

  LDA ship_box
  LSR A
  LSR A
  BCC .no_wall
.yes_wall:
  LDA #$08
  JMP .continue_flick
.no_wall:
  LDA #$03
.continue_flick:
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA ship_box
  CLC
  ADC #$01
  ASL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;load bottom
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  LDY #$03
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  RTS


draw_flicker_ship:
  LDA isMasking
  EOR #$01
  STA isMasking
  CMP #$01
  BEQ .mask
  JMP .unmask

.mask:
  JSR flickOff
  JMP .done

.unmask:
  JSR drawShip
  JMP .done

.done:
  LDA ship_box
  CMP #$09
  BEQ .skip_ball_update
  JSR drawBallUpdate
.skip_ball_update:
  RTS
