;ines headers
    .inesprg 1 ; 1 x 16KB PRG code
    .ineschr 1 ; 1 x 8 KB CHR data
    .inesmap 0 ; 0=NROM, no bank swapping
    .inesmir 1 ; 1 = VERT mirroring for HORIZ scrolling

    .rsset $0000
meta_tiles_ptr .rs 2
meta_tile_ptr .rs 2
meta_tile_ppu_addr_coords_ptr .rs 2
meta_tile_ppu_addr_coord_ptr .rs 2
scores_ptr .rs 2
number_ptr .rs 2
seed .rs 2                ; CD
gamestate .rs 1
sleeping .rs 1            ;F
ppu_x_coord .rs 1         ;10
ppu_y_coord .rs 1
dbuffer_index .rs 1
textPointer1Lo .rs 1
textPointer1Hi .rs 1 
buttons_this .rs 1        ;15
buttons_last .rs 1
buttons .rs 1
needDrawBuffer .rs 1
attributeLo .rs 1
attributeHi .rs 1
board_ptr .rs 2
box_ptr .rs 1             ;1D
score_1 .rs 1             ;1E
score_2 .rs 1             ;1F
score_3 .rs 1             ;20
hi_score_1 .rs 1          ;21
hi_score_2 .rs 1          ;22
hi_score_3 .rs 1          ;23
score_looper .rs 1
;timer_on .rs 1
game_4_wait .rs 1
timer .rs 2
difficulty_timer .rs 2
backgroundLo .rs 1
backgroundHi .rs 1
counterLo .rs 1
counterHi .rs 1
needDrawFullScreen .rs 1
needClearBoard .rs 1
needClearBoard2 .rs 1
PPUCTRL_2000_Buffer .rs 1 ;2E
PPUMASK_2001_Buffer .rs 1
ball_box .rs 1            ;30
ball_box_old .rs 1
current_game .rs 1
ram_board_ptr .rs 1
mad_maze_number .rs 1  ;37
needBoardRendering .rs 1
needBoardRendering2 .rs 1
needUpdateBall .rs 1
needEraseBall .rs 1
needUpdateShip .rs 1
needEraseShip .rs 1
clear_ball .rs 1
isMasking .rs 1
isFirstMasking .rs 1
isAutoMoving .rs 1
maskingTimer .rs 1
ship_box .rs 1
ship_box_old .rs 1
car_box .rs 1
car_box_old .rs 1
tempVar1 .rs 1
tempVar2 .rs 1
tempVar3 .rs 1
tempVar4 .rs 1
muteButtons .rs 1
difficulty .rs 1 ;48 in mem
move_trigger .rs 1 ;49 in mem
seed2 .rs 2 
game_6_vars .rs 4 ;[ballBox1, ballBox2, lineWinner, lineStart]
game_6_vars_old .rs 4 ;[ballBox1, ballBox2, lineWinner, lineStart]
needUpdateCar .rs 1
needEraseCar .rs 1
car_position .rs 1
car_position_old .rs 1
car_direction .rs 1 ; 0-UP ; 1-RT ; 2-DN ; 3-LT
nametable_address_hi .rs 1
game_6_checked_ball_2 .rs 1
need_new_cones .rs 1  ;5D
need_remove_cones .rs 1
needEraseCones .rs 1
needDrawGame7 .rs 1
stomp_input .rs 1
stomp_target .rs 1
needPlaySound .rs 1
current_sound .rs 1
current_sound_length .rs 1
current_sound_address_lo .rs 2
current_sound_address_hi .rs 2
current_sound_pointer .rs 1
car_crash_timer .rs 2
isCrashing .rs 1
needDrawGame8 .rs 1
needEraseGame8 .rs 1
snake_current .rs 4
snake_winner .rs 4
snake_same_metatiles .rs 4
snake_metatiles .rs 4
snake_segment .rs 1
snake_buffer .rs 10 ;{$2006, $2006, $2007, $2007, #$FF} x2
game_8_ball_buttons .rs 1
isMissing .rs 1
nmis .rs 1
detecting_tv .rs 1
tv_region .rs 1
nmi_show_board_routine .rs 1

    .rsset $0091
debug .rs 15

;;;;;;;;;;;;;;;
; NES is powererd on
;    
  .bank 0 ; NESASM arranges things into 8KB chunks, this is chunk 0
  .org $8000 ; Tells the assembler where to start in this 8kb chunk
RESET:
  SEI          ; disable IRQs
  CLD          ; disable decimal mode, meant to make decimal arithmetic "easier"
  LDX #$40
  STX $4017    ; disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; now X = 0
  STX $2000    ; disable NMI
  STX $2001    ; disable rendering
  STX $4010    ; disable DMC IRQs

vblankwait1:       ; First wait for vblank to make sure PPU is ready
  BIT $2002
  BPL vblankwait1

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x
  INX
  BNE clrmem
   
vblankwait2:      ; Second wait for vblank, PPU is ready after this
  BIT $2002
  BPL vblankwait2

  .include "initialize_palette.asm"
  .include "initialize_attributes.asm"
  .include "initialize_macros.asm"

;  PPUCTRL ($2000)
;  76543210
;  | ||||||
;  | ||||++- Base nametable address
;  | ||||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
;  | |||+--- VRAM address increment per CPU read/write of PPUDATA
;  | |||     (0: increment by 1, going across; 1: increment by 32, going down)
;  | ||+---- Sprite pattern table address for 8x8 sprites (0: $0000; 1: $1000)
;  | |+----- Background pattern table address (0: $0000; 1: $1000)
;  | +------ Sprite size (0: 8x8; 1: 8x16)
;  |
;  +-------- Generate an NMI at the start of the
;            vertical blanking interval vblank (0: off; 1: on)              
  LDA #%10000001   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  STA PPUCTRL_2000_Buffer

;  PPUMASK ($2001)
;  binary byte flags
;  76543210
;  ||||||||
;  |||||||+- Grayscale (0: normal color; 1: AND all palette entries
;  |||||||   with 0x30, effectively producing a monochrome display;
;  |||||||   note that colour emphasis STILL works when this is on!)
;  ||||||+-- Disable background clipping in leftmost 8 pixels of screen
;  |||||+--- Disable sprite clipping in leftmost 8 pixels of screen
;  ||||+---- Enable background rendering
;  |||+----- Enable sprite rendering
;  ||+------ Intensify reds (and darken other colors)
;  |+------- Intensify greens (and darken other colors)
;  +-------- Intensify blues (and darken other colors)
  ;LDA #%00001110   ; enable sprites, enable background, no clipping on left side
  ;STA $2001
  ;STA PPUMASK_2001_Buffer

SOUND_00_GAME_01_WIN = $00
SOUND_01_INTRO_SOUND = $02
SOUND_03_GAME_01_MOVE = $04
SOUND_04_HIGH_SCORE = $06
SOUND_04_HIGH_SCORE_2 = $08
SOUND_05_LOWER_SCORE = $0A
SOUND_06_GAME_04_GUN_SOUND = $0C
SOUND_07_GAME_06_BLOOP_SOUND = $0E
SOUND_08_GAME_07_BAD_SOUND = $10
SOUND_09_GAME_07_GOOD_SOUND = $12
SOUND_10_GAME_08_BLEEP_SOUND = $14
SOUND_11_GAME_SELECT_SOUND = $16
SOUND_12_TIE_SCORE = $18

DIFFICULTY_HARD = $0C
DIFFICULTY_MEDIUM = $18
DIFFICULTY_EASY = $00

  LDA #$00
  STA gamestate

  LDA #$0A
  STA hi_score_1

  LDA #%00001001
  STA $4015
  LDA #$01
  STA score_1

  LDA #%10011111 ;Duty 10, Length Counter Disabled, Saw Envelopes disabled, Volume F
  STA $4000

  JSR load_intro_background
  ;JSR loadIntroScreen1
  JSR waitVBlank
  JSR waitVBlank
  JSR load_hand_held_background
  JSR waitVBlank
  JSR waitVBlank
  LDA #%00101000
  STA $2001
  STA PPUMASK_2001_Buffer

  JSR detect_tv_setting
  STA tv_region ;$00 - NTSC || $01 - PAL || $02 - Dendry || $03 - Other

forever:
  INC sleeping ;go to sleep (wait for NMI).
loop_forever:

  CLC
  LDA seed
  ADC #$01
  STA seed
  LDA seed+1
  ADC #$00
  STA seed+1

  LDA sleeping
  BNE loop_forever ;wait for NMI to clear the sleeping flag and wake us up

  JSR ReadController1

  LDA gamestate
  CMP #$00
  BEQ .wait_start
  CMP #$01
  BEQ .setup_game_menu
  CMP #$02
  BEQ .game_menu
  JMP pick_game_to_run
  JMP forever
.wait_start:
  JSR handle_input_wait_start
  JMP forever
.setup_game_menu:
  LDA PPUCTRL_2000_Buffer
  EOR #%00010001
  STA PPUCTRL_2000_Buffer
  
  JSR sound_game_select
  clear_board

  LDA #$01
  STA score_1
  JSR load_level_selector_screen
  INC gamestate
  JMP forever
.game_menu:  
  JSR handle_input_wait_start
  JMP forever
pick_game_to_run:
  LDA current_game
  ASL A
  TAX
  LDA gamestates+1, x
  PHA
  LDA gamestates, x
  PHA
  PHP ;this simulates getting a 16 bit address into mem for RTI
  RTI ;this is not a normal RTI, no.  This is a special RTI to jump to a table!

gamestates:
  .word $0000,game_1,game_1,game_1,game_4,game_4,game_6,game_7,game_8

game_1:

  LDA gamestate
  CMP #$03
  BEQ .initialize_game_1
  CMP #$04
  BEQ .load_boards_into_ram
  CMP #$05
  BEQ .copy_current_board_into_ram
  CMP #$06
  BEQ .display_current_board
  CMP #$07
  BEQ .play_game_1
  CMP #$08
  BEQ .game_1_winner
  CMP #$09
  BEQ .game_1_gameover
  CMP #$0A
  BEQ .game_1_score
  CMP #$0B
  BEQ .game_1_stop_wait_input
  CMP #$0C
  BEQ .game_1_reset_first_board
  CMP #$0D
  BEQ .check_play_game_1_win_sound
  CMP #$FE
  BEQ .check_game_1_boop_sound
  JMP forever

.load_boards_into_ram:
  JMP load_boards_into_ram
.copy_current_board_into_ram:
  JMP copy_current_board_into_ram
.display_current_board:
  JMP display_current_board
.play_game_1:
  JMP play_game_1
.game_1_winner:
  JMP game_1_winner
.game_1_gameover:
  JMP game_1_gameover
.game_1_score:
  JMP game_1_score
.game_1_stop_wait_input:
  JMP game_1_stop_wait_input
.game_1_reset_first_board:
  JMP game_1_reset_first_board
.check_play_game_1_win_sound:
  JMP check_play_game_1_win_sound
.check_game_1_boop_sound:
  JMP check_game_1_boop_sound

.initialize_game_1:
  ;initilize all RAM to $FF
  LDX #$00
.init_loop:
  LDA #$03
  STA $200, x
  INX
  TXA
  CMP #$F0
  BNE .init_loop

  JSR waitVBlank

  LDA #$08
  LDY #$3C
  LDX #$00
.load_wall:
  STA $203,x
  INX
  INX
  INX
  INX
  DEY
  BNE .load_wall

  clear_board

  LDA #$00
  STA ram_board_ptr
  STA mad_maze_number
  
  LDA #$11
  STA ball_box
  LDA #$11
  STA ball_box_old

  JSR intro_sound
  INC gamestate

  JMP forever

load_boards_into_ram:
  
  LDA ram_board_ptr
  CMP #$F0
  BEQ .done_loading
  JSR game_1_load_board
  INC mad_maze_number
  JMP forever
  
.done_loading:
  INC gamestate
  LDA #$00
  STA ram_board_ptr
  reset_timer
  STA mad_maze_number
  JMP forever

copy_current_board_into_ram:

  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr
  JSR load_tiles_into_ram

.finish_up:
  INC gamestate
  JMP forever

display_current_board:

  update_screen
  update_ball
  
  JSR waitVBlank

  LDA #$00
  STA isMasking
  STA maskingTimer

  INC gamestate
  JMP forever

play_game_1:

  JSR check_gameover
  BCS .game_over

.check_needs_masking:

  LDA current_game
  CMP #$02
  BNE .keep_going
  
  LDA isMasking
  BEQ .keep_muting
  JMP .muting_not_needed

.keep_muting:
  mute_buttons

.muting_not_needed:
  LDA maskingTimer
  CMP #$20
  BEQ .needs_masking
  JMP .keep_going
  
.needs_masking:
  LDA isMasking
  BNE .keep_going

  LDA #$01
  STA isMasking
  ;JSR mask_tiles_in_ram
  JSR mask_tiles_in_ram_new
  JSR turn_off_ball
  update_ball
  unmute_buttons
  JMP forever

.game_over:
  INC gamestate
  INC gamestate
  JMP forever
.keep_going:
  LDA ram_board_ptr
  SEC
  SBC #$18
  STA ram_board_ptr

  LDA #$02
  STA board_ptr+1
  LDA ram_board_ptr
  STA board_ptr

  LDA ball_box
  CMP #$04
  BMI .check_top
  CMP #$10
  BPL .check_bottom
  JMP .finish_winner_check
  
.check_bottom:
  LDY #$03
  LDA board_ptr
  CLC
  ADC #$10
  STA board_ptr
.loop_bottom:
  LDA #$04
  CMP [board_ptr], y
  BNE .skip_next
  INY
  LDA #$00
  CMP [board_ptr], y
  BEQ .winner
  LDA #$09
  CMP [board_ptr], y
  BEQ .winner
  DEY
.skip_next:
  DEY
  BPL .loop_bottom
  JMP .finish_winner_check

.check_top:
  LDY #$03
  LDA #$06
.loop_top:
  CMP [board_ptr], y
  BNE .skip_next2
  JMP .winner
.skip_next2:
  DEY
  BPL .loop_top
  JMP .finish_winner_check

.finish_winner_check:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr

;otherwise - if not a winner....
 ;need these checks to ensure that the ball doesn't switch too fast between screens.
  LDA needBoardRendering
  BNE .end
  LDA needBoardRendering2
  BNE .end
  LDA needUpdateBall
  BNE .end
  LDA needEraseBall
  BNE .end
  JSR handle_input_game
  JMP .end

.winner:
  LDA ram_board_ptr
  CLC
  ADC #$18
  STA ram_board_ptr

  INC gamestate
  JMP forever
.end:
  JMP forever
game_1_winner:
  LDA ball_box
  STA ball_box_old
  JSR turn_off_ball

;this fixes the timing between the ball landing in the basket
;and the time that the screen goes blank.
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  clear_board

  INC mad_maze_number

.wait_until_sound_off:
  LDA needPlaySound
  BEQ .done_waiting
  JSR waitVBlank
  JMP .wait_until_sound_off
.done_waiting:
  LDA #SOUND_00_GAME_01_WIN
  STA current_sound
  LDA #$01
  STA needPlaySound
  
  LDA #$0D
  STA gamestate
  JMP forever

winner_for_real:
  LDA #$00
  STA score_1
  STA score_2
  STA score_3

  LDA tv_region
  BNE .go_pal_loops
  JMP .ntsc_loops
.go_pal_loops:
  JMP .pal_loops
.ntsc_loops:
  LDA timer+1
  CMP #$17
  BMI .tens_loop
  LDA #$09
  STA score_1
  STA score_2
  STA score_3
  JMP .end_win_forever

.tens_loop:
  LDA timer+1
  CMP #$03
  BPL .add_to_score1
  CMP #$02
  BMI .ones_loop
  LDA timer
  SEC
  SBC #$4D
  BCS .add_to_score1
  JMP .ones_loop

.add_to_score1:
  INC score_1
  LDA timer
  SEC
  SBC #$4D
  STA timer
  LDA timer+1
  SBC #$02
  STA timer+1
  JMP .tens_loop

.ones_loop:
  LDA timer+1
  CMP #$01
  BPL .add_to_score2
  LDA timer
  SEC
  SBC #$3B
  BCS .add_to_score2
  JMP .tenths_loop

.add_to_score2:
  INC score_2
  LDA timer
  SEC
  SBC #$3B
  STA timer
  LDA timer+1
  SBC #$00
  STA timer+1
  JMP .ones_loop

.tenths_loop:
  LDA timer
  SEC
  SBC #$06
  BCS .add_to_score3
  JMP .end_win_forever

.add_to_score3:
  INC score_3
  LDA timer
  SEC
  SBC #$06
  STA timer
  JMP .tenths_loop
  JMP .end_win_forever

; end ntsc loops

.pal_loops:
  LDA timer+1
  CMP #$14
  BMI .pal_tens_loop
  LDA #$09
  STA score_1
  STA score_2
  STA score_3
  JMP .end_win_forever

.pal_tens_loop:
  LDA timer+1
  CMP #$02
  BPL .pal_add_to_score1
  CMP #$01
  BMI .pal_ones_loop
  LDA timer
  SEC
  SBC #$F4
  BCS .pal_add_to_score1
  JMP .pal_ones_loop

.pal_add_to_score1:
  INC score_1
  LDA timer
  SEC
  SBC #$F4
  STA timer
  LDA timer+1
  SBC #$01
  STA timer+1
  JMP .pal_tens_loop

.pal_ones_loop:
  LDA timer+1
  CMP #$01
  BPL .pal_add_to_score2
  LDA timer
  SEC
  SBC #$32
  BCS .pal_add_to_score2
  JMP .pal_tenths_loop

.pal_add_to_score2:
  INC score_2
  LDA timer
  SEC
  SBC #$32
  STA timer
  LDA timer+1
  SBC #$00
  STA timer+1
  JMP .pal_ones_loop

.pal_tenths_loop:
  LDA timer
  SEC
  SBC #$05
  BCS .pal_add_to_score3
  JMP .end_win_forever

.pal_add_to_score3:
  INC score_3
  LDA timer
  SEC
  SBC #$05
  STA timer
  JMP .pal_tenths_loop

.end_win_forever:
  JSR wait_until_sound_off
  JSR play_winner_or_loser_music
  INC gamestate
  INC gamestate ;skip the gameover state at go to score.
  JMP forever

game_1_gameover:

  LDA ball_box
  STA ball_box_old
  JSR turn_off_ball

  LDA #$09
  STA score_1
  STA score_2
  STA score_3
  INC gamestate
  JMP forever

game_1_score:
  clear_board
  JSR waitVBlank
  JSR load_score_screen
  INC gamestate
  JMP forever

game_1_stop_wait_input:
  LDA current_game
  STA score_1
  JSR handle_input_wait_start
  JMP forever

game_1_reset_first_board:
  LDA #$00
  STA ram_board_ptr
  STA mad_maze_number
  STA isMasking
  STA maskingTimer
  LDA #$11
  STA ball_box
  STA ball_box_old
  LDA #$05
  STA gamestate
  reset_timer
  clear_board
  JSR intro_sound
  JMP forever

check_play_game_1_win_sound:
  LDA needPlaySound
  BNE .end
  
  LDA mad_maze_number
  CMP #$0A
  BEQ .winner_for_real

  LDA #$05
  STA gamestate
.end:
  JMP forever

.winner_for_real:
  LDA #$08
  STA gamestate
  JMP winner_for_real

check_game_1_boop_sound:
  LDA needPlaySound
  BNE .end
  LDA #$07
  STA gamestate
.end:
  JMP forever

; ++++++++++++ START NMI +++++++++++++

NMI:
  pha     ;save registers
  txa
  pha
  tya
  pha

  LDA detecting_tv
  BEQ .skip_nmi_inc
  INC nmis
  JMP endNMI
.skip_nmi_inc
  INC maskingTimer
  INC timer
  BNE .continue_difficulty
  INC timer+1
.continue_difficulty
  INC difficulty_timer
  BNE run_sound
  INC difficulty_timer+1

run_sound:
  LDA needPlaySound
  CMP #$01
  BEQ .playSound
  JMP show_board
.playSound:
  JSR playSound

show_board:
  LDA gamestate
  BEQ continue_nmi
  LDA needClearBoard
  BEQ continue_nmi
  LDA #$01
  STA nmi_show_board_routine
  LDA #$01
  BIT timer
  BEQ .show_top
  JMP .show_bottom
.show_top:
  LDA #$01
  STA needClearBoard
  JMP continue_nmi
.show_bottom:
  LDA #$01
  STA needClearBoard2
  ;JMP continue_nmi
  
continue_nmi: 

  LDA needClearBoard
  CMP #$01
  BEQ .drawClearBoard

  LDA needClearBoard2
  CMP #$01
  BEQ .drawClearBoard2

  LDA needDrawFullScreen
  CMP #$01
  BEQ .drawFullScreen

  LDA needBoardRendering
  CMP #$01
  BEQ .drawBoardRendering

  LDA needBoardRendering2
  CMP #$01
  BEQ .drawBoardRendering2

  LDA needEraseBall
  CMP #$01
  BEQ .eraseBallUpdate

  LDA needEraseShip
  CMP #$01
  BEQ .eraseShipUpdate

  LDA needUpdateBall
  CMP #$01
  BEQ .drawBallUpdate

  LDA needUpdateShip
  CMP #$01
  BEQ .drawShipUpdate

  LDA needUpdateCar
  CMP #$01
  BEQ .carUpdate

  LDA needDrawBuffer
  CMP #$01
  BEQ .drawBuffer

  LDA needEraseCones
  CMP #$01
  BEQ .erase_cones

  LDA needDrawGame7
  CMP #$01
  BEQ .need_draw_game_7

  LDA needDrawGame8
  CMP #$01
  BEQ .need_draw_game_8

  LDA needEraseGame8
  CMP #$01
  BEQ .need_erase_game_8 

  JMP endNMI

.drawClearBoard:
  JMP drawClearBoard_2
.drawClearBoard2:
  JMP drawClearBoard2_2
.drawFullScreen:
  JMP drawFullScreen
.drawBoardRendering:
  JMP drawBoardRendering
.drawBoardRendering2:
  JMP drawBoardRendering2_2
.drawBallUpdate:
  JMP drawBallUpdate2
.eraseBallUpdate:
  JMP eraseBallUpdate2
.eraseShipUpdate:
  JMP eraseShipUpdate2
.drawShipUpdate:
  JMP drawShipUpdate
.carUpdate:
  JMP carUpdate
.drawBuffer:
  JMP drawBuffer
.erase_cones:
  JMP need_erase_cones
.need_draw_game_7:
  JMP need_draw_game_7
.need_draw_game_8:
  JMP need_draw_game_8
.need_erase_game_8:
  JMP need_erase_game_8

drawClearBoard_2:
  LDA #$21
  STA ppu_y_coord
  LDA #$14
  STA ppu_x_coord

  JSR drawClearBoard
  LDA #$00
  STA needClearBoard
  LDA #$01
  STA needClearBoard2
  JMP endNMI

drawClearBoard2_2:
  LDA #$21
  STA ppu_y_coord
  LDA #$D4
  STA ppu_x_coord
  JSR drawClearBoard
  LDA #$00
  STA needClearBoard2
  JMP endNMI

drawFullScreen:
  JSR drawFullBackground
  LDA #$00
  STA needDrawFullScreen
  JMP continue_nmi

drawBoardRendering:
  JSR drawBoardRendering1
  LDA #$01
  STA needBoardRendering2
  LDA #$00
  STA needBoardRendering
  JMP endNMI ; so that I don't render 2 as well

drawBoardRendering2_2:
  JSR drawBoardRendering2
  LDA #$00
  STA needBoardRendering2
  JMP endNMI

eraseBallUpdate2:
  JSR eraseBallUpdate
  LDA #$00
  STA needEraseBall
  JMP endNMI

drawBallUpdate2:
  JSR drawBallUpdate
  LDA #$00
  STA needUpdateBall
  LDA #$01
  STA needEraseBall
  JMP endNMI

eraseShipUpdate2:
  JSR drawShip ; CONFUSING because I erase the ship before I redraw
  LDA #$00
  STA needEraseShip
  LDA #$01
  STA needUpdateBall
  JMP continue_nmi

drawShipUpdate:
  JSR eraseShipUpdate ; CONFUSING because I erase the ship before I redraw
  LDA #$00
  STA needUpdateShip
  LDA #$01
  STA needEraseShip
  JSR drawBallUpdate
  JMP endNMI

carUpdate:
  JSR eraseCarUpdate
  LDA #$00
  STA needUpdateCar
  LDA #$01
  STA needEraseCar
  JSR drawCarUpdate
  JMP endNMI

drawBuffer:
  LDA $2002
  JSR draw_dbuffer
  LDA #$00
  STA needDrawBuffer
  JMP continue_nmi

need_erase_cones:
  LDA #$00
  STA needEraseCones
  JSR eraseCones
  JSR drawCarUpdate
  JMP endNMI

need_draw_game_7:
  LDA #$00
  STA needDrawGame7
  JSR drawGame7
  JMP endNMI

need_draw_game_8:
  LDA #$00
  STA needDrawGame8
  JSR drawGame8
  JMP endNMI

need_erase_game_8:
  LDA #$00
  STA needEraseGame8
  JSR drawGame8
  JMP endNMI

endNMI:

  LDA current_game
  CMP #$04
  BEQ .flicker_ship
  
  LDA current_game
  CMP #$05
  BEQ .flicker_ship

  JMP .goToSleep

.flicker_ship:
  LDA gamestate
  CMP #$07
  BPL .goToSleep
  CMP #$06
  BMI .goToSleep
  LDA maskingTimer
  BEQ .mask_off
  ROR A
  ROR A
  BCS .goFlickYourSelf
  JMP .goToSleep

.mask_off:
  LDA #$01
  STA isMasking
.goFlickYourSelf:
  JSR draw_flicker_ship

.goToSleep:
  LDA #$00
  STA sleeping            ;wake up the main program

  LDA #$00
  STA $2006
  STA $2006
  STA $2005
  STA $2005

  LDA PPUCTRL_2000_Buffer 
  STA $2000

  LDA PPUMASK_2001_Buffer
  STA $2001

  pla     ;restore registers
  tay
  pla
  tax
  pla

  RTI ; return from interrupt

;+++++++++++ END NMI +++++++++++++

  ;Load Extra Data in Bank 0
  .include "get_keys.asm"
  .include "wait_v_blank.asm"
  .include "draw_buffer.asm"
  .include "handle_input_wait_start.asm"
  .include "handle_input_game.asm"
  .include "load_game_screen.asm"
  .include "load_scores.asm"
  .include "meta_tile_coordinates.asm"
  .include "meta_tiles.asm"
  .include "boards.asm"
  .include "draw_full_background.asm"
  .include "rand_num.asm"
  .include "game_1_load_board.asm"
  .include "game_1_update_ball.asm"
  .include "load_tiles_into_ram.asm"
  .include "game_4_update_ship.asm"
  .include "detect_tv_setting.asm"
  .include "handle_input_game_4.asm"

load_intro_background:
  LDA #LOW(screen_intro)  ;set textPointer1 to point to beginning of text string
  STA backgroundLo
  LDA #HIGH(screen_intro)
  STA backgroundHi
  LDA #$01
  STA needDrawFullScreen
  LDA #$24
  STA nametable_address_hi
  RTS

load_hand_held_background:
  LDA #LOW(hand_held_screen)  ;set textPointer1 to point to beginning of text string
  STA backgroundLo
  LDA #HIGH(hand_held_screen)
  STA backgroundHi
  LDA #$01
  STA needDrawFullScreen
  LDA #$20
  STA nametable_address_hi
  RTS

palette:
  ;; Background Palletes (0-3)
  .db $0F,$06,$16,$27, $0F,$07,$16,$0F, $0F,$38,$16,$27, $0F,$37,$16,$27
  ;;  Character Palletes (0-3)
  .db $0F,$17,$1A,$27, $0F,$16,$37,$1A, $0F,$16,$37,$11, $0F,$28,$37,$11

intro_attributes:
   ; 64 bytes following a nametable
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$C0, $30,$00,$00,$00
  .db $00,$00,$00,$0C, $03,$00,$00,$00
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$00, $00,$00,$00,$00

game_attributes:
   ; 64 bytes following a nametable
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$55, $55,$00,$00,$00
  .db $00,$00,$00,$55, $55,$00,$00,$00
  .db $00,$00,$00,$55, $55,$00,$00,$00
  .db $00,$00,$00,$00, $00,$00,$00,$00
  .db $00,$00,$00,$A0, $A2,$00,$00,$00
  .db $00,$00,$00,$AA, $AA,$00,$00,$00

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  .bank 1
  .org $A000     ;Need to add the rest of the game in bank 1.  

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

hand_held_screen:
  ; nametable 960 bytes long for the background

  .db $0F,$20

  .db $0F,$0A,$43,$44,$45,$45,$45,$45  ;;Blank
  .db $45,$45,$45,$45,$45,$4E,$0F,$0A ;;Blank

  .db $0F,$09,$52,$53,$54,$55,$55,$55,$55  ;;TOP of
  .db $55,$55,$55,$55,$55,$5E,$5F,$0F,$09  ;;Top part

  .db $0F,$09,$62,$63,$64,$0F,$09  ;;Blank
  .db $6E,$6F,$0F,$09 ;;Blank

  .db $0F,$09,$72,$73,$74,$0F,$01,$9D,$4A,$4B  ;;SPLIT
  .db $4C,$00,$01,$02,$0F,$01,$7E,$7F,$0F,$09  ;;Blank

  .db $0F,$09,$82,$83,$84,$0F,$01,$47,$48,$49  ;;SPLIT
  .db $4D,$10,$11,$12,$0F,$01,$8E,$8F,$0F,$09  ;;Blank

  .db $0F,$09,$92,$83,$84,$56,$57,$58,$59  ;;SECOND
  .db $5A,$5B,$5C,$5D,$7D,$8E,$9F,$0F,$09  ;;Blank

  .db $0F,$09,$A2,$83,$84,$66,$67,$68,$69  ;;SECOND
  .db $6A,$6B,$6C,$6D,$8D,$8E,$8E,$7C,$0F,$08 ;;Blank

  .db $0F,$09,$B2,$83,$84,$C0,$E1,$E1,$E1  ;;Top of
  .db $E1,$E1,$E1,$E1,$0E,$8E,$8E,$8C,$0F,$08  ;;Board

  .db $0F,$08,$72,$83,$83,$84,$D0,$0F,$07 ;;Board
  .db $0E,$8E,$8E,$9C,$0F,$08 ;;Blank

  .db $0F,$08,$82,$83,$83,$84,$D0,$0F,$07  ;;Board
  .db $0E,$8E,$8E,$AC,$0F,$08  ;;Blank

  .db $0F,$08,$92,$83,$83,$84,$D0,$0F,$07  ;;Board
  .db $0E,$8E,$8E,$BC,$0F,$08 ;;Blank

  .db $0F,$08,$A2,$83,$83,$84,$D0,$0F,$07 ;;Board
  .db $0E,$8E,$8E,$8E,$7C,$0F,$07  ;;Blank

  .db $0F,$08,$B2,$83,$83,$84,$D0,$0F,$07 ;;Blank
  .db $0E,$8E,$8E,$8E,$8C,$0F,$07 ;;Blank

  .db $0F,$07,$72,$83,$83,$83,$84,$D0,$0F,$07  ;;Board
  .db $0E,$8E,$8E,$8E,$9C,$0F,$07 ;;Blank

  .db $0F,$07,$82,$83,$83,$83,$84,$D0,$0F,$07  ;;Board
  .db $0E,$8E,$8E,$8E,$AC,$0F,$07 ;;Blank

  .db $0F,$07,$92,$83,$83,$83,$84,$D0,$0F,$07 ;;Board
  .db $0E,$8E,$8E,$8E,$BC,$0F,$07 ;;Blank
  
  .db $0F,$07,$A2,$83,$83,$83,$84,$D0,$0F,$07  ;;Board
  .db $0E,$8E,$8E,$8E,$8E,$7C,$0F,$06 ;;Blank

  .db $0F,$07,$B2,$83,$83,$83,$84,$D0,$0F,$07 ;;Board
  .db $0E,$8E,$8E,$8E,$8E,$8C,$0F,$06  ;;Blank

  .db $0F,$06,$72,$83,$83,$83,$83,$84,$D0,$0F,$07 ;;Board
  .db $0E,$8E,$8E,$8E,$8E,$9C,$0F,$06 ;;Blank

  .db $0F,$06,$EB,$83,$83,$83,$83,$84,$0F,$09 ;;Bottom of
  .db $8E,$8E,$8E,$8E,$CC,$0F,$06  ;;Board

  .db $0F,$06,$A9,$AA,$83,$83,$83,$83,$83,$83,$83,$83  ;;Blank
  .db $83,$83,$83,$83,$83,$83,$83,$83,$89,$8A,$0F,$06 ;;Blank

  .db $0F,$07,$BA,$78,$83,$83,$83,$83,$83,$83,$83  ;;Blank
  .db $83,$83,$83,$83,$83,$83,$83,$83,$99,$0F,$07 ;;Blank

  .db $0F,$08,$88,$8E,$8E,$8E,$8E,$8E,$8E,$8E  ;;Blank
  .db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E,$DC,$0F,$07 ;;Blank
  
  .db $0F,$08,$88,$8E,$8E,$84,$B5,$B6,$B7,$B8  ;;Blank
  .db $E6,$DD,$DE,$C9,$CA,$8E,$8E,$8E,$DC,$0F,$07 ;;Blank
  
  .db $0F,$08,$88,$8E,$8E,$84,$C5,$C6,$C7,$C8  ;;Blank
  .db $BB,$ED,$EE,$D9,$DA,$8E,$8E,$8E,$DC,$0F,$07 ;;Blank

  .db $0F,$08,$88,$8E,$8E,$84,$D5,$D6,$D7,$D8  ;;Blank
  .db $CB,$F6,$FC,$E9,$EA,$8E,$8E,$8E,$DC,$0F,$07 ;;Blank

  .db $0F,$08,$88,$8E,$8E,$84,$E5,$71,$70,$E8  ;;Blank
  .db $DB,$F4,$FB,$DF,$FA,$8E,$8E,$8E,$DC,$0F,$07 ;;Blank

  .db $0F,$08,$88,$8E,$8E,$84,$09,$0A,$0B,$80  ;;Middle of 
  .db $F2,$BD,$BE,$BF,$FF,$8E,$8E,$8E,$DC,$0F,$07  ;;Left/Right Arrows
  
  .db $0F,$08,$88,$8E,$8E,$84,$19,$1A,$1B,$A1  ;;Blank
  .db $B0,$CD,$CE,$CF,$B9,$8E,$8E,$8E,$DC,$0F,$07 ;;Blank

game_4:
  LDA gamestate
  CMP #$03
  BEQ initialize_game_4
  CMP #$04
  BEQ load_fireworks_into_ram
  CMP #$05
  BEQ .done_ram_loading
  CMP #$06
  BEQ .play_game_4
  CMP #$07
  BEQ .explode_ship
  CMP #$08
  BEQ .game_4_gameover
  CMP #$09
  BEQ .game_4_score
  CMP #$0A
  BEQ .game_4_stop_wait_input
  CMP #$0B
  BEQ .game_4_reset_first_board
  CMP #$0C
  BEQ .game_4_miss_ship
  ;otherwise
  JMP forever

.copy_current_board_into_ram:
  JMP copy_current_board_into_ram
.display_current_board:
  JMP display_current_board
.done_ram_loading:
  JMP done_ram_loading
.play_game_4:
  JMP play_game_4
.explode_ship:
  JMP explode_ship
.game_4_gameover:
  JMP game_4_gameover
.game_4_score:
  JMP game_1_score ;reusing code - sorry it's messy - but needed to save bytes
.game_4_stop_wait_input:
  JMP game_1_stop_wait_input
.game_4_reset_first_board:
  JMP game_4_reset_first_board
.game_4_miss_ship:
  JMP game_4_miss_ship

initialize_game_4:
  LDA #$00
  STA ram_board_ptr
  STA mad_maze_number
  STA tempVar1
  STA tempVar2
  STA isMasking
  LDA #$09
  STA ball_box
  STA ball_box_old
  
  ;this is needed for the first iteration of forcing a move in game5
  LDA #$16
  STA move_trigger

  clear_board
  JSR intro_sound

  INC gamestate
  JMP forever

load_fireworks_into_ram:
  LDA #LOW(fireworks_00)
  STA board_ptr
  LDA #HIGH(fireworks_00)
  STA board_ptr+1
  
  LDY #$00
  LDX #$F0

.loop:
  LDA [board_ptr], y
  STA $200, y
  INY
  DEX
  BNE .loop

  INC gamestate
  reset_timer
  JMP forever

done_ram_loading:
  JSR place_ship

  INC gamestate
  JMP forever

place_ship:
  JSR rand_num
  LDA seed
  ROR A
  BCS .place_top
  JMP .place_bottom
.place_top:
  ROR A
  BCS .place_top_left_or_middle
  LDA #$02
  JMP .done_placement
.place_top_left_or_middle:
  ROR A
  BCS .place_top_middle
  LDA #$00
  JMP .done_placement
.place_top_middle:
  LDA #$01
  JMP .done_placement

.place_bottom:
  ROR A
  BCS .place_bottom_left_or_middle
  LDA #$12
  JMP .done_placement
.place_bottom_left_or_middle:
  ROR A
  BCS .place_bottom_middle
  LDA #$10
  JMP .done_placement
.place_bottom_middle:
  LDA #$11
  JMP .done_placement

.done_placement:
  STA ship_box
  STA ship_box_old
  JSR waitVBlank
  update_ball
  JSR waitVBlank
  update_ship
  JSR waitVBlank

  LDA #$FD
  STA maskingTimer ;used for keeping the ship brightly colored.

  LDA current_game
  CMP #$04
  BEQ .set_no_difficulty

  LDA #DIFFICULTY_HARD
  STA difficulty
  JMP .difficulty_already_set

.set_no_difficulty:
  LDA #DIFFICULTY_EASY
  STA difficulty

.difficulty_already_set:
  LDA #$00
  STA difficulty_timer
  STA difficulty_timer+1
  RTS

play_game_4:

  JSR check_gameover
  BCS .game_over

.not_game_over:

  LDA current_game
  CMP #$05
  BNE .ship_adjustment_done

  LDA difficulty_timer+1
  CMP #$04
  BPL .might_switch_easy_difficulty
  CMP #$02
  BPL .might_switch_med_difficulty
  JMP .switch_difficulty_done
.might_switch_easy_difficulty:
  LDA difficulty_timer
  CMP #$B0
  BNE .switch_difficulty_done
  LDA #DIFFICULTY_EASY
  STA difficulty
  JMP .switch_difficulty_done
.might_switch_med_difficulty:
  LDA difficulty_timer
  CMP #$58
  BNE .switch_difficulty_done
  LDA #DIFFICULTY_MEDIUM
  STA difficulty
  JMP .switch_difficulty_done

.switch_difficulty_done:
  LDA difficulty
  BEQ .ship_adjustment_done
  LDA difficulty_timer
  CMP move_trigger
  BEQ .trigger_move
  JMP .ship_adjustment_done

.trigger_move:
  CLC
  LDA difficulty_timer
  ADC difficulty
  STA move_trigger
  LDA #$01
  STA isAutoMoving

.ship_adjustment_done:
  LDA isMissing
  BEQ .skip_missing_ship
  JSR game_4_miss_ship
.skip_missing_ship
  JSR handle_input_game_4
  JMP forever

.game_over:
  ;Needed to put code in the check_gameover method to update the gamestate to #$08
  ;This will actually force NMI to turn off the flickering ship.
  JMP forever

explode_ship:

  LDA ram_board_ptr
  CMP #$60
  BNE .skip_crash_sound

  JSR turn_on_crash_sound

.skip_crash_sound:
  LDA ram_board_ptr
  CLC
  ADC #$18
  BCS .enough_is_enough
  STA ram_board_ptr

  JSR load_tiles_into_ram

  update_screen
  JSR waitVBlank
  JSR waitVBlank ; for delaying transition between one fireworks scene and the next - timing only

  JMP .end_fireworks

.winner:
.enough_is_enough:
  JSR waitVBlank
  JSR waitVBlank
  clear_board
  JSR waitVBlank
  JSR waitVBlank
  LDA #$00
  STA ram_board_ptr
  LDA #$0C
  STA move_trigger ;setup trigger for game5
  DEC gamestate
  DEC gamestate
  unmute_buttons

  LDA #$00
  STA $400C
  
  INC mad_maze_number
  LDA mad_maze_number
  CMP #$0A
  BEQ .winner_for_real

.end_fireworks:
  JMP forever

.winner_for_real:
  INC gamestate
  INC gamestate
  JMP winner_for_real

game_4_gameover:
  LDA #$09
  STA score_1
  STA score_2
  STA score_3
  INC gamestate
  JMP forever

game_4_reset_first_board:
  LDA #$00
  STA ram_board_ptr
  STA mad_maze_number
  STA isMasking
  STA maskingTimer

  LDA #$05
  STA gamestate
  reset_timer
  clear_board
  JSR intro_sound
  JMP forever

game_4_miss_ship:
  ;tempVar1 will store which game_4_miss_ball_{X} we are on
  ;tempVar2 will store the memory offset from game_4_miss_ball_0
  ;tempVar3 will be how many NMIs we have gone through
  ;X will be {0,2} to count the numbers of times to load snake_buffer

  LDX #$02

  LDA tempVar3
  CMP #$04
  BEQ .stop_firing
  ASL A
  STA tempVar1

.shot_loop:

  LDY #$00
  LDA #$00

.multiplication_loop:
  CPY tempVar1
  BEQ .done_multiplication_loop
    CLC
    ADC #$0A
    INY
    JMP .multiplication_loop
.done_multiplication_loop:

  STA tempVar2

  LDA #LOW(game_4_miss_ball_0)
  STA board_ptr
  LDA #HIGH(game_4_miss_ball_0)
  STA board_ptr+1

  LDA board_ptr
  CLC
  ADC tempVar2
  STA board_ptr
  LDA board_ptr+1
  ADC #$00
  STA board_ptr+1

  LDY #$09
.shot_loop_inner_loop:
  LDA [board_ptr], y
  STA snake_buffer, y
  DEY
  CPY #$FF
  BEQ .end_shot_loop
    JMP .shot_loop_inner_loop
.end_shot_loop:

  STX tempVar2
  JSR snakeBufferToText
  LDX tempVar2
  INC tempVar1
  DEX
  BEQ .end
    JMP .shot_loop

.stop_firing:

  JSR wait_until_sound_off
  STA board_ptr
  STA muteButtons
  STA isMissing 
.end:
  LDA #$01
  STA needDrawBuffer

  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank

  LDA difficulty_timer
  ADC #$01
  STA move_trigger

  INC tempVar3
  RTS

game_6:
  LDA gamestate
  CMP #$03
  BEQ .initialize_game_6
  CMP #$04
  BEQ .load_game_6
  CMP #$05
  BEQ .draw_game_6_board
  CMP #$06
  BEQ .play_game_6
  CMP #$07
  BEQ .game_6_crash
  CMP #$08
  BEQ .game_6_draw_ball_1
  CMP #$09
  BEQ .game_6_draw_ball_2
  CMP #$0A
  BEQ .game_6_erase_ball_1
  CMP #$0B
  BEQ .game_6_erase_ball_2
  CMP #$0C
  BEQ .game_6_score
  CMP #$0D
  BEQ .game_6_stop_wait_input
  CMP #$0E
  BEQ .game_6_reset_first_board
  ;otherwise
  JMP forever

.load_game_6:
  JMP load_game_6
.draw_game_6_board:
  JMP draw_game_6_board
.play_game_6:
  JMP play_game_6
.game_6_crash:
  JMP game_6_crash
.game_6_draw_ball_1:
  JMP game_6_draw_ball_1
.game_6_draw_ball_2:
  JMP game_6_draw_ball_2
.game_6_erase_ball_1:
  JMP game_6_erase_ball_1
.game_6_erase_ball_2:
  JMP game_6_erase_ball_2
.game_6_score:
  JMP game_1_score ;reusing code - sorry it's messy - needed to save bytes
.game_6_stop_wait_input:
  JMP game_1_stop_wait_input
.game_6_reset_first_board:
  JMP game_6_reset_first_board

.initialize_game_6:
  clear_board
  JSR intro_sound
  INC gamestate
  LDA #$00
  STA mad_maze_number
  STA ram_board_ptr
  LDA #$FF
  STA tempVar3
  JMP forever

load_game_6:  

  LDA seed
  AND #$03
  TAX
  BEQ .group4
  DEX
  BEQ .group3
  DEX
  BEQ .group2

.group1:
  LDA #$00
  STA tempVar1
  JSR rand_num
  LDA seed
  AND #$07
  STA tempVar2
  JMP .assignNum
  
.group2:
  LDA #$08
  STA tempVar1
  JSR rand_num
  LDA seed
  AND #$07
  STA tempVar2
  JMP .assignNum

.group3:
  LDA #$10
  STA tempVar1
  JSR rand_num
  LDA seed
  AND #$07
  STA tempVar2
  JMP .assignNum

.group4:
  LDA #$18
  STA tempVar1
  JSR rand_num
  LDA seed
  AND #$07
  STA tempVar2

.assignNum:
  LDX ram_board_ptr
  LDA tempVar1
  CLC
  ADC tempVar2
  
  ASL A
  ASL A
  TAY

  LDA game_6_boards, y
  STA $200, x
  STA tempVar1
  INY
  INX
  LDA game_6_boards, y
  STA $200, x
  STA tempVar2
  INY
  INX
  LDA game_6_boards, y
  STA $200, x
  INY
  INX
  LDA game_6_boards, y
  STA $200, x

  TXA
  CMP #$03
  BNE .check_duplicates
  JMP .continue
.check_duplicates:
  SEC
  SBC #$07
  TAX
  LDA $200,x
  CMP tempVar1
  BNE .continue
  INX
  LDA $200,x
  CMP tempVar2
  BNE .continue
  LDA seed
  BNE .load_game_6
  LDA #$8D
  STA seed
  JMP load_game_6
.load_game_6:
  JMP load_game_6
.continue:
  INC ram_board_ptr
  INC ram_board_ptr
  INC ram_board_ptr
  INC ram_board_ptr
 
  INC mad_maze_number
  LDA mad_maze_number
  CMP #$10
  BNE .continue_loading

.done_loading:
  JSR turn_on_car_sound
  JSR done_loading_game6
  JMP forever

.continue_loading:
  JMP forever

turn_on_car_sound:
  lda #%10001111
  sta $400E

  LDA #%00110111
  STA $400C

  LDA #%11111111
  STA $400F
  RTS

turn_on_crash_sound:
  lda #%00001100
  sta $400E

  LDA #%00111111
  STA $400C

  LDA #%11111111
  STA $400F

  RTS

done_loading_game6:
  LDA #$00
  STA mad_maze_number
  INC gamestate
  LDA $203
  STA car_box
  LDA $200
  STA game_6_vars
  LDA $201
  STA game_6_vars+1
  LDA $202
  STA game_6_vars+2
  LDA $203
  STA game_6_vars+3
  LDA #$00
  STA car_direction ; 0-UP ; 1-RT ; 2-DN ; 3-LT
  STA car_position_old

  LDA #$01
  STA need_new_cones

  RTS

draw_game_6_board:
  LDX #$04
.copy_old:
  LDA game_6_vars-1, x
  STA game_6_vars_old-1, x
  DEX
  BNE .copy_old
  
  LDA mad_maze_number
  ASL A
  ASL A
  TAX
  LDA $200, x
  STA game_6_vars
  INX
  LDA $200, x
  STA game_6_vars + 1
  INX 
  LDA $200, x
  STA game_6_vars + 2
  INX 
  LDA $200, x
  STA game_6_vars + 3

  LDA game_6_vars
  STA ball_box
  STA ball_box_old
  update_ball
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank  

  LDA game_6_vars + 1
  STA ball_box
  STA ball_box_old
  update_ball
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank
  JSR waitVBlank

  LDA game_6_vars + 2
  STA car_position
  update_car
  LDA game_6_vars_old + 2
  STA car_position_old

  reset_timer
  INC gamestate
  
  JMP forever

play_game_6:

  JSR check_gameover
  BCC .not_game_over

.game_over:
  LDA ball_box
  STA ball_box_old
  JSR turn_off_ball

  LDA #$00
  STA $400C

  LDA #$09
  STA score_1
  STA score_2
  STA score_3
  LDA #$0C
  STA gamestate
  JMP forever

.not_game_over:

.check_remove_old_cones:
  LDA car_box_old
  CMP car_position_old
  BEQ .remove_old_cones
  JMP .check_between_new_cones
.remove_old_cones:
  LDA need_remove_cones
  CMP #$01
  BEQ .remove_cone1
  CMP #$02
  BEQ .remove_cone2
  JMP .check_between_new_cones
.remove_cone1:
  LDA #$0A
  STA gamestate
  JMP forever
.remove_cone2:
  LDA #$0B
  STA gamestate
  JMP forever

.check_between_new_cones:
  ;Check if car_box == car_poisition.  IF so, winner. Need to load new cones.
  LDA car_box
  CMP car_position
  BEQ .between_cones
  JMP .continue
.between_cones:

  LDA #SOUND_07_GAME_06_BLOOP_SOUND
  STA current_sound
  LDA #$01
  STA needPlaySound

  LDA need_new_cones
  CMP #$01
  BEQ .get_new
  JMP .continue
.get_new:
  LDA #$00
  STA need_new_cones
  INC gamestate
  INC gamestate
  JMP forever


.continue:
  JSR handle_input_game_6  
  JMP forever

game_6_crash:

  JSR turn_on_crash_sound
  
  LDA car_crash_timer+1
  CMP timer+1
  BEQ .check_timer_lo
  JMP .continue_crashing
.check_timer_lo:
  LDA car_crash_timer
  CMP timer
  BEQ .stop_crash
.continue_crashing:
  LDA timer
  LSR A
  LSR A
  BCS .end
  LDA isCrashing
  EOR #$01
  STA isCrashing
  update_car
  JSR waitVBlank
  JMP .end
.stop_crash:
  JSR turn_on_car_sound

  LDA #$00
  STA isCrashing
  LDA tempVar3
  STA car_box_old
  update_car
  LDA #$06
  STA gamestate
.end:
  JMP forever  

game_6_draw_ball_1:
  INC mad_maze_number
  LDA mad_maze_number
  CMP #$10
  BEQ .win_for_real

  LDX #$04
.copy_old:
  LDA game_6_vars-1, x
  STA game_6_vars_old-1, x
  DEX
  BNE .copy_old
  
  LDA mad_maze_number
  ASL A
  ASL A
  TAX
  LDA $200, x
  STA game_6_vars
  INX
  LDA $200, x
  STA game_6_vars + 1
  INX 
  LDA $200, x
  STA game_6_vars + 2
  INX 
  LDA $200, x
  STA game_6_vars + 3

  LDA game_6_vars+2
  STA car_position
  LDA game_6_vars_old+2
  STA car_position_old

.check_if_cone_exists:
  
  LDA game_6_vars
  CMP game_6_vars_old
  BEQ .end
  LDA game_6_vars
  CMP game_6_vars_old+1
  BEQ .end
  LDA game_6_vars
  STA ball_box
  STA ball_box_old
  update_ball
  JSR waitVBlank
  JSR waitVBlank

.end:
  INC gamestate

  JMP forever

.win_for_real:
  LDA #$00
  STA $400C
  clear_board
  LDA #$0A
  STA gamestate
  JMP winner_for_real

game_6_draw_ball_2:

  LDA game_6_vars+1
  CMP game_6_vars_old
  BEQ .end
  LDA game_6_vars+1
  CMP game_6_vars_old+1
  BEQ .end

  LDA game_6_vars+1
  STA ball_box
  STA ball_box_old
  update_ball
  JSR waitVBlank
  JSR waitVBlank

.end:
  LDA #$06
  STA gamestate

  INC need_remove_cones ; this moves it from 0 to 1

  JMP forever
game_6_erase_ball_1:

  LDA game_6_vars_old
  STA ball_box_old

  CMP game_6_vars
  BEQ .skip_erase
  CMP game_6_vars+1
  BEQ .skip_erase

  LDA #$01
  STA needEraseCones

.skip_erase:
  INC need_remove_cones ; this moves it from 1 to 2

  LDA #$06
  STA gamestate

  JMP forever

game_6_erase_ball_2:

  LDA game_6_vars_old+1
  STA ball_box_old

  CMP game_6_vars
  BEQ .skip_erase
  CMP game_6_vars+1
  BEQ .skip_erase

  LDA #$01
  STA needEraseCones

.skip_erase:
  LDA #$06
  STA gamestate

  LDA #$01
  STA need_new_cones
  LDA #$00
  STA need_remove_cones

  JMP forever

game_6_reset_first_board:
  JSR done_loading_game6
  LDA #$00
  STA ram_board_ptr
  STA mad_maze_number

;this is deliberatly 5 because the code that I am reusing already
;increases the gamestate to 6, which is what I want. 
  LDA #$05 
  STA gamestate

  reset_timer
  clear_board
  JSR intro_sound
  JSR waitVBlank
  JSR turn_on_car_sound
  
  JMP forever

game_7:

  LDA gamestate
  CMP #$03
  BEQ .initialize_game_7
  CMP #$04
  BEQ .game_7_random_board
  CMP #$05
  BEQ .play_game_7
  CMP #$06
  BEQ .game_7_winner
  CMP #$08
  BEQ .game_7_score
  CMP #$09
  BEQ .game_7_stop_wait_input
  CMP #$0A
  BEQ .game_7_reset_first_board
  CMP #$0B
  BEQ .game_7_gameover
  JMP forever

.game_7_random_board:
  JMP game_7_random_board
.play_game_7:
  JMP play_game_7
.game_7_winner:
  JMP game_7_winner
.game_7_gameover:
  JMP game_7_gameover
.game_7_score:
  JMP game_1_score
.game_7_stop_wait_input:
  JMP game_1_stop_wait_input
.game_7_reset_first_board:
  JMP game_7_reset_first_board

.initialize_game_7:
  LDA #$00
  STA mad_maze_number

  reset_timer
  clear_board
  JSR intro_sound

  INC gamestate 
  JMP forever

game_7_random_board:

  clear_board

  JSR waitVBlank
  JSR waitVBlank
  LDA #$FF
  STA stomp_input
  LDA #$09
  STA ball_box
  STA ball_box_old
  update_ball

  JSR waitVBlank
  JSR waitVBlank

  JSR rand_num
  LDA seed

  AND #$03
  
  CMP #$03
  BEQ game_7_random_board
  CMP #$02
  BEQ .split_board
  CMP #$01
  BEQ .adjacent_board
  
;single_board
  JSR rand_num
  LDA seed
  AND #$03
  
  STA stomp_target
  JMP .board_done

.adjacent_board:
  JSR rand_num
  LDA seed
  AND #$03

  CLC
  ADC #$04
  STA stomp_target
  JMP .board_done

.split_board:
  JSR rand_num
  LDA seed
  AND #$03

  LSR A
  CLC
  ADC #$08
  STA stomp_target
  
.board_done:
  LDA #$00 
  STA maskingTimer
  INC gamestate
  JMP forever

play_game_7:

  JSR check_gameover
  BCC .not_game_over

.game_over:
  LDA ball_box
  STA ball_box_old
  JSR turn_off_ball

  LDA #$09
  STA score_1
  STA score_2
  STA score_3
  LDA #$08
  STA gamestate
  JMP forever

.not_game_over:
  LDA stomp_target
  CMP stomp_input
  BNE .not_winner

  JSR game_7_good_sound
  JSR wait_until_sound_off

  INC mad_maze_number
  LDA mad_maze_number
  CMP #$14
  BEQ .winner_for_real
  DEC gamestate
  JMP forever

.winner_for_real:
  clear_board
  INC gamestate
  JMP forever  

.not_winner:
  LDA maskingTimer
  CMP #$20
  BEQ .board_on
  JMP .check_new_board
.board_on:
  LDA #$00
  STA tempVar1 ;used as a flag in the needDrawGame7 routine
  LDA #$01
  STA needDrawGame7
  JMP forever ; we can't have the board and the ball updating at once
.check_new_board:
  LDA maskingTimer
  ;CMP #$3C
  CMP #$50
  BEQ .new_board
  JMP .end
.new_board:
  JSR game_7_bad_sound
  DEC gamestate
  JMP forever
.end:
  JSR handle_input_game_7
  JMP forever
game_7_winner:
  JMP winner_for_real
game_7_gameover:
  JMP forever
game_7_score:
  JMP forever
game_7_reset_first_board:
  LDA #$03
  STA gamestate
  JMP forever

game_8:

  LDA gamestate
  CMP #$03
  BEQ .initialize_game_8
  CMP #$04
  BEQ .game_8_start_board
  CMP #$05
  BEQ .draw_snake
  CMP #$06
  BEQ .play_game_8
  CMP #$07
  BEQ .game_8_winner
  CMP #$08
  BEQ .game_8_gameover
  CMP #$09
  BEQ .game_8_score
  CMP #$0A
  BEQ .game_8_stop_wait_input
  CMP #$0B
  BEQ .game_8_reset_first_board
  JMP forever

.game_8_start_board:
  JMP game_8_start_board
.play_game_8:
  JMP play_game_8
.draw_snake:
  JMP draw_snake
.game_8_winner:
  JMP game_8_winner
.game_8_gameover:
  JMP game_8_gameover
.game_8_score:
  JMP game_1_score
.game_8_stop_wait_input:
  JMP game_1_stop_wait_input
.game_8_reset_first_board:
  JMP game_8_reset_first_board

.initialize_game_8:
  LDA #$00
  STA mad_maze_number
  STA difficulty_timer
  STA difficulty_timer+1

 ;needed because I'm reusing game6 code.  We don't want the ball to turn on by itself.
  LDA #$FF
  STA game_6_vars
  STA game_6_vars+1  

  reset_timer
  clear_board
  JSR intro_sound
  
  INC gamestate 
  JMP forever

game_8_start_board:

  LDA #$00
  STA car_direction ; 0-UP ; 1-RT ; 2-DN ; 3-LT
  STA snake_segment
  STA isAutoMoving
  STA snake_same_metatiles
  STA snake_same_metatiles+1
  STA snake_same_metatiles+2
  STA snake_same_metatiles+3

  LDA #DIFFICULTY_HARD
  STA difficulty

  clear_board

  JSR waitVBlank
  JSR waitVBlank
  LDA #$09
  STA ball_box
  STA ball_box_old
  STA game_6_vars
  update_ball
  JSR waitVBlank
  JSR waitVBlank

  LDA #$08
  STA snake_current
  
  LDA #$10 
  STA snake_current+1

  LDA #$18
  STA snake_current+2

  LDA #$20
  STA snake_current+3

  JSR waitVBlank
  JSR waitVBlank

  INC gamestate
  JMP forever

draw_snake:
  LDA snake_segment
  TAX
  LDA snake_same_metatiles, x
  BNE .continue_without_check
  LDA snake_segment
  CMP #$03
  BEQ .check_with_segment_0
  JMP .check_with_next_segment
.check_with_segment_0:
  LDA snake_current
  STA tempVar1
  LDA snake_current+3
  STA tempVar2
  JSR isByteInSameMetatile
  LDA tempVar3
  BNE .first_and_last_are_in_same
  LDA #$00
  STA snake_same_metatiles+3
  JMP .continue
.first_and_last_are_in_same:
  LDA #$01
  STA snake_same_metatiles
  STA snake_same_metatiles+3
  JMP .continue
.check_with_next_segment:
  LDA snake_current, x
  STA tempVar1
  LDA snake_current+1,x
  STA tempVar2
  JSR isByteInSameMetatile
  LDA tempVar3
  BNE .byte_and_next_are_in_same
  LDA #$00
  STA snake_same_metatiles, x
  STA snake_same_metatiles+1, x
  STA snake_metatiles+1, x
  JMP .continue
.byte_and_next_are_in_same:
  LDA #$01
  STA snake_same_metatiles, x
  STA snake_same_metatiles+1, x
.continue:
  LDA snake_current, x
  STA car_box
  STA car_box_old
  JSR loadSnakeBuffer
  JSR snakeBufferToText 

.continue_without_check:
  INC snake_segment
  LDA snake_segment
  CMP #$04
  BEQ .play_game
  JMP draw_snake
.play_game:
  LDA #$00
  STA snake_segment

  LDA #$01
  STA needDrawBuffer

  INC gamestate
  JMP forever
  
snakeBufferToText:
  LDA #LOW(snake_buffer+2)  ;set textPointer1 to point to beginning of text string
  STA textPointer1Lo
  LDA #HIGH(snake_buffer+2)
  STA textPointer1Hi

  LDA snake_buffer
  LDY snake_buffer+1

  JSR add_to_dbuffer  

  LDA #LOW(snake_buffer+7)  ;set textPointer1 to point to beginning of text string
  STA textPointer1Lo
  LDA #HIGH(snake_buffer+7)
  STA textPointer1Hi

  LDA snake_buffer+5
  LDY snake_buffer+6

  JSR add_to_dbuffer 

  RTS

play_game_8:

  JSR check_gameover
  BCC .not_game_over

.game_over:
  LDA #$09
  STA score_1
  STA score_2
  STA score_3
  LDA #$08
  STA gamestate
  JMP forever

.not_game_over:
  JSR check_winner
  LDA tempVar3
  BNE .winner
  JMP .not_winner
.winner:
  INC mad_maze_number
  LDA mad_maze_number
  CMP #$05
  BEQ .winner_for_real
  DEC gamestate
  DEC gamestate
  ;JSR play sound
  LDA #$00
  STA difficulty_timer
  STA difficulty_timer+1
  LDA #$16
  STA move_trigger
  JMP forever
.winner_for_real:
  clear_board
  INC gamestate
  JMP forever
.not_winner:

  LDA difficulty_timer+1
  CMP #$04
  BPL .might_switch_easy_difficulty
  CMP #$02
  BPL .might_switch_med_difficulty
  JMP .switch_difficulty_done
.might_switch_easy_difficulty:
  LDA difficulty_timer
  CMP #$B0 ;B004 triggers easy
  BNE .switch_difficulty_done
  LDA #DIFFICULTY_EASY
  STA difficulty
  JMP .switch_difficulty_done
.might_switch_med_difficulty:
  LDA difficulty_timer
  CMP #$58 ;5802 triggers medium
  BNE .switch_difficulty_done
  LDA #DIFFICULTY_MEDIUM
  STA difficulty
  JMP .switch_difficulty_done

.switch_difficulty_done:
  LDA difficulty
  BEQ .ball_movement_done
  LDA difficulty_timer
  CMP move_trigger
  BPL .trigger_move
  JMP .ball_movement_done

.trigger_move:
  CLC
  LDA difficulty_timer
  ADC difficulty
  STA move_trigger
  LDA #$01
  STA isAutoMoving

.ball_movement_done:

  LDA isAutoMoving
  BEQ .continue
  JSR handle_input_game_8
  JSR handle_input_auto_game_8
  JMP forever

.continue:
  JSR handle_input_game_8
  JMP forever
game_8_winner:
  JMP winner_for_real
game_8_gameover:
  ;JSR play win or lose sound
  INC gamestate
  JMP forever
game_8_score:
  JMP forever
game_8_reset_first_board:
  LDA #$03
  STA gamestate
  JMP forever

check_winner:
  ;This method first sets the snake_winner variables.
  ;Next it checks all the snake_current vs snake_winner combinations.  
  ;If all the snake segments match, the method returns tempVar3=1
  ;If not all the snake segments match, the method returns tempVar3=0
  LDA ball_box
  ASL A
  STA snake_winner
  CLC
  ADC #$01
  STA snake_winner+1
  CLC 
  ADC #$01
  STA snake_winner+2
  CLC
  ADC #$07
  STA snake_winner+3

  LDX #$00
.outer_loop:
  LDY #$00
  STY tempVar3
.inner_loop:
  LDA snake_current, x
  CMP snake_winner, y
  BEQ .match
.reinsert_after_match:
  INY
  TYA
  CMP #$04
  BEQ .done_inner_loop
  JMP .inner_loop
.done_inner_loop:
  LDA tempVar3
  BEQ .no_match_at_all
  INX
  TXA 
  CMP #$04
  BEQ .done_outter_loop
  JMP .outer_loop
.match:
  LDA #$01
  STA tempVar3
  LDY #$03
  JMP .reinsert_after_match
.done_outter_loop:
  JSR game_8_bleep_sound
  JSR wait_until_sound_off
  LDA #$01
  STA tempVar3
  JMP .end
.no_match_at_all:
  LDA #$00
  STA tempVar3
.end:
  RTS

check_gameover:

  LDA tv_region
  BNE .pal_gameover

;.ntsc_gameover
  LDA timer+1
  CMP #$17
  BNE .not_game_over
  LDA timer
  CMP #$0C
  BPL .game_over
  JMP .not_game_over

.pal_gameover:
  LDA timer+1
  CMP #$13
  BNE .not_game_over
  LDA timer
  CMP #$72
  BPL .game_over
  JMP .not_game_over

.game_over:
  LDA #$00
  STA $400C

  clear_board

  LDA current_game
  CMP #$04
  BMI .skip_fix_gamestate
  CMP #$06
  BPL .skip_fix_gamestate

  LDA #$08
  STA gamestate

.skip_fix_gamestate:
  LDA hi_score_1
  STA tempVar1
  LDA #$FF
  STA hi_score_1

  JSR play_winner_or_loser_music

  LDA tempVar1
  STA hi_score_1

  SEC
  RTS

.not_game_over:
  CLC
  RTS

last_row:
  LDA ppu_y_coord
  STA $2006
  LDA #$6D
  STA $2006
  LDY #$00
.loop: 
  LDA dark_bottom_bottom_row, y
  STA $2007
  INY
  CPY #$07
  BNE .loop
  RTS

game_4_miss_ball_0:
  .db $21, $2F, $29, $2A, $FF, $21, $4F, $39, $3A, $FF
game_4_miss_ball_1:
  .db $22, $2F, $29, $2A, $FF, $22, $4F, $39, $3A, $FF
game_4_miss_ball_2:
  .db $21, $2F, $03, $04, $FF, $21, $4F, $13, $14, $FF
game_4_miss_ball_3:
  .db $22, $2F, $03, $04, $FF, $22, $4F, $13, $14, $FF
game_4_miss_ball_4:
  .db $21, $6F, $29, $2A, $FF, $21, $8F, $39, $3A, $FF
game_4_miss_ball_5:
  .db $21, $EF, $29, $2A, $FF, $22, $0F, $39, $3A, $FF
game_4_miss_ball_6:
  .db $21, $6F, $03, $04, $FF, $21, $8F, $13, $14, $FF
game_4_miss_ball_7:
  .db $21, $EF, $03, $04, $FF, $22, $0F, $13, $14, $FF

game_6_boards:
game_6_board_00:
  .db $00, $04, $09, $24 ;A=0  
game_6_board_01:
  .db $04, $08, $11, $24 ;A=4 
game_6_board_02:
  .db $08, $0C, $19, $24 ;A=8  
game_6_board_03:
  .db $0C, $10, $21, $24 ;A=C  
game_6_board_04:
  .db $01, $05, $0B, $24 ;A=10 
game_6_board_05:
  .db $05, $09, $13, $24 ;A=14  
game_6_board_06:
  .db $09, $0D, $1B, $24 ;A=18 
game_6_board_07:
  .db $0D, $11, $23, $24 ;A=1C -- end of group 1
game_6_board_08:
  .db $02, $06, $0D, $24 ;A=20 
game_6_board_09:
  .db $06, $0A, $15, $24 ;A=24 
game_6_board_10:
  .db $0A, $0E, $1D, $24 ;A=28 
game_6_board_11:
  .db $0E, $12, $25, $24 ;A=2C 

;START HORIZONTAL BOARDS
game_6_board_12:
  .db $00, $01, $02, $24 ;
game_6_board_13:
  .db $01, $02, $04, $24 ;
game_6_board_14:
  .db $04, $05, $0A, $24 ; 
game_6_board_15:
  .db $05, $06, $0C, $24 ;A=3C --end of group 2
game_6_board_16:
  .db $08, $09, $12, $24 ;A=40 --start of group 3
game_6_board_17:
  .db $09, $0A, $14, $24
game_6_board_18:
  .db $0C, $0D, $1A, $24 ;A=48
game_6_board_19:
  .db $0D, $0E, $1C, $24 ;A=4C
game_6_board_20:
  .db $10, $11, $22, $24 ;
game_6_board_21:
  .db $11, $12, $24, $24 ;

;START Edges
game_6_board_22:
  .db $00, $00, $00, $24
game_6_board_23:
  .db $00, $00, $01, $24 ;A=5C -- end of group 3
game_6_board_24:
  .db $01, $01, $03, $24 ;A=60 -- start of group 4
game_6_board_25:
  .db $02, $02, $05, $24 ;A=64
game_6_board_26:
  .db $02, $02, $06, $24
game_6_board_27:
  .db $04, $04, $08, $24
game_6_board_28:
  .db $06, $06, $0E, $24
game_6_board_29:
  .db $08, $08, $10, $24
game_6_board_30:
  .db $0A, $0A, $16, $24
game_6_board_31:
  .db $0C, $0C, $18, $24
game_6_board_32:
  .db $0E, $0E, $1E, $24
game_6_board_33:
  .db $10, $10, $20, $24
game_6_board_34:
  .db $10, $10, $29, $24
game_6_board_35:
  .db $11, $11, $2B, $24
game_6_board_36:
  .db $12, $12, $2D, $24
game_6_board_37:
  .db $12, $12, $26, $24

dark_top_row:
  .db $03,$04,$03,$04,$03,$04,$05,$0F
dark_bottom_row:
  .db $13,$14,$13,$14,$13,$14,$15,$0F
dark_bottom_bottom_row:
  .db $06,$07,$06,$07,$06,$07,$3F,$0F
erase_row_for_flicker:
  .db $13,$14,$13,$14,$13,$14,$15,$D1

;include data after the end of bank 1 (before FFFA)
  .include "game_6_update_car.asm"
  .include "game_6_erase_cones.asm"
  .include "game_7_update_screen.asm"
  .include "game_8_update_screen.asm"
  .include "handle_input_game_6.asm"
  .include "handle_input_game_7.asm"
  .include "handle_input_game_8.asm"
  .include "handle_input_auto_game_8.asm"
  .include "play_sounds.asm"
  .include "play_winner_or_loser_music.asm"

  .bank 1
  .org $FFFA     ;first of the three vectors starts here
nescallback:
  ; after this $FFFA + 2 = $FFFC
  .dw NMI      ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  ; after this $FFFC + 2 = $FFFE
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  ; after this $FFFC + 1 = $FFFF 
  .dw 0          ;external interrupt IRQ is not used in this tutorial
  
;;;;;;;;;;;;;;  
; Load in external sprite or audio data
  
  .bank 2
  .org $0000
  .incbin "split.chr"   ;includes 8KB graphics file