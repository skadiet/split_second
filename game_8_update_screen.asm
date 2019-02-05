drawGame8:
  ;Using Y to drive the metatile.
  ;If Y=07 then we will update the ball as is. Metatile #$07
  ;If Y=04 then we will update the ball with left side.  Metatile #$04
  ;If Y=05 then we will update the ball with top only.   Metatile #$05
  ;If Y=06 then we will update the ball with left+top.   Metatile #$06

  ;Here's some extra logic.  We're going to take two passes through this code.
  ;tempVar1 will be the loop counter
  ;Pass one, ball_box_old=tempVar2.  Pass two, ball_box=tempVar2
  ;Pass one, tempVar3=$04 to EOR the metatile with.  Pass two, tempVar3=00 to EOR with.
  LDA #$02
  STA tempVar1
  LDA ball_box_old
  STA tempVar2
  LDA #$04
  STA tempVar3

.loop:

  LDY #$07

  LDA tempVar2
  ASL A
  TAX
  INX
  CMP snake_current
  BEQ .special_udpate_1
  CPX snake_current
  BEQ .special_udpate_1

  CMP snake_current+1
  BEQ .special_udpate_2
  CPX snake_current+1
  BEQ .special_udpate_2

  CMP snake_current+2
  BEQ .special_udpate_3
  CPX snake_current+2
  BEQ .special_udpate_3

  CMP snake_current+3
  BEQ .special_udpate_4
  CPX snake_current+3
  BEQ .special_udpate_4

  JMP .continue1

.special_udpate_1:
  LDA snake_same_metatiles
  BNE .draw_both
    LDA #$01
    BIT snake_current
    BNE .top1
      LDY #$04
      JMP .continue1
.top1:
  LDY #$05
  JMP .continue1

.special_udpate_2:
  LDA snake_same_metatiles+1
  BNE .draw_both
    LDA #$01
    BIT snake_current+1
    BNE .top2
      LDY #$04
      JMP .continue1
.top2:
  LDY #$05
  JMP .continue1

.special_udpate_3:
  LDA snake_same_metatiles+2
  BNE .draw_both
    LDA #$01
    BIT snake_current+2
    BNE .top3
      LDY #$04
      JMP .continue1
.top3:
  LDY #$05
  JMP .continue1

.special_udpate_4:
  LDA snake_same_metatiles+3
  BNE .draw_both
    LDA #$01
    BIT snake_current+3
    BNE .top4
      LDY #$04
      JMP .continue1
.top4:
  LDY #$05
  JMP .continue1

.draw_both:
  LDY #$06

.continue1:

;.skip_check_bottom:
  TYA
  EOR tempVar3
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA tempVar2
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

  DEC tempVar1
  BEQ .end_loop
  LDA ball_box
  STA tempVar2
  LDA #$00
  STA tempVar3
  JMP .loop

.end_loop:
  RTS

loadSnakeBuffer:

  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA #$00
  STA tempVar1 ; use this for EORing.  If 00, the metatile won't change.  If #$04, it will flip the ball.
  STA tempVar2 ; 0=Normal ; 1=RightSide

  ;find out if the car is at the right side of the wall.  if it is, set tempVar2==1
  LDA car_box
  AND #%11111110
  LSR A
  LSR A
  BCC .check_bottom_side
  LSR A
  BCC .check_bottom_side
.yes_right_side:
  LDA #$01
  STA tempVar2
  JMP .continue3
.check_bottom_side:
  LDA car_box
  CMP #$29
  BMI .continue3
  LDA #$02
  STA tempVar2
.continue3:
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
  JMP .continue2

;might_need_flip is needed because we only want to flip the ball on if the old cones have not been removed
;if we just blindly flip for the old cones then they will re-appear after they have already been removed.
.might_need_flip: 
  LDA need_remove_cones
  BNE .need_flip
  JMP .continue2

.need_flip:
  LDA #$04
  STA tempVar1

.continue2:
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA snake_buffer ; $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA snake_buffer+1 ;$2006

 ;If tempVar3=1 then draw angled snake segments in the same metatile.
  LDA tempVar3
  BNE .both
  JMP .just_one
.just_one:
  LDA car_box
  AND #$01
  JMP .check_both_done
.both:
  LDA #$02
.check_both_done
  EOR tempVar1 ; tempVar1==0 if not flipping.
  ASL A
  TAY

  ;if car is on the right side, we need to use metatile - left special edge
  LDA tempVar2
  CMP #$01
  BEQ .set_right_metatile
  CMP #$02
  BEQ .set_bottom_metatile
  JMP .done_right_side_check
  
.set_right_metatile:
  LDY #$12
  JMP .done_right_side_check

.set_bottom_metatile:
  LDY #$16

.done_right_side_check:
;This section is for crashing logic only.
  LDA isCrashing ; test test
  BNE .is_masking
  JMP .masking_complete
.is_masking:
  LDA tempVar2
  BEQ .not_mask_right_side
  LDY #$10 ;metatile - nothing special edge
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
  STA snake_buffer+2
  INY
  LDA [meta_tile_ptr],y
  STA snake_buffer+3

  LDA #$FF
  STA snake_buffer+4

  ;START DRAWING THE BOTTOM HALF OF THE CAR
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA snake_buffer+5
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA snake_buffer+6

  LDY #$03
  LDA [meta_tile_ptr],y
  STA snake_buffer+7
  INY
  LDA [meta_tile_ptr],y
  STA snake_buffer+8

  LDA #$FF
  STA snake_buffer+9

  RTS

isByteInSameMetatile:
  ;This method expects two arguments to be passed in 
  ;   via the tempVar1 and tempVar2 variables.
  ;It will return a boolean value in tempVar3 == True 
  ;   if the two car_boxes reside in the same metatile.
  LDA tempVar1
  AND #$01
  STA tempVar3

  LDA tempVar2
  AND #$01
  CMP tempVar3
  BNE .check_significant_bits
  JMP .need_draw_byte_1

.check_significant_bits:
  LDA tempVar1
  AND #$F8
  STA tempVar3

  LDA tempVar2
  AND #$F8
  CMP tempVar3
  BEQ .check_other_bits
  JMP .need_draw_byte_1

.check_other_bits:  
  LDA tempVar1
  AND #$06
  STA tempVar3
  
  LDA tempVar2
  AND #$06
  CMP tempVar3
  BNE .need_draw_byte_1
  JMP .need_draw_byte_1_and_2

.need_draw_byte_1:
  LDA #$00
  STA tempVar3
  RTS

.need_draw_byte_1_and_2:
  LDA #$01
  STA tempVar3
  RTS