%define loc 0x1000
%define ftable 0x2000
%define drive 0x80
%define os_sect 3
%define ftabsect 2
[bits 16]
[org 0]

jmp 0x7c0:start

start:

	mov ax,cs
	mov ds,ax
	mov es,ax

	mov al,03h
	mov ah,0
	int 10h	


	mov si,msg
	call print

	mov ah,0
	int 16h

	mov ax,loc
	mov es,ax
	mov cl,os_sect ; sector
	mov al,2 ; number of sectors

	call loadsector

	mov ax,ftable
	mov es,ax
	mov cl,ftabsect ; sector
	mov al,1 ; number of sectors

	call loadsector
	

	jmp loc:0000 ; jump to our os


done:
	jmp $

loadsector:
	mov bx,0
	mov dl,drive ; drive
	mov dh,0 ; head
	mov ch,0 ; track
	mov ah,2
	int 0x13
	jc err
	ret
err:
	mov si,erro
	call print
	ret
print:
	mov bp,sp
	cont:
	lodsb
	or al,al
	jz dne
	mov ah,0x0e
	mov bx,0
	int 10h
	jmp cont
dne:
	mov sp,bp
	ret

msg db "Booting Successful..",10,13,"Press any key to continue !",10,13,10,13,0
erro db "Error loading sector ",10,13,0
times 510 - ($-$$) db 0
dw 0xaa55
