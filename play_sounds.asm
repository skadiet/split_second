playSound:
  ;current_sound is one byte.  It's the index of whichever song is supposed to be currently playing.
  ;current_sound_address_lo is the full 16 bit address of the lo byte of the sound
  ;current_sound_address_hi is the full 16 bit address of the hi byte of the sound
  ;sounds are structured with the first byte == length of the note.  $FF signifies the end of a tune.
  LDA $4015
  AND #$01
  CMP #$01  
  BEQ .end_sub
  
  LDX current_sound
  LDA sound_addresses_lo, x
  STA current_sound_address_lo
  LDA sound_addresses_lo+1, x
  STA current_sound_address_lo+1
  
  LDA sound_addresses_hi, x
  STA current_sound_address_hi
  LDA sound_addresses_hi+1, x
  STA current_sound_address_hi+1

  LDA current_sound_pointer
  BNE .continue
  LDY #$00
  LDA [current_sound_address_lo], y 
  STA current_sound_length
  INC current_sound_pointer
  
.continue:
  LDY current_sound_pointer
  LDA [current_sound_address_lo], y ; this is confusing because it looks like the low byte of something.
;It's acutally describing the full 16 bit address of the lo byte of the sound
  CMP #$FF
  BEQ .stop_noise
  STA $4002
  LDA [current_sound_address_hi], y
  EOR current_sound_length
  STA $4003
  
  INC current_sound_pointer
  JMP .end_sub

.stop_noise:
  LDA #$00
  STA current_sound_pointer
  STA needPlaySound

.end_sub:
  RTS

sound_addresses_lo:
  .dw sound_game_1_win_lo, sound_startup_lo, sound_game_1_boop_lo, sound_high_score_1_lo
  .dw sound_high_score_2_lo, sound_low_score_lo, sound_game_4_gun_lo, sound_game_6_bloop_lo
  .dw sound_game_7_bad_lo, sound_game_7_good_lo, sound_game_8_bleep_lo, sound_game_select_lo
  .dw sound_tie_score_lo
sound_addresses_hi:
  .dw sound_game_1_win_hi, sound_startup_hi, sound_game_1_boop_hi, sound_high_score_1_hi
  .dw sound_high_score_2_hi, sound_low_score_hi, sound_game_4_gun_hi, sound_game_6_bloop_hi
  .dw sound_game_7_bad_hi, sound_game_7_good_hi, sound_game_8_bleep_hi, sound_game_select_hi
  .dw sound_tie_score_hi
sound_game_1_win_lo:
  .db $68,$7F, $A6, $CE, $F9, $26, $56, $FF
sound_game_1_win_hi:
  .db $68,$02, $02, $02, $02, $03, $03, $FF

sound_startup_lo:
  .db $58, $AB, $93, $7C, $67, $52, $3F, $2D, $1C, $0C, $FD, $EF, $E2, $D2, $BD, $AD, $FF
sound_startup_hi:
  .db $58, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $FF

sound_game_1_boop_lo:
  .db $68, $F8, $FF
sound_game_1_boop_hi:
  .db $68, $03, $FF

sound_high_score_1_lo:
  .db $58, $7c, $67, $52, $3f, $2d, $1c, $0c, $fd, $FF
sound_high_score_1_hi:
  .db $58, $01, $01, $01, $01, $01, $01, $01, $00, $FF
 
sound_high_score_2_lo:
  .db $48, $C9, $BD, $C9, $BD, $C9, $BD, $C9, $BD, $C9, $BD
  .db $C9, $BD, $C9, $BD, $C9, $BD, $C9, $BD, $C9, $BD, $C9, $BD, $FF
sound_high_score_2_hi:
  .db $48, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FF

sound_low_score_lo:
  .db $F8, $f9, $26, $56, $89, $bf, $FF
sound_low_score_hi:
  .db $F8, $02, $03, $03, $03, $03, $FF

sound_game_4_gun_lo:
  .db $38, $EF, $C4, $EF, $C4, $EF, $FF
sound_game_4_gun_hi:
  .db $38, $00, $04, $00, $04, $00, $FF

sound_game_6_bloop_lo:
  .db $38, $F9, $F9, $7E, $FF
sound_game_6_bloop_hi:
  .db $38, $02, $02, $00, $FF

sound_game_7_bad_lo:
  .db $48, $50, $FF
sound_game_7_bad_hi:
  .db $48, $03, $FF

sound_game_7_good_lo:
  .db $48, $D0, $FF
sound_game_7_good_hi:
  .db $48, $00, $FF

sound_game_8_bleep_lo:
  .db $28, $D5, $C9, $B3, $B3, $FF
sound_game_8_bleep_hi:
  .db $28, $00, $00, $00, $00, $FF

sound_game_select_lo:
  .db $48, $9B, $FF
sound_game_select_hi:
  .db $48, $00, $FF

sound_tie_score_lo:
  .db $F8, $89, $26, $F8, $FF
sound_tie_score_hi:
  .db $F8, $03, $03, $03, $FF