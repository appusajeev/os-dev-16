[bits 16]
[org 0]

;in disp mem, (attr/8)%8 gives bkcolor, attr%8 gives char color,
; 8 different char colors, and 8 different bkcolor 
;so , attr byte can take values from 0 to 63

start:
	mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,0xb800
	mov gs,ax
	mov bx,0

	mov si,msg
	mov ch,1
	cont:
		lodsb 
		or al,al
		jz done
	
		mov byte [gs:bx],al
		mov byte [gs:bx+1],ch
		inc ch
		add bx,2
	jmp cont		
	done:

		jmp 0x1000:0
	
msg db "Demonstration of Writing to Video memory ! Cool, aint it??",0
