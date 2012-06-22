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
	mov cx,161; strlen 
	int 0x10
ret


msg db "echo - reads a user input and echoes it back to screen",10,13,"reg - dumps registers",10,13,"vidmem - demonstrates writing to Video Memory",10,13,"exit - reboot",10,13,"about - general info"
