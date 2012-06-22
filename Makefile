dev = /dev/sdc
ASMFLAGS = -f bin


all:bootloader os  about vidmem echo help exit reg install
	cpy $(dev) bootloader os about vidmem echo help exit reg
	@echo "Done...Written to disk"
	

bootloader:bootloader.asm
	nasm $(ASMFLAGS) bootloader.asm

os:os.asm
	nasm $(ASMFLAGS) os.asm


reg:reg.asm
	nasm $(ASMFLAGS) reg.asm


about:about.asm
	nasm $(ASMFLAGS) about.asm

help:help.asm
	nasm $(ASMFLAGS) help.asm


vidmem:vidmem.asm
	nasm $(ASMFLAGS) vidmem.asm

echo:echo.asm
	nasm $(ASMFLAGS) echo.asm

exit:exit.asm
	nasm $(ASMFLAGS) exit.asm


install:cpy.c
	cc cpy.c -o cpy
	cp cpy /bin/cpy

clean:
	rm bootloader
	rm os
	rm echo
	rm vidmem
	rm about
	rm filetable
	rm help
	rm reg
	rm exit
