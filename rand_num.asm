rand_num:
  LDX #$08
  LDA seed
.loop:
  ASL A
  ROL seed+1
  BCC .loop2
  EOR #$2D
.loop2:
  DEX
  BNE .loop
  STA seed
  CMP #$00
  RTS
