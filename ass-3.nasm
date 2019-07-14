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
			db	10,"1. HEX to BCD"
			db	10,"2. BCD to HEX"
			db	10,"3. Exit",10
	menu_len	equ	$-menu
	msghtb1		db	10,"hex to bcd"
			db	10,"Enter 4 digit hex number: "
	msghtb1_len	equ	$-msghtb1
	msgbth1		db	10,"bcd to hex"
			db	10,"Enter 5 digit bcd number: "
	msgbth1_len	equ	$-msgbth1
	msgerr		db	"Invalid choice!",10
	msgerr_len	equ	$-msgerr
	msgerr2		db	"Invalid input!",10
	msgerr2_len	equ	$-msgerr2
	msgbcd		db	"Equivalent BCD number: "
	msgbcd_len	equ	$-msgbcd
	msghex		db	"Equivalent HEX number: "
	msghex_len	equ	$-msghex
;---------------------------------------------------------------------
section .bss
	getnum		resb	6
	getnum_len	equ	$-getnum
	digitcnt	resb	1
	ans		resb	1
	char_ans	resb	4
;---------------------------------------------------------------------
global _start
section .text
_start:
	print	menu,menu_len
	read	getnum,2
	mov	rax,00
	mov	al,[getnum]
	
choice1:	cmp	al,31h
		jne	choice2
		call	hex_bcd
		jmp _start
		
choice2:	cmp	al,32h
		jne	choice3
		call	bcd_hex
		jmp _start	
		
choice3:	cmp	al,33h
		jne	error
		exit	
		
error:		print	msgerr,msgerr_len
		jmp _start
;---------------------------------------------------------------------
hex_bcd:
	print	msghtb1,msghtb1_len
	call	input_num
	
	mov	ax,bx
	mov	rbx,10
up:
	mov	rdx,0
	div	rbx
	push	dx
	inc	byte [digitcnt]
	cmp	rax,0
	jnz	up
	
	print	msgbcd,msgbcd_len
up2:	
	pop	dx
	add	dl,30h
	mov	[ans],dl
	
	print	ans,1
	dec	byte [digitcnt]
	jnz	up2
	ret
;---------------------------------------------------------------------
bcd_hex:
	print	msgbth1,msgbth1_len
	read	getnum,getnum_len		

	mov	rsi,getnum
	mov	rax,0		
	mov 	rbx,10		
	mov 	rcx,05		

up3:	
	mul 	ebx		
	mov	rdx,0
	mov 	dl,[rsi]	
	sub 	dl,30h		
	add 	rax,rdx

	inc 	rsi

	dec	rcx
	jnz	up3
	mov	[ans],ax

	print	msghex,msghex_len
	mov	ax,[ans]
	call	print_num
	ret
;---------------------------------------------------------------------		
input_num:
	read	getnum,6
	mov	rsi,getnum
	mov	rbx,00
	mov	rax,00
	mov	rcx,4
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

down:	add	bx,ax
	inc	rsi
	loop	next_digit
	ret
;--------------------------------------------------------------------
print_num:
	mov 	rsi,char_ans+3	
	mov 	rcx,4		 

cnt:	mov 	rdx,0		
	mov 	rbx,16		
	div 	rbx
	cmp 	dl, 09h		 
	jbe  	down2
	add  	dl, 37h
	jmp	down3 
down2:
	add 	dl,30h		
down3:	mov 	[rsi],dl	
	dec 	rsi		
	dec 	rcx		
	jnz 	cnt		
	print	char_ans,4	
ret
;--------------------------------------------------------------------
