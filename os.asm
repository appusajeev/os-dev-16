%define drive 0x80
%define ploc 0x9000
[bits 16]
[org 0]

start:
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ax,0x7000	
	mov ss,ax	; stack segment initialisation
	mov sp,ss

	cmp byte [first],0
	jnz skip_msg

	push welcome	;argument to function, stack method used
	call print
	mov byte [first],1
	
	skip_msg:

	mov ax,0x2000 	;address where the file table is loaded
	mov gs,ax
	mov bx,0

	show_prompt:
		push prompt 	
		call print
		
		push query
		call readcmd
		
		call search
		
		jmp show_prompt



;================================FUNCTIONS======================================


readcmd:	; read an exe name from the user
	pusha
	mov bp,sp
	cld
	mov byte  [charcount],0
	mov di,[bp+18]
	continue_read:
		mov ah,0
		int 16h
		cmp al,0dh
		jz fin
		mov ah,0x0e
		mov bx,0
		int 10h
		stosb
		inc byte [charcount]
		jmp continue_read	
	fin:
		push nl
		call print
		mov sp,bp
		popa
		ret


search:		; search the filetable for the file
	pusha
	mov bp,sp 

	cmp ax,ax ; to set zero flag
	mov di,query

	mov bx,0
	cld
	cont_chk:
		mov al,[gs:bx]
		cmp al,'}'
		
		je complete	

		cmp al,[di]
		je chk
		inc bx
		jmp cont_chk

	chk:
		push bx
		mov cx, [charcount] 
	check:
		mov al,[gs:bx]
		inc bx
		
		scasb
		loope check
		
		je succ

		mov di,query
		pop bx
		inc bx
		jmp cont_chk
	
	complete:
		push fail
		call print
		jmp en
	succ:
		
		inc bx
		push  bx
		
		call findsect
	en:
		mov sp,bp
		popa
		ret


findsect:	; find the sector containing the given file	
	pusha
	mov bp,sp
	mov bx,[bp+18]
	cld
	mov word [sect],0
	mov cl,10
	cont_st:
		mov al,[gs:bx]
		inc bx
		cmp al,','
		jz finish
		cmp al,48
		jl mismatch
		cmp al,58
		jg mismatch
		sub al,48
		mov ah,0
		mov dx,ax
		mov ax,word [sect]
		mul cl
		add ax,dx
		mov word [sect],ax		
		jmp cont_st
		finish:
			push word [sect]
			
			call load 	;load exe in memory

		
			jmp ploc:0000  ;switching to our program 

		mismatch_end:
			mov sp,bp
			popa
			ret
		mismatch:
			push fail
			call print
			jmp mismatch_end

load:		;load the specified sector into RAM
	pusha
	mov bp,sp
	
	mov ah,0
	mov dl,0x80
	int 0x13

	mov ax,ploc
	mov es,ax
	mov cl,[bp+18] 
	mov al,1
	mov bx,0
	mov dl,drive 
	mov dh,0 
	mov ch,0 
	mov ah,2
	int 0x13
	jnc success
	err:
			push erro
			call print
	success:
		mov sp,bp
		popa
		ret

		
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
	mov dx, [bp+18]
	
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


welcome db "Welcome ! Type help or about to know more",10,13,0
erro db "Error loading sector",10,13,0
fail db "File not found !",0
query times 30 db 0
arr times 10 db 0
first_time db 1
nl db 10,13,0
prompt db 10,13, ">>",0
charcount dw 0

hex db "0x0000",10,13,0
hexc db "0123456789ABCDEF"
first db 0
sect dw 0












