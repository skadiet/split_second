is_game_6_right_side:
  LDA tempVar1
  AND #%11111110
  LSR A
  LSR A
  BCC .not_right_side
  LSR A
  BCC .not_right_side
.is_right_side:
  LDA #$01
  STA tempVar2
  SEC
  RTS
.not_right_side:
  CLC
  RTS

is_game_6_bottom_side:
  LDA tempVar1
  CMP #$27
  BPL .bottom
  CLC
  RTS
.bottom:
  LDA #$02
  STA tempVar2
  SEC
  RTS


drawCarUpdate:
  ;I reuse this code for game 8 as well.  If I do, I need to set tempVar3 before I call this function.
  ;tempVar3=0 means that it should draw normally
  ;tempVar3=1 means that it should draw the angled snake segments in the same metatile.

  ;I only use the eraseCarUpdate for game 8.  So for drawing the
  ;car I will force it to use normal drawing in case the game is
  ;in a bad state.
  
  LDA #$FF
  STA tempVar3

  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA #$00
  STA tempVar2 ; 0=Normal ; 1=RightSide ; 2 = bottom

  LDA car_box
  STA tempVar1
  ;find out if the car is at the right side of the wall.  if it is, set tempVar2==1
  JSR is_game_6_right_side
  BCS .continue1
  JSR is_game_6_bottom_side
  BCS .continue1
.continue1:

  LDA #$00
  STA tempVar1 ; use this for EORing.  If 00, the metatile won't change.  If #$04, it will flip the ball.

  LDA car_box
  AND #%11111110
  TAY
  LSR A
  
  CMP game_6_vars
  BEQ .need_flip
  CMP game_6_vars+1
  BEQ .need_flip
  CMP game_6_vars_old
  BEQ .might_need_flip
  CMP game_6_vars_old+1
  BEQ .might_need_flip
  JMP .continue

;might_need_flip is needed because we only want to flip the ball on if the old cones have not been removed
;if we just blindly flip for the old cones then they will re-appear after they have already been removed.
.might_need_flip: 
  LDA need_remove_cones
  BNE .need_flip
  JMP .continue

.need_flip:
  LDA #$04
  STA tempVar1

.continue:
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

  LDA car_box
  AND #$01
  EOR tempVar1 ; tempVar1==0 if not flipping.
  ASL A
  TAY

  ;if car is on the right side, we need to use metatile - left special edge
  LDA tempVar2
  CMP #$01
  BEQ .use_right_metatile
  CMP #$02
  BEQ .use_bottom_metatile
  JMP .done_right_side_check
.use_right_metatile:
  LDY #$12
  JMP .done_right_side_check
 .use_bottom_metatile:
  LDY #$16
.done_right_side_check:
;This section is for crashing logic only.
  LDA isCrashing
  BNE .is_masking
  JMP .masking_complete
.is_masking:
  LDA tempVar2
  BEQ .not_mask_right_side
  CMP #$02
  BEQ .mask_bottom
  LDY #$10 ;metatile - nothing special edge
  JMP .masking_complete
.mask_bottom:
  LDY #$14 ;metatile - nothing special edge
  JMP .masking_complete
.not_mask_right_side:
  TYA
  CMP #$08
  BMI .mask_with_no_ball
  JMP .mask_with_yes_ball
.mask_with_no_ball:
  LDY #$06  ; metatile - nothing no ball
  JMP .masking_complete
.mask_with_yes_ball:
  LDY #$0E ; metatile - nothing yes ball

.masking_complete:

.regular_car_update:
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed
  
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;START DRAWING THE BOTTOM HALF OF THE CAR
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

eraseCarUpdate:
  LDA current_game
  CMP #$06
  BNE .game_8_erase_update

  LDA tempVar3
  CMP #$FF
  BEQ .no_skip
  JMP .skip

.game_8_erase_update:
  LDA tempVar3
  BNE .skip
  JMP .no_skip

.skip:
  LDA #$01
  STA debug+3
  RTS

.no_skip:
  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA #$00
  STA tempVar2 ; 0=Normal ; 1=RightSide

  LDA car_box_old
  STA tempVar1
  
  ;if right side of the wall
  JSR is_game_6_right_side
  BCS .continue1
  JSR is_game_6_bottom_side
  BCS .continue1
.continue1:

  LDA #$00
  STA tempVar1 ; use this for EORing.  If 00, the metatile won't change.  If #$04, it will flip the ball.

  LDA car_box_old
  CMP #$FF
  BEQ .skip
  
  LDA car_box_old
  AND #%11111110
  TAY
  LSR A
  CMP game_6_vars
  BEQ .need_flip
  CMP game_6_vars+1
  BEQ .need_flip
  JMP .continue

.need_flip:
  LDA #$04
  STA tempVar1

.continue:
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


  LDA #$03
  EOR tempVar1 ; tempVar1==0 if not flipping.
  ASL A
  TAY

  LDA tempVar2
  BEQ .done_right_side_check
  CMP #$02
  BEQ .bottom
  LDY #$10 ; metatile - nothing special edge
  JMP .done_right_side_check
.bottom:
  LDY #$14
.done_right_side_check:
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed
  
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;START DRAWING THE BOTTOM HALF OF THE CAR
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
