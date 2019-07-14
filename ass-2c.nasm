%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
syscall	
%endmacro	

global _start
section .data

	space db 20h
	enter1 db 0ah
	msg1 db "Numbers in array 1:"
	msg1len equ $-msg1
	msg2 db "Numbers in array 2:"
	msg2len equ $-msg2
	len db 06h
	arr db 26h,34h,65h,72h,17h,50h

section .bss
	temp resb 12
	arr2 resb 12
	arr3 resb 18

section .text
_start:

	mov rcx,00h
	mov cl,[len]
	mov rsi,arr
	mov rdi,arr2
up:	mov al,[rsi]
	mov [rdi],al
	inc rsi
	inc rdi
	dec cl
	jnz up
	
	mov rsi,arr
	mov rdi,arr3
	mov ch,[len]
	call printarr
	
	print msg1,msg1len
	print enter1,1
	print arr3,18h
	print enter1,1
	
	mov rsi,arr2
	mov rdi,arr3
	mov ch,[len]
	call printarr
	
	print msg2,msg2len
	print enter1,1
	print arr3,18h
	print enter1,1
	
	mov rax,60
	mov rdi,0
syscall

printarr:	
up3:	mov ah,[rsi]
	mov cl,02h
up2:	rol ah,4
	mov bh,ah
	and ah,0fh
	cmp ah,09h
	ja down
	add ah,30h
	jmp down2
down:	add ah,37h
down2:	mov [rdi],ah
	mov ah,bh
	inc rdi
	dec cl
	jnz up2
	mov byte [rdi],20h
	inc rdi
	inc rsi
	dec ch
	jnz up3
ret
