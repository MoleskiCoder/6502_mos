;
; BBC Micro Minimal MOS emulator
;

.setcpu "6502"

.segment "MOS"

.include "io.inc"


.proc oswrch_imp
	jmp io::outchr
.endproc

.proc osrdch_imp
loop:
	jsr io::inchr
	beq loop
	clc
	rts
.endproc

.proc osargs_imp
	cpy #0
	bne unimplemented
	cmp #0
	bne unimplemented
	lda #4			; pretent we're DFS
	rts
unimplemented:
	brk
.endproc


; OS Vectors
USERV	:= $0200		; The user vector
BRKV	:= $0202		; The BRK vector
IRQ1V	:= $0204		; Primary interrupt vector
IRQ2V	:= $0206		; Unrecognised IRQ vector
CLIV	:= $0208		; Command line interpeter
BYTEV	:= $020A		; *FX/OSBYTE call
WORDV	:= $020C		; OSWORD call
WRCHV	:= $020E		; Write character
RDCHV	:= $0210		; Read character
FILEV	:= $0212		; Load/save file
ARGSV	:= $0214		; Load/save file data
BGETV	:= $0216		; Get byte from file
BPUTV	:= $0218		; Put byte in file
GBPBV	:= $021A		; Multiple BPUT/BGET
FINDV	:= $021C		; Open or close file

; To be written to $200
os_vectors:
	.word 0			; USERV
	.word 0			; BRKV
	.word 0			; IRQ1V
	.word 0			; IRQ2V
	.word 0			; CLIV
	.word 0			; BYTEV
	.word 0			; WORDV
	.word oswrch_imp	; WRCHV
	.word osrdch_imp	; RDCHV
	.word 0			; FILEV
	.word osargs_imp	; ARGSV
	.word 0			; BGETV
	.word 0			; BPUTV
	.word 0			; GBPBV
	.word 0			; FINDV

.proc init_os_vectors
	ldx #15		; Number of vectors
	ldy #0
loop:
	lda os_vectors,y
	sta $200,y
	iny
	lda os_vectors,y
	sta $200,y
	iny

	dex
	bne loop
	rts
.endproc



.proc reset

language_rom = $8000

	jsr init_os_vectors
	lda #1
	jmp language_rom
	
.endproc


; MOS user entry points

.segment "OSENTRY"

.proc OSFIND
	jmp (FINDV)
.endproc

.proc OSGBPB
	jmp (GBPBV)
.endproc

.proc OSBPUT
	jmp (BPUTV)
.endproc

.proc OSBGET
	jmp (BGETV)
.endproc

.proc OSARGS
	jmp (ARGSV)
.endproc

.proc OSFILE
	jmp (FILEV)
.endproc

.proc OSRDCH
	jmp (RDCHV)
.endproc

.proc OSASCI
	cmp  #$0d
	bne  OSWRCH
.endproc

.proc OSNEWL
	lda  #$0a
	jsr  OSWRCH
	lda  #$0d
.endproc

.proc OSWRCH
	jmp (WRCHV)
.endproc

.proc OSWORD
	jmp (WORDV)
.endproc

.proc OSBYTE
	jmp (BYTEV)
.endproc

.proc OSCLI
	jmp (CLIV)
.endproc


.segment "CPUVECTORS"

        .word   0
        .word   reset
        .word   0
