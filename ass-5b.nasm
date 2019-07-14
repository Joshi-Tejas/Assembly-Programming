
EXTERN		numbocc,getchar,str1,charcnt,spcnt,nlcnt
global		no_occ,no_space,no_new


global _startb
section .text
_startb:

no_occ:
	mov	cl,00
	mov	[charcnt],cl
	mov	rsi,str1
	mov	dl,[getchar]
up:	
	cmp	byte [rsi],00h
	je	down
	cmp	byte [rsi],dl
	je	down2
	inc	rsi
	jmp	up
down2:	inc	byte [charcnt]
	inc	rsi
	jmp	up	
down:	
	mov	cl,30h
	add	[charcnt],cl	
	ret
	
no_space:
	mov	rsi,str1
up2:	
	cmp	byte [rsi],00h
	je	down3
	cmp	byte [rsi],20h
	je	down4
	inc	rsi
	jmp	up2
down4:	inc	byte [spcnt]
	inc	rsi
	jmp	up2	
down3:	
	mov	cl,30h
	add	[spcnt],cl	
	ret
	
no_new:
	mov	rsi,str1
up3:	
	cmp	byte [rsi],00h
	je	down5
	cmp	byte [rsi],0ah
	je	down6
	inc	rsi
	jmp	up3
down6:	inc	byte [nlcnt]
	inc	rsi
	jmp	up3	
down5:	
	mov	cl,30h
	add	[nlcnt],cl	
	ret	
