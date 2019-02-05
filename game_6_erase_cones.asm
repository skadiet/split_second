eraseCones:
  LDA #LOW(meta_tiles)
  STA meta_tiles_ptr
  LDA #HIGH(meta_tiles)
  STA meta_tiles_ptr+1

  LDA #LOW(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr
  LDA #HIGH(meta_tile_ppu_addr_coordinates)
  STA meta_tile_ppu_addr_coords_ptr+1

  LDA #$03
  ASL A
  TAY

  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr
  INY
  LDA [meta_tiles_ptr], y
  STA meta_tile_ptr+1 ;at this point we have the address of the metatile needed

  LDA ball_box_old
  ASL A
  TAY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr
  INY
  LDA [meta_tile_ppu_addr_coords_ptr], y
  STA meta_tile_ppu_addr_coord_ptr+1 ;at this point we have the address of the metatile needed

  LDY #$00
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  ;STA top left of the box
  LDY #$00
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

  ;load bottom
  LDY #$04
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006
  INY
  LDA [meta_tile_ppu_addr_coord_ptr],y
  STA $2006

  LDY #$03
  LDA [meta_tile_ptr],y
  STA $2007
  INY
  LDA [meta_tile_ptr],y
  STA $2007

.end_loop:
  RTS

