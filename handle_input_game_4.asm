handle_input_game_4:

  LDA isAutoMoving
  BEQ .not_auto_moving

  JSR rand_num
  LDA seed
  AND #%00000001
  BNE .done_random
  LDA seed
  AND #%00000010
  BNE .done_random
  LDA seed
  AND #%00000100
  BNE .done_random
  LDA seed
  AND #%00001000
  BNE .done_random
  LDA #$00
.done_random:
  STA buttons
  LDA #$00
  STA isAutoMoving
  LDA #$01
  JSR waitVBlank
  ;JSR waitVBlank
  STA game_4_wait
  JMP .dont_ignore_buttons

.not_auto_moving:
  LDA muteButtons
  BNE .ignore_buttons
  JMP .dont_ignore_buttons

.ignore_buttons:
  RTS

.dont_ignore_buttons:
  LDA buttons
  CMP #$80
  BEQ pressA_game4
  CMP #$40
  BEQ pressB_game4
  CMP #$10
  BEQ pressStart_game4
  CMP #$20
  BEQ pressSelect_game4
  CMP #$08
  BEQ pressUp_game4
  CMP #$04
  BEQ pressDown_game4
  CMP #$02
  BEQ pressLeft_game4
  CMP #$01
  BEQ pressRight_game4
  RTS

pressSelect_game4:
  JMP pressSelect_game4_2
pressB_game4:
  JMP pressB_game4_2
pressA_game4:
  JMP pressA_game4_2
pressRight_game4:
  JMP pressRight_game4_2
pressLeft_game4:
  JMP pressLeft_game4_2

pressStart_game4:
  JMP pressA_game4_2
pressUp_game4:
  LDA ship_box
  STA ship_box_old
  SEC
  SBC #$04
  BCC .skip_move
  STA ship_box
  
  ;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ship_box_old, x
  TAX
  LDA #$01
  CMP $200, x
  BEQ .revert_move
  LDA #$05
  CMP $200, x
  BEQ .revert_move
  JMP .end_move
.revert_move:
  LDA ship_box_old
  STA ship_box
  JMP .end_move
.skip_move:
  JMP handle_input_game4_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ship_box
  CMP ship_box_old
  BEQ .skip_move
  update_ship
  JMP handle_input_game4_done
pressDown_game4:
  LDA ship_box
  STA ship_box_old
  CLC
  ADC #$04
  CMP #$13
  BPL .skip_move
  STA ship_box

  ;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ship_box, x
  TAX
  LDA #$01
  CMP $200, x
  BEQ .revert_move
  LDA #$05
  CMP $200, x
  BEQ .revert_move
  JMP .end_move
.revert_move:
  LDA ship_box_old
  STA ship_box
  JMP .end_move
.skip_move:
  JMP handle_input_game4_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ship_box
  CMP ship_box_old
  BEQ .skip_move
  update_ship
  JMP handle_input_game4_done

pressLeft_game4_2:
  LDA ship_box
  STA ship_box_old
  SEC
  SBC #$01
  BCC .skip_move
  TAX
  AND #$03
  CMP #$03
  BEQ .skip_move
  STX ship_box

;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ship_box, x
  TAX
  LDA #$02
  CMP $200, x
  BEQ .revert_move
  LDA ship_box
  CMP #$10
  BMI .skip_bottom_check
  LDA #$00
  CMP $200, x
  BNE .skip_bottom_check
  INX
  LDA #$04
  CMP $200, x
  BEQ .revert_move
  DEX
  JMP .skip_bottom_check
.skip_bottom_check:
  JMP .end_move
.revert_move:
  LDA ship_box_old
  STA ship_box
  JMP .end_move
.skip_move:
  JMP handle_input_game4_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ship_box
  CMP ship_box_old
  BEQ .skip_move
  update_ship
  JMP handle_input_game4_done

pressRight_game4_2:
  LDA ship_box
  STA ship_box_old
  CLC
  ADC #$01
  TAX
  AND #$03
  CMP #$03
  BEQ .skip_move
  LDA ship_box
  STA ship_box_old
  STX ship_box

;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ship_box, x
  TAX
  LDA #$02
  CMP $200, x
  BEQ .revert_move
  LDA ship_box
  CMP #$10
  BMI .skip_bottom_check
;  INX
  LDA #$00
  CMP $200, x
  BEQ .revert_move
;  DEX
  JMP .skip_bottom_check
.skip_bottom_check:
  JMP .end_move
.revert_move:
  LDA ship_box_old
  STA ship_box
  JMP .end_move
.skip_move:
  JMP handle_input_game4_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ship_box
  CMP ship_box_old
  BEQ .skip_move
  update_ship
  JMP handle_input_game4_done
pressA_game4_2:

  LDA #SOUND_06_GAME_04_GUN_SOUND
  STA current_sound
  LDA #$01
  STA needPlaySound

  LDA ship_box
  CMP #$09
  BEQ .light_fireworks
  JMP .dud
.light_fireworks:
  mute_buttons
  INC gamestate
  JMP .endA
.dud:
  LDA #$00
  STA tempVar3 ; number of NMIs needed to shoot the lasers
  LDA #$01
  STA muteButtons
  STA isMissing
  JMP .endA
.endA:
  JMP handle_input_game4_done
pressB_game4_2:
  JMP pressA_game4_2
pressSelect_game4_2:
  JMP pressA_game4_2
handle_input_game4_done:
  LDA game_4_wait
  BEQ .end
  LDA #$00
  STA game_4_wait
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
.end:
  RTS
