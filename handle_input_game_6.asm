handle_input_game_6:

  LDA muteButtons
  BNE .ignore_buttons
  JMP .dont_ignore_buttons

.ignore_buttons:
  RTS

.dont_ignore_buttons:
  LDA buttons
  ;CMP #$80
;  BEQ pressA_game6
;  CMP #$40
;  BEQ pressB_game6
  CMP #$10
  BEQ pressStart_game6
  CMP #$20
  BEQ pressSelect_game6
  CMP #$08
  BEQ pressUp_game6
  CMP #$04
  BEQ pressDown_game6
  CMP #$02
  BEQ pressLeft_game6
  CMP #$01
  BEQ pressRight_game6
  RTS

pressSelect_game6:
  JMP pressSelect_game6_2
;pressB_game6:
;  JMP pressB_game6_2
;pressA_game6:
;  JMP pressA_game6_2
pressRight_game6:
  JMP pressRight_game6_2
pressLeft_game6:
  JMP pressLeft_game6_2

pressStart_game6:
  JMP handle_input_game6_done

pressUp_game6:

  LDA #$00
  STA tempVar2

  LDA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA updirs+1, x
  PHA
  LDA updirs, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table! 

pressDown_game6:

  LDA #$02
  STA tempVar2

  LDA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA dndirs+1, x
  PHA
  LDA dndirs, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

pressLeft_game6_2:

  LDA #$03
  STA tempVar2
  
  LDA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA ltdirs+1, x
  PHA
  LDA ltdirs, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

pressRight_game6_2:

  LDA #$01
  STA tempVar2

  LDA car_box
  STA tempVar1

  LDA car_direction
  ASL A
  TAX
  LDA rtdirs+1, x
  PHA
  LDA rtdirs, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

pressA_game6_2:
  JMP handle_input_game6_done
pressB_game6_2:
  JMP handle_input_game6_done
pressSelect_game6_2:
  JMP handle_input_game6_done
handle_input_game6_done:
  RTS

updirs:
  .word up_going_up, up_going_right, up_going_down, up_going_left
rtdirs:
  .word rt_going_up, rt_going_right, rt_going_down, rt_going_left
dndirs:
  .word dn_going_up, dn_going_right, dn_going_down, dn_going_left
ltdirs:
  .word lt_going_up, lt_going_right, lt_going_down, lt_going_left

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

up_going_up:
  LDA tempVar1
  SEC
  SBC #$08
  BCC go_crash
  STA tempVar1
  JMP check_crash

up_going_right:
  LDA tempVar1
  SEC
  SBC #$07
  BCC go_crash
  STA tempVar1
  JMP check_crash

up_going_down:
  LDA tempVar1
  SEC
  SBC #$08
  BCC go_crash
  STA tempVar1
  JMP check_crash

up_going_left:
  LDA tempVar1
  SEC
  SBC #$09
  BCC go_crash
  STA tempVar1
  JMP check_crash

go_crash:
  JMP crash

rt_going_up:
  INC tempVar1
  JMP check_crash

rt_going_right:
  INC tempVar1
  INC tempVar1
  JMP check_crash

rt_going_down:
  LDA tempVar1
  CLC
  ADC #$09
  STA tempVar1
  JMP check_crash

rt_going_left:
  INC tempVar1
  INC tempVar1
  JMP check_crash

dn_going_up:
  LDA tempVar1
  CLC
  ADC #$08
  STA tempVar1
  JMP check_crash

dn_going_right:
  INC tempVar1
  JMP check_crash

dn_going_down:
  LDA tempVar1
  CLC
  ADC #$08
  STA tempVar1
  JMP check_crash

dn_going_left:
  DEC tempVar1
  JMP check_crash

lt_going_up:
  DEC tempVar1
  JMP check_crash

lt_going_right:
  DEC tempVar1
  DEC tempVar1
  JMP check_crash

lt_going_down:
  LDA tempVar1
  CLC
  ADC #$07
  STA tempVar1
  JMP check_crash

lt_going_left:
  DEC tempVar1
  DEC tempVar1
  JMP check_crash

check_crash:
  LDA tempVar1
  SEC
  CMP #$27
  BPL .probably_crash
  AND #$07
  CMP #$07
  BEQ crash
  JMP .update_car

.probably_crash:
  LDA tempVar1
  CMP #$29
  BEQ .update_car
  CMP #$2B
  BEQ .update_car
  CMP #$2D
  BEQ .update_car
  JMP crash
  RTS

.update_car:
  LDA car_box
  STA car_box_old
  LDA tempVar1
  STA car_box
  LDA tempVar2
  STA car_direction

  update_car

  RTS

crash:
  LDA #$07
  STA gamestate

  LDA timer+1
  STA car_crash_timer+1

  LDA timer
  CLC
  ADC #$20
  STA car_crash_timer

  LDA car_crash_timer+1
  ADC #$00
  STA car_crash_timer+1

  LDA #$01
  STA isMasking
  LDA car_box_old
  STA tempVar3
  LDA car_box
  STA car_box_old
  RTS
  
