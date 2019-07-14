%macro input1 1
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,1
syscall	
%endmacro	

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
	mov cl,02h
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

	space db 20h
	enter1 db 0ah
	msg1 db "array is:"
	msg1len equ $-msg1
	msg2 db "Give input for overlap : "
	msg2len equ $-msg2
	msg3 db "Array after overlap:"
	msg3len equ $-msg3
	cnt db 05h
	len db 05h
	len2 db 12h
	arr db 32h,33h,34h,35h,36h
section .bss

	temp resb 10
	arr1 resb 16
	ovr resb 1

section .text
_start:
	
	print msg2,msg2len
	input1 ovr
	mov bh,[ovr]
	sub bh,30h
	mov [ovr],bh
	mov rax,00
	mov al,[cnt]
	dec rax
	mov rsi,arr
	add rsi,rax
	mov rax,00
	mov al,[cnt]
	sub al,[ovr]
	mov rdi,rsi
	add rdi,rax
		
	mov rcx,00h
	mov cl,[cnt]
	std
	repz movsb
	
	print msg3,msg3len
	print enter1,1
	
	mov rdx,00h
	mov dl,[len]
	add dl,[len]
	sub dl,[ovr]
	
	printarr arr,arr1,dl
	
	mov rdx,00h
	add dl,[len2]
	mov cl,05h
	sub cl, byte [ovr]
up4:	add dl,03h
	dec cl
	jnz up4
	
	print arr1,rdx
	print enter1,1
	mov rax,60
syscall
