;-------------------------
; add_to_dbuffer will convert a text string into a dbuffer string and add it to the drawing buffer.
;   add_to_dbuffer expects:
;       HI byte of the target PPU address in A, 
;       LO byte of the target PPU address in Y
;       pointer to the source text string in textPointer1
;   dbuffer string format:
;       byte 0: length of data (ie, length of the text string)
;       byte 1-2: target PPU address (HI byte first)
;       byte 3-n: bytes to copy
;   Note:   dbuffer starts at $0100.  This is the stack page.  The
;               stack counts backwards from $1FF, and this program is small enough that there
;               will never be a conflcit.  But for larger programs, watch out.
add_to_dbuffer:
    ldx dbuffer_index
    sta $0101, x    ;write target PPU address to dbuffer
    tya
    sta $0102, x
    
    ldy #$00
.loop:
    lda [textPointer1Lo], y
    cmp #$FF
    beq .done
    sta $0103, x    ;copy the text string to dbuffer,
    iny
    inx
    bne .loop
.done:
    ldx dbuffer_index
    tya
    sta $0100, x        ;store string length at the beginning of the string header
    
    clc
    adc dbuffer_index
    adc #$03        
    sta dbuffer_index   ;update buffer index.  new index = old index + 3-byte header + string length
    
    tax
    lda #$00
    sta $0100, x        ;stick a 0 on the end to terminate dbuffer.
    rts


;------------------------
; draw_dbuffer will write the contents of the drawing buffer to the PPU
;       dbuffer is made up of a series of drawing strings.  dbuffer is 0-terminated.
;       See add_to_dbuffer for drawing string format.
draw_dbuffer:
    ldy #$00
.header_loop:
    lda $0100, y
    beq .done       ;if 0, we are at the end of the dbuffer, so quit
    tax             ;else this is how many bytes we want to copy to the PPU
    iny
    lda $0100, y    ;set the target PPU address
    sta $2006
    iny
    lda $0100, y
    sta $2006
    iny
.copy_loop:
    lda $0100, y    ;copy the contents of the drawing string to PPU
    sta $2007
    iny
    dex
    bne .copy_loop
    beq .header_loop    ;when we finish copying, see if there is another drawing string.    
.done:
    ldy #$00
    sty dbuffer_index   ;reset index and "empty" the dbuffer by sticking a zero in the first position
    sty $0100
    rts
