.scope	io

CONIN := $0800
CONOUT := $0801

control = $30

returnl := control
returnh := returnl + 1
return := control
saveda := returnh + 1
savedx := saveda + 1
savedy := savedx + 1


.proc	inchr
	lda CONIN
	rts
.endproc

.proc	outchr
	sta CONOUT
	rts
.endproc	; outchr


; outstr
;	example:
;		jsr library::io::outstr
; 		asciiz "Hello world,"
.proc	outstr

	sta saveda

	pla
	sta returnl	; address low
	pla
	sta returnh	; address high

	sty savedy

	; Print each character in turn (first character is offset by one)
	ldy #0
loop:	iny
	lda (return),y
	beq finished
	jsr outchr
	bne loop
finished:
	; Sort out the return address so 
	clc
	tya
	adc returnl
	sta returnl
	lda #0
	adc returnh
	pha
	lda returnl
	pha

	ldy savedy
	lda saveda

	rts
.endproc	; outstr

.endscope	; io
