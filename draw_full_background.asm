drawFullBackground:

  LDA #$00
  STA $2000
  STA $2001
  LDA $2002

  LDA nametable_address_hi
  STA $2006
  LDA #$00
  STA $2006

  LDA $2002
  LDX #$00

  ;; we need to copy more than 256
  ;; 960 bytes = $03C0
  LDA #$C0;
  STA counterLo
  LDA #$03
  STA counterHi

  LDY #$00; keep y zero, we jut need y to be init to 0 for indirect index mode to work in the square bracket
LoadBackgroundLoop:
  LDA [backgroundLo], y ; load data from background
  CMP #$0F
  BNE .not_compressed

;compressed
  LDA backgroundLo      ; load the low byte of the background address into A
  CLC                   ; clear the carry bit
  ADC #$01              ; add 1 to A
  STA backgroundLo      ; store A back into the mem addr
  LDA backgroundHi      ; load the high byte of the background address into A
  ADC #$00              ; add 0, but if there is a carry (overflow) add 1
  STA backgroundHi      ; inc poitner to the next byte if necessary

  LDA [backgroundLo], y ; load the # of times to repeat $0F
  TAX
.compressed_loop:
  LDA counterLo         ; load the counter low byte
  SEC                   ; set cary flag
  SBC #$01              ; subtract with carry by 1
  STA counterLo         ; store the low byte of the counter
  LDA counterHi         ; load the high byte
  SBC #$00              ; sub 0, but there is a carry
  STA counterHi       ; decrement the loop counter

  LDA #$0F
  STA $2007
  DEX
  BNE .compressed_loop
  JMP .continue_loading

.not_compressed:
  STA $2007             ; write to PPU data port to copy to background data

  LDA counterLo         ; load the counter low byte
  SEC                   ; set cary flag
  SBC #$01              ; subtract with carry by 1
  STA counterLo         ; store the low byte of the counter
  LDA counterHi         ; load the high byte
  SBC #$00              ; sub 0, but there is a carry
  STA counterHi       ; decrement the loop counter

.continue_loading:
  LDA backgroundLo      ; load the low byte of the background address into A
  CLC                   ; clear the carry bit
  ADC #$01              ; add 1 to A
  STA backgroundLo      ; store A back into the mem addr
  LDA backgroundHi      ; load the high byte of the background address into A
  ADC #$00              ; add 0, but if there is a carry (overflow) add 1
  STA backgroundHi      ; inc poitner to the next byte if necessary

  LDA counterLo         ; load the low byte
  CMP #$00              ; see if it is zero, if not loop
  BNE LoadBackgroundLoop
  LDA counterHi
  CMP #$00              ; see if the high byte is zero, if not loop
  BNE LoadBackgroundLoop  ; if the loop counter isn't 0000, keep copying

  RTS
