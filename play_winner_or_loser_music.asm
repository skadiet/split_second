play_winner_or_loser_music:
  
  LDA hi_score_1
  CMP #$0A
  BEQ .winner

  LDA hi_score_1
  CMP score_1
  BEQ .check_ones_digit
  CMP score_1
  BMI loser_sound
  JMP .winner

.check_ones_digit:
  LDA hi_score_2
  CMP score_2
  BEQ .check_tenths_digit
  CMP score_2
  BMI loser_sound
  JMP .winner

.check_tenths_digit:
  LDA hi_score_3
  CMP score_3
  BEQ .tied
  CMP score_3
  BMI loser_sound
  ;JMP .winner 
  
.winner:
  JSR wait_until_sound_off
  ;Play winner music
  LDA #SOUND_04_HIGH_SCORE
  STA current_sound
  LDA #$01
  STA needPlaySound

  JSR wait_until_sound_off

  LDA #SOUND_04_HIGH_SCORE_2
  STA current_sound
  LDA #$01
  STA needPlaySound

  JSR wait_until_sound_off
  
  LDA score_1
  STA hi_score_1
  LDA score_2
  STA hi_score_2
  LDA score_3
  STA hi_score_3

  RTS

.tied:
  
  JSR wait_until_sound_off

  LDA #SOUND_12_TIE_SCORE
  STA current_sound
  LDA #$01
  STA needPlaySound

  RTS

loser_sound:

  JSR wait_until_sound_off

  LDA #SOUND_05_LOWER_SCORE
  STA current_sound
  LDA #$01
  STA needPlaySound

  JSR wait_until_sound_off

  RTS

game_7_bad_sound:
  LDA #SOUND_08_GAME_07_BAD_SOUND
  STA current_sound
  LDA #$01
  STA needPlaySound

  RTS

game_7_good_sound:
  LDA #SOUND_09_GAME_07_GOOD_SOUND
  STA current_sound
  LDA #$01
  STA needPlaySound

  RTS

game_8_bleep_sound:
  LDA #SOUND_10_GAME_08_BLEEP_SOUND
  STA current_sound
  LDA #$01
  STA needPlaySound

  RTS

intro_sound:

  JSR wait_until_sound_off
  
  LDA #SOUND_01_INTRO_SOUND
  STA current_sound
  LDA #$01
  STA needPlaySound

  JSR wait_until_sound_off

  RTS

sound_game_select:
  LDA #SOUND_11_GAME_SELECT_SOUND
  STA current_sound
  LDA #$01
  STA needPlaySound

  RTS

wait_until_sound_off:
  LDA needPlaySound
  BNE wait_until_sound_off
  RTS