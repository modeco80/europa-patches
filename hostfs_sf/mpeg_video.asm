
; reminders:

; disable iop-side buffer alloc (not needed with the st rewrites)
;
; alloc: nop 004536f4, 004536f8, and 004536fc
; or just make it load 0 into v0 so that it always gives 0
;
; free: nop 004537f8 and 004537fc

.create "mpeg_first_chunk.bin", mpeg_first_chunk
mpeg_first_chunk_patch:
    ; Do initial argument setup
    addiu a1, sp, 0x60  ; a1 will point to filename string in stack
    li a2, 0
    ; There is nothing of interest we need to execute
    ; after we do this setup. Therefore, we simply just
    ; fill the rest of this area of code with nops. 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
.close

.create "mpeg_second_chunk.bin", mpeg_second_chunk
mpeg_second_chunk_patch:
    ; Do initial argument setup
    addiu a1, sp, 0x60  ; a1 will point to filename string in stack
    li a2, 0
    ; There is nothing of interest we need to execute
    ; after we do this setup. Therefore, we simply just
    ; fill the rest of this area of code with nops. 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
.close