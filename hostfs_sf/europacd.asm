; Patches the EUROPA.CD file loading/lookup code
; to an effective no-op.

;.create "EuropaCD_Load.bin", EuropaCD_Load
;EuropaCD_Load_patch:
;    jr ra               ; Don't actually load anything
;    nop
;.close

; This patch will be used once everything is using FIO
; since by then the lookup code will be unnesscary.
;
;.create "EuropaCD_Lookup.bin", EuropaCD_Lookup
;EuropaCD_Lookup_patch:
;    jr ra               ; Pretend all files exist
;    li v0, 0            ; 0 == file exists.
;.close