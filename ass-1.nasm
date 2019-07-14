%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
syscall	
%endmacro	

%macro printarr 3
	mov rsi,%1
	mov rdi,%2
	mov ch,%3
up3:	mov ah,[rsi]
	mov cl,02
up2:	rol ah,4
	mov bh,ah
	and ah,0fh
	cmp ah,09h
	ja label3
	add ah,30h
	jmp label4
label3: add ah,37h
label4: mov [rdi],ah
	mov ah,bh
	inc rdi
	dec cl
	jnz up2
	mov byte [rdi]," "
	inc rdi
	inc rsi
	dec ch
	jnz up3
%endmacro	

global _start
	
section .data
	enter1 db 0ah
	msg1 db "Array is : "
	msg1len equ $-msg1
	msg2 db "Positive nos : "
	msg2len equ $-msg2
	msg3 db "Negative nos : "
	msg3len equ $-msg3
	arr db 81h,31h,33h,83h,35h,41h,84h
section .bss
	posit resb 2
	neget resb 2
	vara resb 20
	
section .text
_start:
	mov cl,07h
	mov bh,00h
	mov ch,00h
	mov rsi,arr
up:	mov ah,[rsi]
	bt ax,15
	jc label1
	add ch,01h
	jmp label2
label1: add bh,01h
label2: inc rsi
	dec cl
	jnz up
	mov [posit],ch
	mov [neget],bh
		
	print msg1,msg1len
	printarr arr,vara,07
	print vara,30
	print enter1,1
	
	mov rsi,posit
	call change
	print msg2,msg2len
	print posit,2
	print enter1,1
	
	mov rsi,neget
	call change
	print msg3,msg3len
	print neget,2
	print enter1,1

	mov rax,60
	mov rdi,0
syscall

change: 
	mov cl,02h
	mov ah,[rsi]
up1:	rol ah,4
	mov bh,ah
	and ah,0fh
	cmp ah,09h
	ja down1
	add ah,30h
	jmp down2
down1:  add ah,37h	
down2:	mov [rsi],ah
	inc rsi
	mov ah,bh
	dec cl
	jnz up1
ret
