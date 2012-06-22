[bits 16]
[org 0]




start:

	mov ax,cs
	mov ds,ax
	mov es,ax


	
	mov ah,03
	mov bh,0
	int 10h
	
	call printstr
	
	jmp 0x1000:0

printstr:
	mov bp,msg
	mov ah,013h
	mov al,1
	mov bx,2 ;  color
	mov cx,104 ; strlen 
	int 0x10
ret


msg db "Author: Appu Sajeev",10,13,"Contact: appusajeev@gmail.com, http://appusajeev.wordpress.com",10,13,"Language: NASM 2.05"
