clear_board .macro
  LDA #$01
  STA needClearBoard
  .endm

update_ball .macro
  LDA #$01
  STA needUpdateBall
  .endm

update_ship .macro
  LDA #$01
  STA needUpdateShip
  .endm

update_car .macro
  LDA #$01
  STA needUpdateCar
  .endm

update_screen .macro
  LDA #$01
  STA needBoardRendering
  .endm

mute_buttons .macro
  LDA #$01
  STA muteButtons
  .endm

unmute_buttons .macro
  LDA #$00
  STA muteButtons
  .endm

reset_timer .macro
  LDA #$00
  STA timer
  STA timer+1
  .endm

write_left_only .macro
  LDX ram_board_ptr
  LDA #$01
  STA $200,x
  .endm

write_mid_only .macro
  LDX ram_board_ptr
  INX
  LDA #$01
  STA $200,x
  .endm

write_right_only .macro
  LDX ram_board_ptr
  INX
  INX
  LDA #$01
  STA $200,x
  .endm

write_left_mid .macro
  LDX ram_board_ptr
  LDA #$01
  STA $200,x
  INX
  STA $200,x
  .endm

write_mid_right .macro
  LDX ram_board_ptr
  INX
  LDA #$01
  STA $200,x
  INX
  STA $200,x
  .endm

write_left_right .macro
  LDX ram_board_ptr
  LDA #$01
  STA $200,x
  INX
  INX
  STA $200,x
  .endm
