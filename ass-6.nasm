%macro read 3
	mov rax,0
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

%macro fileopen 1
	mov rax,2
	mov rdi,%1
   	mov rsi,0102o
	mov rdx,0666o
	syscall
%endmacro

%macro fileclose 1
	mov rax,3
	mov rdi,%1
	syscall
%endmacro

%macro print 3
	mov rax,1
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

;-----------------------------------------------------------------
section .data
	
	msg1		db	10,13,"Numbers before sorting : ",10
	msg1_len	equ	$-msg1
	msg2		db	10,13,"Numbers after sorting : "
	msg2_len	equ	$-msg2
	fname		db	'numb.txt'
;-----------------------------------------------------------------
section .bss
	getnum		resb	2
	fh		resb	8
	str1		resb	16
	
;-----------------------------------------------------------------
global _start
section .text
_start:
	fileopen	fname
	mov	[fh],rax
	read	[fh],str1,16
	print	1,msg1,msg1_len
	print	1,str1,16
	mov	rdi,str1
	mov	rsi,str1
	inc	rsi
	inc	rsi
	mov	ch,08h
	
up2:	mov	cl,ch
up:	mov	bl,[rdi]
	mov	al,[rsi]
	cmp	bl,al
	jb	down
	mov	[rsi],bl
	mov	[rdi],al
down:	inc	rsi
	inc	rsi
	inc	rdi
	inc	rdi
	dec	cl
	jnz	up
	mov	rdi,str1
	mov	rsi,str1
	inc	rsi
	inc	rsi
	dec	ch
	jnz	up2
	
	print	1,msg2,msg2_len
	print	1,str1,20
	
	fileclose	[fh]
	mov	rax,60
	mov	rdi,0
	syscall	
