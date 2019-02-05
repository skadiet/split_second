drawGame7:
  ;The code expects tempVar1 to be set before calling this method
  ;tempVar1==0 means no ball and tempVar2 == yes ball
  ;This will tell help the code figure out which boxes should be drawn with a ball and which should not.

  LDA tempVar1
  BEQ .draw_target_board
;draw update board
  LDA stomp_input
  JMP .start_draw
.draw_target_board:
  LDA stomp_target
.start_draw:
  ASL A
  TAX
  LDA game_7_boards+1, x
  PHA
  LDA game_7_boards, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

game_7_boards:
  .dw gm_7_00, gm_7_01, gm_7_02, gm_7_03
  .dw gm_7_04, gm_7_05, gm_7_06, gm_7_07
  .dw gm_7_08, gm_7_09

gm_7_00:
  JSR draw_7_00
  RTS

gm_7_01:
  JSR draw_7_01
  RTS

gm_7_02:
  JSR draw_7_02
  RTS

gm_7_03:
  JSR draw_7_03
  RTS

gm_7_04:
  JSR draw_7_00
  JSR draw_7_01
  RTS

gm_7_05:
  JSR draw_7_01
  JSR draw_7_02
  RTS

gm_7_06:
  JSR draw_7_02
  JSR draw_7_03
  RTS

gm_7_07:
  JSR draw_7_03
  JSR draw_7_00
  RTS

gm_7_08:
  JSR draw_7_00
  JSR draw_7_02
  RTS

gm_7_09:
  JSR draw_7_01
  JSR draw_7_03
  RTS

draw_7_00:

  LDA tempVar1
  BNE .draw_ball

;;;;;;;;;;;do_not_draw_ball
  ;top of left_and_top_no_ball (02)
  LDA #$21
  STA $2006
  LDA #$AD
  STA $2006

  LDA #$23
  STA $2007
  LDA #$24
  STA $2007

  ;bottom of left_and_top_no_ball (02)
  LDA #$21
  STA $2006
  LDA #$CD
  STA $2006

  LDA #$33
  STA $2007
  LDA #$34
  STA $2007

  JMP .continue

;;;;;;;;do draw ball
.draw_ball:

  ;top of left_and_top_yes_ball (06)
  LDA #$21
  STA $2006
  LDA #$AD
  STA $2006

  LDA #$20
  STA $2007
  LDA #$21
  STA $2007

  ;bottom of left_and_top_yes_ball (06)
  LDA #$21
  STA $2006
  LDA #$CD
  STA $2006

  LDA #$30
  STA $2007
  LDA #$31
  STA $2007

.continue:
  ;top of top_no_ball (01)
  LDA #$21
  STA $2006
  LDA #$ED
  STA $2006

  LDA #$40
  STA $2007
  LDA #$41
  STA $2007

  RTS
  
draw_7_01:

  LDA tempVar1
  BNE .draw_ball

;;;;;;;;;;;do_not_draw_ball
  ;top of left_and_top_no_ball (02)
  LDA #$21
  STA $2006
  LDA #$6F
  STA $2006

  LDA #$23
  STA $2007
  LDA #$24
  STA $2007

  ;bottom of left_and_top_no_ball (02)
  LDA #$21
  STA $2006
  LDA #$8F
  STA $2006

  LDA #$33
  STA $2007
  LDA #$34
  STA $2007

  JMP .continue

;;;;;;;;do draw ball
.draw_ball:

  ;top of left_and_top_yes_ball (06)
  LDA #$21
  STA $2006
  LDA #$6F
  STA $2006

  LDA #$20
  STA $2007
  LDA #$21
  STA $2007

  ;bottom of left_and_top_yes_ball (06)
  LDA #$21
  STA $2006
  LDA #$8F
  STA $2006

  LDA #$30
  STA $2007
  LDA #$31
  STA $2007

.continue:

  ;top of left_no_ball (00)
  LDA #$21
  STA $2006
  LDA #$71
  STA $2006

  LDA #$22
  STA $2007

  ;bottom of left_no_ball (00)
  LDA #$21
  STA $2006
  LDA #$91
  STA $2006

  LDA #$32
  STA $2007

  RTS

draw_7_02:

  LDA tempVar1
  BNE .draw_ball

;;;;;;;;;;;do_not_draw_ball
  ;top of top_no_ball (01)
  LDA #$21
  STA $2006
  LDA #$B1
  STA $2006

  LDA #$40
  STA $2007
  LDA #$41
  STA $2007

  JMP .continue

.draw_ball:

  ;top of top_yes_ball (05)
  LDA #$21
  STA $2006
  LDA #$B1
  STA $2006

  LDA #$25
  STA $2007
  LDA #$26
  STA $2007

  ;bottom of top_yes_ball (05)
  LDA #$21
  STA $2006
  LDA #$D1
  STA $2006

  LDA #$35
  STA $2007
  LDA #$36
  STA $2007

.continue:
  ;top of left_no_ball (00)
  LDA #$21
  STA $2006
  LDA #$B3
  STA $2006

  LDA #$2D
  STA $2007

  ;bottom of left_no_ball (00)
  LDA #$21
  STA $2006
  LDA #$D3
  STA $2006

  LDA #$3D
  STA $2007

  ;top of top_no_ball (01)
  LDA #$21
  STA $2006
  LDA #$F1
  STA $2006

  LDA #$40
  STA $2007
  LDA #$41
  STA $2007

;if stomp_target==6 we have to redraw the top right corner of the basket
  LDA stomp_target
  CMP #$06
  BNE .end

  ;top of left_and_top_no_ball (02)
  LDA #$21
  STA $2006
  LDA #$F1
  STA $2006

  LDA #$23
  STA $2007

.end:
  RTS

draw_7_03:

  LDA tempVar1
  BNE .draw_ball

  ;top of left_no_ball (00)
  LDA #$21
  STA $2006
  LDA #$EF
  STA $2006

  LDA #$22
  STA $2007

  ;bottom of left_no_ball (00)
  LDA #$22
  STA $2006
  LDA #$0F
  STA $2006

  LDA #$32
  STA $2007

  JMP .continue

.draw_ball:
  ;top of left_yes_ball (04)
  LDA #$21
  STA $2006
  LDA #$EF
  STA $2006

  LDA #$27
  STA $2007
  LDA #$28
  STA $2007

  ;bottom of left_yes_ball (04)
  LDA #$22
  STA $2006
  LDA #$0F
  STA $2006

  LDA #$37
  STA $2007
  LDA #$38
  STA $2007


.continue:
  ;top of left_no_ball (00)
  LDA #$21
  STA $2006
  LDA #$F1
  STA $2006

  LDA #$22
  STA $2007

  ;bottom of left_no_ball (00)
  LDA #$22
  STA $2006
  LDA #$11
  STA $2006

  LDA #$32
  STA $2007

  ;top of top_no_ball (01)
  LDA #$22
  STA $2006
  LDA #$2F
  STA $2006

  LDA #$40
  STA $2007
  LDA #$41
  STA $2007

;if stomp_target==6 we have to redraw the top right corner of the basket
  LDA stomp_target
  CMP #$06
  BNE .end

  ;top of left_and_top_no_ball (02)
  LDA #$21
  STA $2006
  LDA #$F1
  STA $2006

  LDA #$23
  STA $2007

.end
  RTS

