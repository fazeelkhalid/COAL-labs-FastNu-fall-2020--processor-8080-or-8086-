[org 0x0100]
jmp main

clearScreen:
	; save ax,es,di value in stack;
	push ax;
	push es;
	push di;
	mov ax, 0xb800 ; load video base in ax
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
	nextchar: 
	mov word [es:di], 0x0720 ; print space on screen
	add di, 2; move at next screen location
	cmp di, 4000 ; check is all screen cleared?
	jne nextchar; if all screen not cleared then jump;
	;pop ax,es,di value from stack
	pop di;
	pop es;
	pop di;
	ret

delley:; use for delley 
	; push ax in stack
	push ax;
	mov ax, 0;
	loop1:
		add ax,1;
		cmp ax, 65535;
		jne loop1;
	pop ax
	ret
DisplayCharacter:
	mov ax,0xb800; load video base in ax
	mov es,ax; point es to video base
	mov di,1920; point di to top left column
	mov si,2078; ; point si to top right column
	
	move:
		mov word [es:di], 0x043E ; print " > " on screen in red color
		mov word [es:si], 0x033C ; print " < " on screen in ble color
		call delley
		mov word [es:di], 0x0720 ; print space where " > " occur
		mov word [es:si], 0x0720 ; print space where " < " occur
		
		add di,2; // move at next position
		sub si,2; // move at previous position
	
		cmp di,si; // compare si and di 
		jna move; // if both are not equal then jump
	
	ret 
main:
	call clearScreen
	call DisplayCharacter;
	
 mov ax, 0x4c00 ; terminate program
 int 0x21 