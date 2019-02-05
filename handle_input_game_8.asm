handle_input_game_8:

  LDA muteButtons
  BNE .ignore_buttons
  JMP .dont_ignore_buttons

.ignore_buttons:
  RTS

.dont_ignore_buttons:
  LDA buttons
  ;CMP #$80
  ;BEQ pressA_game8
  ;CMP #$40
  ;BEQ pressB_game8
  CMP #$10
  BEQ pressStart_game8
  CMP #$20
  BEQ pressSelect_game8
  CMP #$08
  BEQ pressUp_game8
  CMP #$04
  BEQ pressDown_game8
  CMP #$02
  BEQ pressLeft_game8
  CMP #$01
  BEQ pressRight_game8
  RTS

pressSelect_game8:
  JMP pressSelect_game8_2
;pressB_game8:
;  JMP pressB_game8_2
;pressA_game8:
;  JMP pressA_game8_2
pressRight_game8:
  JMP pressRight_game8_2
pressLeft_game8:
  JMP pressLeft_game8_2

pressStart_game8:
  JMP handle_input_game8_done

pressUp_game8:

  LDA #$00
  STA tempVar2

  LDA snake_current
  STA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA updirs8+1, x
  PHA
  LDA updirs8, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table! 

pressDown_game8:

  LDA #$02
  STA tempVar2

  LDA snake_current
  STA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA dndirs8+1, x
  PHA
  LDA dndirs8, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

pressLeft_game8_2:

  LDA #$03
  STA tempVar2
  
  LDA snake_current
  STA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA ltdirs8+1, x
  PHA
  LDA ltdirs8, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

pressRight_game8_2:

  LDA #$01
  STA tempVar2

  LDA snake_current
  STA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA rtdirs8+1, x
  PHA
  LDA rtdirs8, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

pressA_game8_2:
  JMP handle_input_game8_done
pressB_game8_2:
  JMP handle_input_game8_done
pressSelect_game8_2:
  JMP handle_input_game8_done
handle_input_game8_done:
  RTS

updirs8:
  .word up_going_up8, up_going_right8, up_going_down8, up_going_left8
rtdirs8:
  .word rt_going_up8, rt_going_right8, rt_going_down8, rt_going_left8
dndirs8:
  .word dn_going_up8, dn_going_right8, dn_going_down8, dn_going_left8
ltdirs8:
  .word lt_going_up8, lt_going_right8, lt_going_down8, lt_going_left8

;If car dir == UP
;RT = +1
;LT = -1
;DN = +8
;UP = -8
;If car dir == DN
;RT = +9
;LT = +7
;DN = +8
;UP = -8
;If car dir == LT
;RT = +2
;LT = -2
;DN = -1
;UP = -9
;If car dir == RT
;RT = +2
;LT = -2
;DN = +1
;UP = -7

up_going_up8:
  LDA tempVar1
  SEC
  SBC #$08
  BCC go_crash8
  STA tempVar1
  JMP check_crash8

up_going_right8:
  LDA tempVar1
  SEC
  SBC #$07
  BCC go_crash8
  STA tempVar1
  JMP check_crash8

up_going_down8:
  JMP crash8

up_going_left8:
  LDA tempVar1
  SEC
  SBC #$09
  BCC go_crash8
  STA tempVar1
  JMP check_crash8

go_crash8:
  JMP crash8

rt_going_up8:
  INC tempVar1
  JMP check_crash8

rt_going_right8:
  INC tempVar1
  INC tempVar1
  JMP check_crash8

rt_going_down8:
  LDA tempVar1
  CLC
  ADC #$09
  STA tempVar1
  JMP check_crash8

rt_going_left8:
  JMP crash8

dn_going_up8:
  JMP crash8

dn_going_right8:
  INC tempVar1
  JMP check_crash8

dn_going_down8:
  LDA tempVar1
  CLC
  ADC #$08
  STA tempVar1
  JMP check_crash8

dn_going_left8:
  DEC tempVar1
  JMP check_crash8

lt_going_up8:
  DEC tempVar1
  JMP check_crash8

lt_going_right8:
  JMP crash8

lt_going_down8:
  LDA tempVar1
  CLC
  ADC #$07
  STA tempVar1
  JMP check_crash8

lt_going_left8:
  DEC tempVar1
  DEC tempVar1
  JMP check_crash8

check_crash8:
  LDA tempVar1
  CMP snake_current+3
  BEQ .crash8
  LDA tempVar1
  SEC 
  CMP #$27
  BPL .probably_crash
  AND #$07
  CMP #$07
  BEQ crash8
  JMP .update_car

.crash8:
  JMP crash8
  
.probably_crash:
  LDA tempVar1
  CMP #$29
  BEQ .update_car
  CMP #$2B
  BEQ .update_car
  CMP #$2D
  BEQ .update_car
  JMP crash8
  RTS

.update_car:
  LDA snake_current+3
  STA car_box_old
  LDA tempVar1
  STA car_box
  LDA tempVar2
  STA car_direction
  
  LDA snake_current+2
  STA snake_current+3
  LDA snake_current+1
  STA snake_current+2
  LDA snake_current
  STA snake_current+1
  LDA car_box
  STA snake_current

  LDA snake_same_metatiles+3
  SEC
  SBC snake_same_metatiles+2
  BNE .not_tempVar3
  
  LDA snake_same_metatiles+3
  STA tempVar3
  JMP .continue_update

.not_tempVar3:
  LDA #$00
  STA tempVar3

.continue_update:
  LDA #$00
  STA snake_same_metatiles
  STA snake_same_metatiles+1
  STA snake_same_metatiles+2
  STA snake_same_metatiles+3

  DEC gamestate
  update_car

  RTS

crash8:
  RTS
  
