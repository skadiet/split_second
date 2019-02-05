handle_input_game:

  ;Save for later
  LDA buttons
  STA tempVar1

  ;Use special Buttons if this method is called from game 8
  LDA current_game
  CMP #$08
  BNE .regular_update
  
  LDA game_8_ball_buttons
  STA buttons

.regular_update:
  LDA muteButtons
  BNE .ignore_buttons
  JMP .dont_ignore_buttons

.ignore_buttons:
  RTS

.dont_ignore_buttons:
  LDA buttons
  ;CMP #$80
  ;BEQ pressA_game
  ;CMP #$40
  ;BEQ pressB_game
  CMP #$10
  BEQ pressStart_game
  CMP #$20
  BEQ pressSelect_game
  ;CMP #$A0
  ;BEQ pressSelect_game
  CMP #$08
  BEQ pressUp_game
  CMP #$04
  BEQ pressDown_game
  CMP #$02
  BEQ pressLeft_game
  CMP #$01
  BEQ pressRight_game
  RTS

pressSelect_game:
  JMP pressSelect_game2
;pressB_game:
;  JMP pressB_game2
;pressA_game:
;  JMP pressA_game2
pressRight_game:
  JMP pressRight_game2
pressLeft_game:
  JMP pressLeft_game2

pressStart_game:
  JMP handle_input_game_done
pressUp_game:
  LDA ball_box
  STA ball_box_old
  SEC
  SBC #$04
  BCC .skip_move
  STA ball_box
  
  ;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ball_box_old, x
  TAX
  LDA #$01
  CMP $200, x
  BEQ .revert_move
  LDA #$05
  CMP $200, x
  BEQ .revert_move
  JMP .end_move
.revert_move:
  LDA ball_box_old
  STA ball_box
  JMP .end_move
.skip_move:
  JMP handle_input_game_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ball_box
  CMP ball_box_old
  BEQ .skip_move
  update_ball
  JSR make_boop
  JMP handle_input_game_done
pressDown_game:
  LDA ball_box
  STA ball_box_old
  CLC
  ADC #$04
  CMP #$13
  BPL .skip_move
  STA ball_box

  ;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ball_box, x
  TAX
  LDA #$01
  CMP $200, x
  BEQ .revert_move
  LDA #$05
  CMP $200, x
  BEQ .revert_move
  JMP .end_move
.revert_move:
  LDA ball_box_old
  STA ball_box
  JMP .end_move
.skip_move:
  JMP handle_input_game_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ball_box
  CMP ball_box_old
  BEQ .skip_move
  update_ball
  JSR make_boop
  JMP handle_input_game_done

pressLeft_game2:
  LDA ball_box
  STA ball_box_old
  SEC
  SBC #$01
  BCC .skip_move
  TAX
  AND #$03
  CMP #$03
  BEQ .skip_move
  STX ball_box

;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ball_box, x
  TAX
  LDA #$02
  CMP $200, x
  BEQ .revert_move
  LDA ball_box
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
  LDA ball_box_old
  STA ball_box
  JMP .end_move
.skip_move:
  JMP handle_input_game_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ball_box
  CMP ball_box_old
  BEQ .skip_move
  update_ball
  JSR make_boop
  JMP handle_input_game_done

pressRight_game2:
  LDA ball_box
  CLC
  ADC #$01
  TAX
  AND #$03
  CMP #$03
  BEQ .skip_move
  LDA ball_box
  STA ball_box_old
  STX ball_box

;collide logic
  LDA ram_board_ptr
  SEC 
  SBC #$18
  STA ram_board_ptr
  LDX #$00
  CLC
  ADC ball_box, x
  TAX
  LDA #$02
  CMP $200, x
  BEQ .revert_move
  LDA ball_box
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
  LDA ball_box_old
  STA ball_box
  JMP .end_move
.skip_move:
  JMP handle_input_game_done
.end_move:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  LDA ball_box
  CMP ball_box_old
  BEQ .skip_move
  update_ball
  JSR make_boop
  JMP handle_input_game_done
pressA_game2:
  JMP handle_input_game_done
;pressB_game2:
;  JMP handle_input_game_done
pressSelect_game2:
  JMP handle_input_game_done
handle_input_game_done:
  LDA tempVar1
  STA buttons
  RTS

make_boop:
  LDA needPlaySound
  BEQ .continue
  JSR waitVBlank
  JMP make_boop
.continue:
  LDA #SOUND_03_GAME_01_MOVE
  STA current_sound
  LDA #$01
  STA needPlaySound
  RTS
