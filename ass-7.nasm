%macro print 3
	mov rax,1
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
syscall
%endmacro

%macro read 3
	mov rax,0
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
syscall
%endmacro

%macro fopen 1
	mov	rax,2
	mov	rdi,%1
	mov	rsi,2
	mov	rdx,0777o
	syscall
%endmacro

%macro fclose 1
	mov	rax,3
	mov	rdi,%1
	syscall
%endmacro

;-------------------------------------------------------------------
section .data
	cmnd1		db	"DELETE"
	cmnd1_len	equ	$-cmnd1
	cmnd2		db	"COPY"
	cmnd2_len	equ	$-cmnd2
	cmnd3		db	"TYPE"
	cmnd3_len	equ	$-cmnd3
	dummyfile	db	'cpy.txt'
;-------------------------------------------------------------------
section .bss
	
	filename	resb	20
	cmndaddr	resb	8
	fileaddr	resb	8
	fh		resb	8
	str1		resb	256
;-------------------------------------------------------------------
global _start:
section .text
_start:
	pop	rbx
	pop	rcx
	pop	rsi
	mov	[cmndaddr],rsi
	pop	rdi
	mov	[fileaddr],rdi
	
	mov	rsi,[cmndaddr]
	mov	rdi,cmnd1
	mov	cl,cmnd1_len
up1:	mov	al, byte [rsi]
	mov	bl, byte [rdi]
	inc	rsi
	inc	rdi
	dec	cl
	jz	down1
	cmp	al,bl
	je	up1
	jmp	down2
	
down1:	print	1,cmnd1,cmnd1_len
	mov	rax,87
	mov	rdi,[fileaddr]
	syscall
	call	exit	
	
down2:	mov	rsi,[cmndaddr]
	mov	rdi,cmnd2
	mov	cl,cmnd2_len
up2:	mov	al, byte [rsi]
	mov	bl, byte [rdi]
	inc	rsi
	inc	rdi
	dec	cl
	jz	down3
	cmp	al,bl
	je	up2
	jmp	down4

down3:	print	1,cmnd2,cmnd2_len
	fopen	[fileaddr]
	mov	[fh],rax
	read	[fh],str1,256
	fclose	[fh]
	fopen	dummyfile
	mov	[fh],rax
	print	[fh],str1,256
	call	exit
	
down4:	mov	rsi,[cmndaddr]
	mov	rdi,cmnd3
	mov	cl,cmnd3_len
up3:	mov	al, byte [rsi]
	mov	bl, byte [rdi]
	inc	rsi
	inc	rdi
	dec	cl
	jz	down5
	cmp	al,bl
	je	up3
	jmp	exit
	
down5:	print	1,cmnd3,cmnd3_len
	fopen	[fileaddr]
	mov	[fh],rax
	read	[fh],str1,256
	print	1,str1,256
	fclose	[fh]
	
exit:	mov	rax,60
	mov	rdi,0
	syscall
