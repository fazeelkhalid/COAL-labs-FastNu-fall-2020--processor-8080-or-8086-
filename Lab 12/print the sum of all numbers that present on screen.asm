[org 0x100]

jmp start
printnum:
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di,3984;
	mov bh,0x07;
	mov [es:di],bx;
ret

addNumber:
	add bl,al;
	jmp insideLoop1;
isNumber:
	cmp al,0x40;
	jb addNumber;
	jmp insideLoop1
	
read:
	
	;sum will be in bl regester
	mov bl,0;
	mov ax,0xb800
	mov es,ax;
	mov si,0;
	mov cx,2000
	
	loop1:
		lodsw;
		cmp byte al,0x29
		ja isNumber;
		insideLoop1:
		dec cx
		cmp cx,0;
		jne loop1;
ret

start:
	call read;
	call printnum
Mov ax, 4C00h
Int 21