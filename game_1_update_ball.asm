drawBallUpdate:

; update - in this method - refers to updating the $200 range addresses
; In other words, we want to update for all of current_game==1.  We only want it to update in the visible
; portions of current_game==3

  ;1) Turn new light on
  ; 1A) get metatile + 4 for ball_box
  ; 1B) use that to get metatile_coordinates
  ; 1C) write to PPU Address
  ;2) Same thing for turning old ball off with metatile - 4

  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA current_game
  CMP #$04
  BPL .mask_ball

  LDA ram_board_ptr
  SEC
  SBC #$18
  LDX #$00
  CLC
  ADC ball_box,x
  TAY

  LDA $200,y ; ram_board_ptr tells you where to fetch the metatile data
  EOR #$04 ;flip the ball
  STA $200,y
  ASL A
  TAY

  LDA current_game
  CMP #$01
  BEQ .update

  LDA current_game
  CMP #$04
  BEQ .mask_ball

  LDA current_game
  CMP #$02
  BEQ .check_masking
  JMP .dont_update

.check_masking
  LDA isFirstMasking
  BNE .turnOffFirstMasking
  LDA isMasking
  BEQ .update
  JMP .dont_update

.turnOffFirstMasking:
  LDA #$00
  STA isFirstMasking
  JMP .dont_update

.dont_update:
  LDA mad_maze_number
  AND #$01
  CMP #$01
  BEQ .bottom_goal
  JMP .top_goal

.bottom_goal:
  LDA ball_box
  CMP #$10
  BMI .mask_ball
  JMP .update

.top_goal:
  LDA ball_box
  CMP #$08
  BMI .update
  JMP .mask_ball

.mask_ball:
  LDA ship_box
  CMP #$08
  BEQ .special_case_ball
  LDA #$07
  ASL A
  TAY
  JMP .update

.special_case_ball: ;should only ever get here if it's game 4 and if ship_box==9.
  NOP ;Why would adding a NOP make the ship brighter?  Without the NOP, ship could be bright
      ;or dim.  Randomly.
  LDA isMasking
  BEQ .masking
  JMP .not_masking
.masking:
  LDA #$04
  JMP .please_proceed
.not_masking:
  LDA #$07
.please_proceed:
  ASL A
  TAY

.update:
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA ball_box
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

eraseBallUpdate:

  LDA ball_box
  CMP ball_box_old
  BEQ .end_loop
  LDA current_game
  CMP #$04 
  BEQ .end_loop
  JMP .continue

.end_loop:
  JMP game_1_end_erase_loop

.continue:
  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA current_game
  CMP #$06
  BPL .mask_ball

  LDA ram_board_ptr
  SEC
  SBC #$18
  LDX #$00
  CLC
  ADC ball_box_old,x
  TAY

  LDA $200,y ; ram_board_ptr tells you where to fetch the metatile data
  EOR #$04 ;flip the ball
  STA $200,y
  ASL A
  TAY

  LDA current_game
  CMP #$01
  BEQ .update

  LDA current_game
  CMP #$04
  BPL .mask_ball ;need this to prevent game 6 ball from getting written to RAM

.dont_update:
  LDA mad_maze_number
  AND #$01
  CMP #$01
  BEQ .bottom_goal
  JMP .top_goal

.bottom_goal:
  LDA ball_box_old
  CMP #$10
  BMI .mask_ball
  JMP .update

.top_goal:
  LDA ball_box_old
  CMP #$04
  BMI .update
  JMP .mask_ball

.mask_ball:
  LDA #$03
  ASL A
  TAY

.update:
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA ball_box_old
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

game_1_end_erase_loop:
  RTS

turn_off_ball:
  LDA ram_board_ptr
  SEC
  SBC #$18
  CLC
  ADC ball_box
  TAX
  LDA $200,x
  EOR #$04
  STA $200,x
  RTS

turn_on_ball:
  LDA #$07
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA ball_box
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
