waitVBlank:      ; Second wait for vblank, PPU is ready after this
  BIT $2002
  BPL waitVBlank
  RTS
