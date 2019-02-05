handle_input_wait_start:
  LDA buttons
  CMP #$80
  BEQ pressA
  CMP #$40
  BEQ pressB
  CMP #$10
  BEQ pressStart
  CMP #$20
  BEQ pressSelect
  CMP #$A0
  BEQ pressSelect
  CMP #$08
  BEQ pressUp
  CMP #$04
  BEQ pressDown
  CMP #$02
  BEQ pressLeft
  CMP #$01
  BEQ pressRight
  CMP #$30
  BEQ .reset
  RTS
.reset:
  JMP RESET
pressStart:
  LDA timer
  STA seed2
  LDA timer+1
  STA seed2+1

  INC gamestate
  LDA score_1
  STA current_game
  JMP handle_input_wait_start_done

pressUp:
pressDown:
pressLeft:
pressRight:
pressA:
pressB:
  JMP handle_input_wait_start_done
pressSelect:

  LDA gamestate
  BEQ handle_input_wait_start_done
  
  JSR sound_game_select

  LDA #$0A
  STA hi_score_1

  LDA gamestate
  CMP #$08
  BPL .later_select
  CMP #$02
  BNE handle_input_wait_start_done
  JMP .initial_select

.later_select:
  LDA #$02
  STA gamestate
  LDA #$00
  STA score_1
  STA current_game

.initial_select:

  clear_board
  
  LDA score_1
  CLC
  ADC #$01
  STA score_1
  CMP #$09
  BEQ .back_to_1
  JSR load_level_selector_screen
  JMP handle_input_wait_start_done
.back_to_1:
  LDA #$00
  STA score_1
  JMP pressSelect
handle_input_wait_start_done:
  RTS

  .db $FF
