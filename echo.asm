[bits 16]
[org 0]


start:

	mov ax,cs
	mov ds,ax
	mov es,ax


	mov di,arr	
	
	cont:
	mov ah,0
	int 16h 	;read char, al=char

	cmp al,0dh 	; is al=enter
	jz done
	mov ah,0eh
	int 10h
	stosb
	jmp cont
	
	done:

	mov al,10	
	mov ah,0eh
	int 10h
	mov al,13
	mov ah,0eh
	int 10h

	push arr
	call printstr
	
jmp 0x1000:0

printstr:
	pusha
	mov bp,sp
	mov si, [bp+18]
	k:
	lodsb
	cmp al,0
	jz fin
	mov ah,0eh
	int 10h
	jmp k	

	fin:
	mov sp,bp
	popa
        ret	



arr  times 50 db 0


