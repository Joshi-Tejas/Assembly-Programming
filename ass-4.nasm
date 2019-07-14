%macro print 2
	mov	rax,1
	mov	rdi,1
	mov	rsi,%1
	mov	rdx,%2
	syscall
%endmacro

%macro read 2
	mov	rax,0
	mov	rdi,0
	mov	rsi,%1
	mov	rdx,%2
	syscall
%endmacro

%macro exit 0
	mov	rax,60
	mov	rdi,0
	syscall
%endmacro
;----------------------------------------------------------------------
section .data
	menu		db	10,"------------menu------------"
			db	10,"1. Repetative addition"
			db	10,"2. Shift and Add"
			db	10,"3. Exit",10
	menu_len	equ	$-menu
	msgrep		db	10,"Repetative addition"
			db	10,"Enter number: "
	msgrep_len	equ	$-msgrep		
	msgrep1		db	"Enter multiplier: "
	msgrep1_len	equ	$-msgrep1
	msgshft		db	10,"Shift and Add"
			db	10,"Enter number: "
	msgshft_len	equ	$-msgshft
	msgerr		db	"Invalid choice!",10
	msgerr_len	equ	$-msgerr
	msgerr2		db	"Invalid input!",10
	msgerr2_len	equ	$-msgerr2
	msgmult		db	"Multiplication : "
	msgmult_len	equ	$-msgmult
	enter1		db	0ah
;---------------------------------------------------------------------
section .bss
	input		resb	2
	number		resb	3
	multip		resb	3
	temp		resb	4
	ans		resb	1
	char_ans	resb	4
;---------------------------------------------------------------------
global _start
section .text
_start:
	print	menu,menu_len
	read	input,2
	mov	rax,00
	mov	al,[input]
	
choice1:	cmp	al,31h
		jne	choice2
		call	repeat
		jmp _start
		
choice2:	cmp	al,32h
		jne	choice3
		call	shift_add
		jmp _start	
		
choice3:	cmp	al,33h
		jne	error
		exit	
		
error:		print	msgerr,msgerr_len
		jmp _start
;---------------------------------------------------------------------
repeat:
	print	msgrep,msgrep_len
	read	number,3
	mov	rsi,number
	call	convert_asci
	mov	[number],bx
	
	print	msgrep1,msgrep1_len
	read	multip,3
	mov	rsi,multip
	call	convert_asci
	mov	[multip],bx

	mov	rax,00h
	mov	rbx,00h
	mov	rcx,00h
	mov	cl,[multip]
	cmp	cl,00h
	je	down2
up1:
	add	eax,[number]
	dec	cl
	jnz	up1
down2:
	mov	[number],ax
	mov	rsi,number
	mov	rdi,temp
	call	convert_hex
	print	msgmult,msgmult_len
	print	temp,4
	print	enter1,1
	ret
;---------------------------------------------------------------------
shift_add:
	print	msgshft,msgshft_len
	read	number,3
	mov	rsi,number
	call	convert_asci
	mov	[number],bx
	
	print	msgrep1,msgrep1_len
	read	multip,3
	mov	rsi,multip
	call	convert_asci
	mov	[multip],bx
	
	mov	rax,00h
	mov	rbx,00h
	mov	rcx,08h
	mov	bx,[number]
	mov	[number],ax
	mov	ax,[multip]
	
next_bit:
	bt	ax,0
	jc	label
	jmp	down5
label:	add	[number],bx
down5:	shl	ebx,1
	shr	eax,1
	dec	rcx
	jnz	next_bit
	
	mov	rsi,number
	mov	rdi,temp
	call	convert_hex
	print	msgmult,msgmult_len
	print	temp,4
	print	enter1,1
	ret
;---------------------------------------------------------------------
convert_asci:
	mov	rbx,00
	mov	rax,00
	mov	rcx,2
next_digit:
	shl	bx,4
	mov	al,[rsi]
	cmp	al,"0"
	jb	error2
	cmp	al,"9"
	jbe	sub30
	
	cmp	al,"A"
	jb	error2
	cmp	al,"F"
	jbe	sub37
	
	cmp	al,"a"
	jb	error2
	cmp	al,"f"
	jbe	sub57
	
error2:	print	msgerr2,msgerr2_len
	exit
sub30:	sub	al,30h
	jmp down
sub37:	sub	al,37h
	jmp down
sub57:	sub	al,57h

down:
	add	bx,ax
	inc	rsi
	loop	next_digit
	ret
;---------------------------------------------------------------------
convert_hex:
	mov	ax, word [rsi]
	mov	cl,04h
up2:	rol	ax,4
	mov	bx,ax
	and	ax,000fh
	cmp	ax,09h
	ja 	down3
	add	ax,30h
	jmp	down4
down3:	add	ax,37h
down4:	mov	byte [rdi],al
	mov	ax,bx
	inc	rdi
	dec	cl
	jnz	up2
	ret
;---------------------------------------------------------------------
