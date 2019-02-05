handle_input_auto_game_8:
  ;Using tempVar1 to show the ball direction
  ;Each direction sets tempVar1.  00 - left, 01 - up, 02 - right, 03 - down
  ;Then calls the check_snake method.  check_snake then returns SEC if it's blocked
  ;or returns CLC if it's not blocked.

.rand_loop:
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
  JMP .rand_loop
.done_random:
  STA game_8_ball_buttons
  LDA #$00
  STA isAutoMoving

  LDA game_8_ball_buttons
  CMP #$80
  BEQ pressA_game_auto_8
  CMP #$40
  BEQ pressB_game_auto_8
  CMP #$10
  BEQ pressStart_game_auto_8
  CMP #$20
  BEQ pressSelect_game_auto_8
  CMP #$A0
  BEQ pressSelect_game_auto_8
  CMP #$08
  BEQ pressUp_game_auto_8
  CMP #$04
  BEQ pressDown_game_auto_8
  CMP #$02
  BEQ pressLeft_game_auto_8
  CMP #$01
  BEQ pressRight_game_auto_8
  RTS

pressSelect_game_auto_8:
  JMP pressSelect_game_auto_8_2
pressB_game_auto_8:
  JMP pressB_game_auto_8_2
pressA_game_auto_8:
  JMP pressA_game_auto_8_2
pressRight_game_auto_8:
  JMP pressRight_game_auto_8_2
pressLeft_game_auto_8:
  JMP pressLeft_game_auto_8_2

pressStart_game_auto_8:
  JMP handle_input_game_done8
pressUp_game_auto_8:
  LDA ball_box
  STA ball_box_old
  SEC
  SBC #$04
  BCC .skip_move
  LDA #$01
  STA tempVar1
  JSR check_snake
  BCS .skip_move
  JMP .end_move
.skip_move:
  JMP handle_input_game_done8
.end_move:
  LDA ball_box
  SEC
  SBC #$04
  STA ball_box
  CMP ball_box_old
  BEQ .skip_move
  STA game_6_vars
  LDA #$01
  STA needDrawGame8
  JSR make_boop8
  JMP handle_input_game_done8
pressDown_game_auto_8:
  LDA ball_box
  STA ball_box_old
  CLC
  ADC #$04
  CMP #$13
  BPL .skip_move
  LDA #$03
  STA tempVar1
  JSR check_snake
  BCS .skip_move
  JMP .end_move
.skip_move:
  JMP handle_input_game_done8
.end_move:
  LDA ball_box
  CLC
  ADC #$04
  STA ball_box
  CMP ball_box_old
  BEQ .skip_move
  STA game_6_vars
  LDA #$01
  STA needDrawGame8
  JSR make_boop8
  JMP handle_input_game_done8

pressLeft_game_auto_8_2:
  LDA ball_box
  STA ball_box_old
  SEC
  SBC #$01
  BCC .skip_move
  TAX
  AND #$03
  CMP #$03
  BEQ .skip_move
  LDA #$00
  STA tempVar1
  JSR check_snake
  BCS .skip_move
  JMP .end_move
.skip_move:
  JMP handle_input_game_done8
.end_move:
  DEC ball_box
  LDA ball_box
  CMP ball_box_old
  BEQ .skip_move
  STA game_6_vars
  LDA #$01
  STA needDrawGame8
  JSR make_boop8
  JMP handle_input_game_done8

pressRight_game_auto_8_2:
  LDA ball_box
  STA ball_box_old
  CLC
  ADC #$01
  TAX
  AND #$03
  CMP #$03
  BEQ .skip_move
  LDA #$02
  STA tempVar1
  JSR check_snake
  BCS .skip_move
  JMP .end_move
.skip_move:
  JMP handle_input_game_done8
.end_move:
  INC ball_box
  LDA ball_box
  CMP ball_box_old
  BEQ .skip_move
  STA game_6_vars
  LDA #$01
  STA needDrawGame8
  JSR make_boop8
  JMP handle_input_game_done8
pressA_game_auto_8_2:
  JMP handle_input_game_done8
pressB_game_auto_8_2:
  JMP handle_input_game_done8
pressSelect_game_auto_8_2:
  JMP handle_input_game_done8
handle_input_game_done8:
  RTS

make_boop8:
  LDA needPlaySound
  BEQ .continue
  JSR waitVBlank
  JMP make_boop8
.continue:
  LDA #SOUND_03_GAME_01_MOVE
  STA current_sound
  LDA #$01
  STA needPlaySound
  RTS

check_snake:
  ;00 - left, 01 - up, 02 - right, 03 - down
  LDA ball_box
  ASL A
  TAX
  LDA tempVar1
  BEQ .isBlockedLeft
  DEC tempVar1
  BEQ .isBlockedUp
  DEC tempVar1
  BEQ .isBlockedRight
  
.isBlockedDown:
  TXA
  CLC
  ADC #$09
  TAX
  JMP .check_segments

.isBlockedLeft:
  JMP .check_segments

.isBlockedUp:
  INX
  JMP .check_segments

.isBlockedRight:
  INX
  INX
  JMP .check_segments 

.check_segments:
  CPX snake_current
  BEQ .blocked
  CPX snake_current+1
  BEQ .blocked
  CPX snake_current+2
  BEQ .blocked
  CPX snake_current+3
  BEQ .blocked

.not_blocked:
  CLC
  RTS

.blocked:
  SEC
  RTS
