[org 0x0100]
jmp main

replace:
	jmp skip
	match:
		add bx,1;
		mov [si],al
		jmp insideSearch
	
	skip:
	push bp;
	mov bp, sp;
	mov si,[bp+10]; point string;
	mov bx,[bp+8]; point length;
	mov cx,[bx];store string size;
	mov bx,[bp+4];point char that we want to put in string	
	mov byte al,[bx];
	
	mov bx,[bp+6];point replace char that we want to search and replace with other char
	mov byte ah,[bx];
	
	mov bx,0;reset bx
	
	search:
		cmp [si],ah
		je match
		
		insideSearch:
		
		add si,1
		dec cx
		loop search;
	mov[bp+4],bx;
	pop bp
ret
	
main:
	mov ax,inputString;
	push ax;
	mov ax,stringlength;
	push ax;
	mov ax,replaceChar;
	push ax;
	mov ax,replaceWith;
	push ax;
	
	call replace;
	; now pop all values;
	pop ax; store repeting char
	pop bx;
	pop bx;
	pop bx;
	

mov ax, 0x4c00 ; terminate program
int 0x21

inputString: db"My anamaae iaas shaaemaeaear";
stringlength: dw 28;
replaceChar: db 'a';
replaceWith: db 'x';