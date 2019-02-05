meta_tile_ppu_addr_00:
  .db $21,$2D,$21,$2E,$21,$4D,$21,$4E
meta_tile_ppu_addr_01:
  .db $21,$2F,$21,$30,$21,$4F,$21,$50
meta_tile_ppu_addr_02:
  .db $21,$31,$21,$32,$21,$51,$21,$52
meta_tile_ppu_addr_03:
  .db $21,$33,$00,$00,$21,$53,$00,$00

meta_tile_ppu_addr_04:
  .db $21,$6D,$21,$6E,$21,$8D,$21,$8E
meta_tile_ppu_addr_05:
  .db $21,$6F,$21,$70,$21,$8F,$21,$90
meta_tile_ppu_addr_06:
  .db $21,$71,$21,$72,$21,$91,$21,$92
meta_tile_ppu_addr_07:
  .db $21,$73,$00,$00,$21,$93,$00,$00

meta_tile_ppu_addr_08:
  .db $21,$AD,$21,$AE,$21,$CD,$21,$CE
meta_tile_ppu_addr_09:
  .db $21,$AF,$21,$B0,$21,$CF,$21,$D0
meta_tile_ppu_addr_10:
  .db $21,$B1,$21,$B2,$21,$D1,$21,$D2
meta_tile_ppu_addr_11:
  .db $21,$B3,$00,$00,$21,$D3,$00,$00

meta_tile_ppu_addr_12:
  .db $21,$ED,$21,$EE,$22,$0D,$22,$0E
meta_tile_ppu_addr_13:
  .db $21,$EF,$21,$F0,$22,$0F,$22,$10
meta_tile_ppu_addr_14:
  .db $21,$F1,$21,$F2,$22,$11,$22,$12
meta_tile_ppu_addr_15:
  .db $21,$F3,$00,$00,$22,$13,$00,$00

meta_tile_ppu_addr_16:
  .db $22,$2D,$22,$2E,$22,$4D,$22,$4E
meta_tile_ppu_addr_17:
  .db $22,$2F,$22,$30,$22,$4F,$22,$50
meta_tile_ppu_addr_18:
  .db $22,$31,$22,$32,$22,$51,$22,$52
meta_tile_ppu_addr_19:
  .db $22,$33,$00,$00,$22,$53,$00,$00

meta_tile_ppu_addr_20:
  .db $22,$6D,$22,$6E,$00,$00,$00,$00
meta_tile_ppu_addr_21:
  .db $22,$6F,$22,$70,$00,$00,$00,$00
meta_tile_ppu_addr_22:
  .db $22,$71,$22,$72,$00,$00,$00,$00
meta_tile_ppu_addr_23:
  .db $00,$00,$00,$00,$00,$00,$00,$00

meta_tile_ppu_addr_coordinates:
  .word meta_tile_ppu_addr_00,meta_tile_ppu_addr_01,meta_tile_ppu_addr_02,meta_tile_ppu_addr_03
  .word meta_tile_ppu_addr_04,meta_tile_ppu_addr_05,meta_tile_ppu_addr_06,meta_tile_ppu_addr_07
  .word meta_tile_ppu_addr_08,meta_tile_ppu_addr_09,meta_tile_ppu_addr_10,meta_tile_ppu_addr_11
  .word meta_tile_ppu_addr_12,meta_tile_ppu_addr_13,meta_tile_ppu_addr_14,meta_tile_ppu_addr_15
  .word meta_tile_ppu_addr_16,meta_tile_ppu_addr_17,meta_tile_ppu_addr_18,meta_tile_ppu_addr_19
  .word meta_tile_ppu_addr_20,meta_tile_ppu_addr_21,meta_tile_ppu_addr_22,meta_tile_ppu_addr_23
