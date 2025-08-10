; This include file provides the addresses of 
; the functions that we're:
; - Interested in thunking
; - Interested in calling

; In theory, this should allow the patch to be
; made cross region relatively easily.. just find
; these functions and boom.
;
; This is parsed by a shoddily written python script,
; so this file should only have equates in it.

; CPS2CDStore methods (that we care about/need to override)
CPS2CDStore_ct equ 0x302990 ; constructor 
CPS2CDStore_dt equ 0x302b20 ; destructor
CPS2CDStore_Open equ 0x302c20
CPS2CDStore_Close equ 0x302d20
CPS2CDStore_SeekToBeginning equ 0x302d50
CPS2CDStore_Seek equ 0x302da0
CPS2CDStore_SeekToEnd equ 0x302e00
CPS2CDStore_Read equ 0x302e60
CPS2CDStore_ReadString equ 0x302ed0
CPS2CDStore_ReadLine equ 0x302f50
CPS2CDStore_Write equ 0x302ff0
CPS2CDStore_Resize equ 0x303000
CPS2CDStore_GetSize equ 0x303010
CPS2CDStore_GetCurrPos equ 0x303060
CPS2CDStore_IsOpen equ 0x3030b0

; CPS2DiskStore methods
CPS2DiskStore_ct equ 0x13c520 ; constructor 
CPS2DiskStore_dt equ 0x13c6b0 ; destructor
CPS2DiskStore_Open equ 0x13c7b0
CPS2DiskStore_Close equ 0x13ca80
CPS2DiskStore_SeekToBeginning equ 0x13cad0
CPS2DiskStore_Seek equ 0x13cb00
CPS2DiskStore_SeekToEnd equ 0x13cb30
CPS2DiskStore_Read equ 0x13cb60
CPS2DiskStore_ReadString equ 0x13cbc0
CPS2DiskStore_ReadLine equ 0x13cc60
CPS2DiskStore_Write equ 0x13cd20
CPS2DiskStore_Resize equ 0x13cd30
CPS2DiskStore_GetSize equ 0x13cd40
CPS2DiskStore_GetCurrPos equ 0x13cd70
CPS2DiskStore_IsOpen equ 0x13cda0