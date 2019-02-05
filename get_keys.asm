ReadController1:
  LDA buttons_this
  STA buttons_last; store buttons_this into buttons_last to remember the last pressed buttons
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
ReadController1Loop:
  LDA $4016
  LSR A            ; bit0 -> Carry
  ROL buttons_this     ; bit0 <- Carry
  DEX
  BNE ReadController1Loop
  LDA buttons_last  ; take last buttons to be pressed and EOR them
  EOR #$FF          ; with FF so that we will only see the buttons which are newly pressed (not finger left on)
  AND buttons_this  ; if there is a new button pressed and that button is in buttons_this then 
  STA buttons       ; save it to the buttons variable
  RTS
