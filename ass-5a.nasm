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

%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

EXTERN		no_occ,no_space,no_new
global		numocc,getchar,str1,charcnt,spcnt,nlcnt

;-----------------------------------------------------------------
section .data
	msgmenu		db	10,13,"---------menu----------"
			db	10,13,"1. NO of occurrences"
			db	10,13,"2. NO of spaces"
			db	10,13,"3. NO of newlines"
			db	10,13,"4. Exit",10
	msgmenu_len	equ	$-msgmenu
	msgerr		db	"Invalid choice!",10
	msgerr_len	equ	$-msgerr
	msg1		db	10,13,"Enter character : "
	msg1_len	equ	$-msg1
	msg2		db	10,13,"character occurrence no : "
	msg2_len	equ	$-msg2
	msg3		db	10,13,"No of spaces : "
	msg3_len	equ	$-msg3
	msg4		db	10,13,"No of newlines : "
	msg4_len	equ	$-msg4
	fname		db	'tj.txt'
;-----------------------------------------------------------------
section .bss
	getnum		resb	2
	numocc		resb	2
	fh		resb	8
	getchar		resb	2
	str1		resb	75
	charcnt		resb	2
	spcnt		resb	2
	nlcnt		resb	2
;-----------------------------------------------------------------
global _start
section .text
_start:
	fileopen	fname
	mov	[fh],rax
	read	[fh],str1,75

	print	msgmenu,msgmenu_len
	read	0,getnum,2
	mov	rax,00
	mov	al,[getnum]
	
choice1:	cmp	al,31h
		jne	choice2
		print	msg1,msg1_len
		read	0,getchar,2
		call	no_occ
		print	msg2,msg2_len
		print	charcnt,2
		jmp _start
		
choice2:	cmp	al,32h
		jne	choice3
		call	no_space
		print	msg3,msg3_len
		print	spcnt,2
		jmp _start	

choice3:	cmp	al,33h
		jne	choice4
		call	no_new
		print	msg4,msg4_len
		print	nlcnt,2
		jmp _start
		
choice4:	cmp	al,34h
		jne	error
		jmp	exit	
		
error:		print	msgerr,msgerr_len
		jmp _start
		
exit:		fileclose	[fh]
		mov	rax,60
		mov	rdi,0
		syscall		
