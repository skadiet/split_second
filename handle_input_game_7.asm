handle_input_game_7:

  LDA muteButtons
  BNE .ignore_buttons
  JMP .dont_ignore_buttons

.ignore_buttons:
  RTS

.dont_ignore_buttons:

  LDA buttons
  BEQ .continue
  LDA maskingTimer
  CMP #$20
  BMI .bad_buttons
  JMP .continue

.bad_buttons:
  DEC gamestate
  RTS

.continue:
  LDA buttons
;  CMP #$80
;  BEQ pressA_game7
;  CMP #$40
;  BEQ pressB_game7
  CMP #$10
  BEQ pressStart_game7
  CMP #$20
  BEQ pressSelect_game7
  LDA buttons
  AND #$08
  BNE pressUp_game7
  LDA buttons
  AND #$04
  BNE pressDown_game7
  LDA buttons
  AND #$02
  BNE pressLeft_game7
  LDA buttons
  AND #$01
  BNE pressRight_game7
  RTS

pressSelect_game7:
  JMP pressSelect_game7_2
;pressB_game7:
;  JMP pressB_game7_2
;pressA_game7:
;  JMP pressA_game7_2
pressRight_game7:
  JMP pressRight_game7_2
pressLeft_game7:
  JMP pressLeft_game7_2
pressDown_game7:
  JMP pressDown_game7_2

pressStart_game7:
  JMP handle_input_game7_done

pressUp_game7:
  LDA stomp_target
  CMP #$01
  BEQ .good_input
  CMP #$04
  BEQ .good_input
  CMP #$05
  BEQ .good_input
  CMP #$09
  BEQ .good_input
;bad input
  JSR game_7_bad_sound
  JSR waitVBlank
  DEC gamestate
  JMP .end
.good_input:
  LDA stomp_input
  CMP #$FF
  BEQ .first_input
  CMP #$00
  BEQ .four_board
  CMP #$01
  BEQ .first_input
  CMP #$02
  BEQ .five_board
  CMP #$03
  BEQ .nine_board
  JMP .end
.four_board:
  LDA #$04
  JMP .draw_board
.five_board:
  LDA #$05
  JMP .draw_board
.nine_board:
  LDA #$09
  JMP .draw_board
.first_input:
  LDA #$01
.draw_board:
  STA stomp_input
  LDA #$01
  STA tempVar1
  STA needDrawGame7
.end:
  LDA buttons
  AND #$01
  BNE .jump_right
  LDA buttons
  AND #$04
  BNE .jump_down
  LDA buttons
  AND #$02
  BNE .jump_left
  JMP handle_input_game7_done
.jump_right:
  JMP pressRight_game7
.jump_down:
  JMP pressDown_game7
.jump_left:
  JMP pressLeft_game7
pressDown_game7_2:
  LDA stomp_target
  CMP #$03
  BEQ .good_input
  CMP #$06
  BEQ .good_input
  CMP #$07
  BEQ .good_input
  CMP #$09
  BEQ .good_input
;bad input
  JSR game_7_bad_sound
  JSR waitVBlank
  DEC gamestate
  JMP .end
.good_input:
  LDA stomp_input
  CMP #$FF
  BEQ .first_input
  CMP #$00
  BEQ .seven_board
  CMP #$01
  BEQ .nine_board
  CMP #$02
  BEQ .six_board
  CMP #$03
  BEQ .first_input
  JMP .end
.six_board:
  LDA #$06
  JMP .draw_board
.seven_board:
  LDA #$07
  JMP .draw_board
.nine_board:
  LDA #$09
  JMP .draw_board
.first_input:
  LDA #$03
.draw_board:
  STA stomp_input
  LDA #$01
  STA tempVar1
  STA needDrawGame7
.end:
  LDA buttons
  AND #$01
  BNE .jump_right
  LDA buttons
  AND #$02
  BNE .jump_left
  JMP handle_input_game7_done
.jump_right:
  JMP pressRight_game7
.jump_left:
  JMP pressLeft_game7
pressLeft_game7_2:
  LDA stomp_target
  CMP #$00
  BEQ .good_input
  CMP #$04
  BEQ .good_input
  CMP #$07
  BEQ .good_input
  CMP #$08
  BEQ .good_input
;bad input
  JSR game_7_bad_sound
  JSR waitVBlank
  DEC gamestate
  JMP .end
.good_input:
  LDA stomp_input
  CMP #$FF
  BEQ .first_input
  CMP #$00
  BEQ .first_input
  CMP #$01
  BEQ .four_board
  CMP #$02
  BEQ .eight_board
  CMP #$03
  BEQ .seven_board
  JMP .end
.four_board:
  LDA #$04
  JMP .draw_board
.seven_board:
  LDA #$07
  JMP .draw_board
.eight_board:
  LDA #$08
  JMP .draw_board
.first_input:
  LDA #$00
.draw_board:
  STA stomp_input
  LDA #$01
  STA tempVar1
  STA needDrawGame7
.end:
  LDA buttons
  AND #$01
  BNE .jump_right
  JMP handle_input_game7_done
.jump_right:
  JMP pressRight_game7
pressRight_game7_2:
  LDA stomp_target
  CMP #$02
  BEQ .good_input
  CMP #$05
  BEQ .good_input
  CMP #$06
  BEQ .good_input
  CMP #$08
  BEQ .good_input
;bad input
  JSR game_7_bad_sound
  JSR waitVBlank
  DEC gamestate
  JMP .end
.good_input:
  LDA stomp_input
  CMP #$FF
  BEQ .first_input
  CMP #$00
  BEQ .eight_board
  CMP #$01
  BEQ .five_board
  CMP #$02
  BEQ .first_input
  CMP #$03
  BEQ .six_board
  JMP .end
.five_board:
  LDA #$05
  JMP .draw_board
.six_board:
  LDA #$06
  JMP .draw_board
.eight_board:
  LDA #$08
  JMP .draw_board
.first_input:
  LDA #$02
.draw_board:
  STA stomp_input
  LDA #$01
  STA tempVar1
  STA needDrawGame7
.end:
  JMP handle_input_game7_done
pressA_game7_2:
  JMP handle_input_game7_done
pressB_game7_2:
  JMP handle_input_game7_done
pressSelect_game7_2:
  JMP handle_input_game7_done
handle_input_game7_done:
  RTS
