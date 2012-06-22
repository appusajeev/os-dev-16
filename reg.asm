
[bits 16]
[org 0]
push ax
mov ax,cs
mov ds,ax
mov es,ax
pop ax
;push testt
;call print
push axx
push ax
call tohex

push bxx
push bx
call tohex

push cxx
push cx
call tohex

push dxx
push dx
call tohex

push css
push cs
call tohex

push dss
push ds
call tohex

push sss
push ss
call tohex

push ess
push es
call tohex

push spp
push sp
call tohex

push sii
push si
call tohex

push dii
push di
call tohex

push gss
push gs
call tohex


push fss
push fs
call tohex


jmp 0x1000:0


print:	;print a zero terminated string
	pusha
	mov bp,sp
	mov si,[bp+18] 
	cont:
		lodsb
		or al,al
		jz dne
		mov ah,0x0e
		mov bx,0
		mov bl,7
		int 10h
		jmp cont
	dne:
		mov sp,bp
		popa
		ret




tohex:
	pusha
	mov bp,sp
	mov dx, [bp+20]
	push dx	
	call print
	mov dx,[bp+18]

	mov cx,4
	mov si,hexc
	mov di,hex+2
	
	stor:
	
	rol dx,4
	mov bx,15
	and bx,dx
	mov al, [si+bx]
	stosb
	loop stor
	push hex
	call print
	mov sp,bp
	popa
	ret
hex db "0x0000",10,13,0
hexc db "0123456789ABCDEF"
testt db "hello",10,13,0
css db "CS: ",0
dss db "DS: ",0
sss db "SS: ",0
ess db "ES: ",0
gss db "GS: ",0
fss db "FS: ",0
axx db "AX: ",0
bxx db "BX: ",0
cxx db "CX: ",0
dxx db "DX: ",0
spp db "SP: ",0
bpp db "BP: ",0
sii db "SI: ",0
dii db "DI: ",0

