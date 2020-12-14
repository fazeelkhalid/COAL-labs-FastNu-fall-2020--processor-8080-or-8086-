[org 0x0100]
jmp start

nextLine:
	add si,320
	jmp insideloop1;

swap:
	push ax
	mov ax,0xb800
	mov es,ax
	mov di,1920;
	mov si,2080;
	
	loop1:
		mov cx,[es:di]
		mov dx,[es:si]			
		mov word[es:di],dx
		mov word[es:si],cx
		mov dx, 0; // restroe regester;
		
		
		sub si,2
		sub di,2
		mov ax, si;
		mov bx,160;

		div bx;
		cmp dx,0
		je nextLine;
		insideloop1:
		cmp di,0xFFFE
	jne loop1
	end:
	pop ax
ret

start:

call swap
mov ax,0x4c00
int 0x21