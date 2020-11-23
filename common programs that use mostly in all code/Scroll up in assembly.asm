[org 0x0100]
jmp main
clearBottomLines:
	push ax
	push si
	push es
	push cx
	
	
	mov ax,0xb800
	mov es,ax
	
	mov ax,80;
	mul bx;
	sub cx,ax;
	mov cx,2000;
	mov di, cx;
	shl di,1;
	mov cx,ax;
	
	mov ax,0x0720;

	
	cld
	rep stosw;
	
	pop cx
	pop es;
	pop si;
	pop ax;
	
ret;

scrolUp:
	;bx bring number of rows that we want to scroll up
	push ax;
	push es;
	push si;
	push di;
	push ds;
	
	mov cx,2000;
	mov di,0; printing start from here

	mov ax, 0xb800;
	mov es,ax;
	mov ds,ax;
	
	mov ax,80;
	mul bx; ax = ax * bx
	sub cx,bx;
	mov si,ax; // copy start from here
	shl si,1;
	
	cld;
	rep movsw
	call clearBottomLines
	pop ds
	pop di
	pop si
	pop es
	pop ax;
ret;
	
main:
	mov bx,4;
	call scrolUp

mov ax, 0x4c00 ; terminate program
int 0x21

string: db "fazeelKhalid",0; NULL terminated string