; This ASM file rewrites the sceCdSt functions entirely.
; Instead of being a CD stream, they now read a FIO opened file.
; Additionally, sceCdStStart(..., ...)'s signature is patched
; to become more like/expect sceCdStStart(const char*).
;
; This is used by the mpeg player patch to make IT hostfs-able.
;
; This patch could in theory be used in other projects, but
; ehhh..

; max 12 insts space
; all init args are ignored, for simplicity,
; we only read when the user asks us to, we do not readahead
.create "sceCdStInit.bin", sceCdStInit
.org sceCdStInit
sceCdStInit_patch:
    jr ra                           ; feign ignorance
    ori v0, v0, 1                       ; yes these assholes seriously use 1 as sucess

; We use the data after our stub sceCdStInit() implementation as data storage
; for our patch. Currently, 36/40 bytes are free to do whatever we want with.
fioFakeStreamFd: .word 0xffffffff    ; FIO fd for the file we are "streaming"
sceCdStInit_patch_end:
.close

; this patched version of sceCdStStart() expects
; that you have modified calling code prior to put
; the address of a path string into a0.
.create "sceCdStStart.bin", sceCdStStart
.org sceCdStStart
sceCdStStart_patch:
    addiu sp, sp, -4
    sw ra, 0(sp)
    jal startImpl                    ; go to impl function
    nop
    lw ra, 0(sp)
    jr ra
    addiu sp, sp, 4

sceCdStStart_patch_end:
.notice "Used bytes for sceCdStStart patch: " + (sceCdStStart_patch_end - sceCdStStart_patch)
.close

.create "sceCdStStop.bin", sceCdStStop
.org sceCdStStop
sceCdStStop_patch:
.if 0 ; error handling implementation, won't work because 
      ; we don't have enough space.
    ; check if the file is open, if so,
    ; then close it. otherwise just return 0
    lui t1, hi(fioFakeStreamFd)
    ori t1, t1, lo(fioFakeStreamFd)
    lw t0, 0(t1)
    bltz t0, @@justret     ; if fd is negative
    nop                     ; skip trying to close it.
@@closeit:
    jal sceClose            ; close it.
    move a0, t0
    lui t0, 0xffff         ; overwrite the fd
    ori t0, t0, 0xffff    ; not strictly needed
    sw t0, 0(t1)          ; but to be nice.
@@justret:
    jr ra
    ori v0, zero, 1
.else
    addiu sp, sp, -8
    sw ra, 0(sp)        ; stack frame setup
    sw gp, 4(sp)        ; (save ra and gp)
    lui t1, hi(fioFakeStreamFd)
    ori t1, t1, lo(fioFakeStreamFd)
    jal sceClose        ; close the fd
    lw a0, 0(t1)        ; fd = fioFakeStreamFd

    lw ra,0(sp)
    lw gp,4(sp)
    ori v0, zero, 1
    jr ra
    addiu sp, sp, 8
.endif
sceCdStStop_patch_end:
.notice "Used bytes for sceCdStStop patch: " + (sceCdStStop_patch_end - sceCdStStop_patch)
.close

.create "sceCdStRead.bin", sceCdStRead
.org sceCdStRead
; params we care about:
; a0 - number of sectors to read (we need to shift this back to bytes)
; a1 - buffer (we can just pass this to sceRead)
; a3 - error
sceCdStRead_patch:
    addiu sp, sp, -16
    lui t1, hi(fioFakeStreamFd)
    ori t1, t1, lo(fioFakeStreamFd)
    lw t0, 0(t1)        
    sw ra, 0(sp)         ; save important stuff to stack
    sw t0, 4(sp)         ; fd
    sw a1, 8(sp)         ; buffer
    sw gp, 12(sp)        ; gp
    bltz t0, @@error     ; if (fioFakeStreamFd < 0)
    nop

@@ok:                    ; it's not, let's read.
    sll t1, a0, 0xb      ; number of sectors * 0x800 (2048)
                         ; this expands back what the user
                         ; turned into sector count.
    lw a0, 4(sp)         ; fd=4(sp)
    lw a1, 8(sp)         ; buffer=8(sp)
    jal sceRead          ; call sceRead
    move a2, t1          ; size=t1
    sw zero, 0(a3)       ; no error (not strictly needed)
    lw ra, 0(sp)         ; stack prologue
    lw gp, 12(sp)        ; ...
    sra v0,v0,0xb        ; multiply read bytes
                         ; back to a sector count
    jr ra                ; return success
    addiu sp, sp, 16     ; ...

@@error:                 ; it is. :( fail
    ori t0, zero, 1
    sw t0, 0(a3)
    lw ra, 0(sp)        ; stack prologue
    lw gp, 12(sp)       ; (restore ra and gp)
    ori v0, zero, 0
    jr ra               ;...
    addiu sp, sp, 16    ; generic stack prologue

; implementation of sceCdStStart() patch is put here
; since it
startImpl:
    addiu sp, sp, -4
    sw ra, 0(sp)
    jal fioOpenHostPath             ; call helper function for opening host file
    nop                             ; path is in a0 already so we dont need to do anything with it

    bltz v0, @@fail                 ; if(fd < 0)
    nop
    lui t0, hi(fioFakeStreamFd)     ; store fd into our global data
    ori t0, t0, lo(fioFakeStreamFd)
    sw v0, 0(t0)
    lw ra, 0(sp)                  
    addiu sp, sp, 4
    jr ra                           ; return success
    ori v0, zero, 1
@@fail:
    lw ra, 0(sp)                  
    ori v0, zero, 0
    jr ra                           ; epic fail
    addiu sp, sp, 4

; fioOpenHostPath(a0: string pointer)
; returns sceOpen() result code directly.
fioOpenHostPath:
    addiu sp, -16                        ; stack

    lui t0, hi(@@tmp_buffer)
    ori t0, t0, lo(@@tmp_buffer)
    sw t0, 0(sp)                        ; put addresses
    sw a0, 4(sp)                        ; on the stack
    sw ra, 8(sp)
    sw gp, 12(sp)

    lw  a0, 0(sp)                       ;tmp buffer
    lui a1, hi(@@prefix)
    ori a1, a1, lo(@@prefix)
    jal strcpy                          ; copy in the prefix first
    nop

    lw  a0, 0(sp)                       ;tmp buffer
    lw  a1, 4(sp)
    jal strcat                          ; add in the path
    nop

; this code is temporary
    lw a0, 0(sp)
    lui a1, hi(@@suffix)
    ori a1, a1, lo(@@suffix)
    jal strcat                          ; finally, add in the suffix
    nop
; end temporary notice

    ; ok, now let's call sceOpen()
    lw a0, 0(sp)
    jal sceOpen                     ; try an FIO open()
    ori a1, zero, 0x1               ; flags=SCE_RDONLY
    lw ra, 8(sp)                    ; restore ra from stack
    lw gp, 12(sp)                   ; restore gp, because sceOpen() is stupid
    jr ra                           ; return
    addiu sp, sp, 16               ; make sure to be nice to the stack :)


; temporary buffer for filename used by fioOpenHostPath()
@@tmp_buffer: .fill 64
.align

; drive prefix.
@@prefix: .asciiz "cdrom0:\\"
.align

; this code is temporary
; drive suffix. Testing only
@@suffix: .asciiz ";1"
.align
; end temporary notice

sceCdStRead_patch_end:
.notice "sceCdStRead patch byte length: " + (sceCdStRead_patch_end - sceCdStRead_patch)
.close